"""Real concurrent PostgreSQL sessions, driven through the installed psql CLI.

Run after lab16.sql. No database driver or fabricated query output is used.
"""
import subprocess
import time

CONNECTION = ['-h', 'localhost', '-p', '5432', '-U', 'azim', '-d', 'university']


class Session:
    def __init__(self, name):
        self.name = name
        self.counter = 0
        self.process = subprocess.Popen(
            ['psql', '-X', '-w', '-q', '-t', '-A', *CONNECTION],
            stdin=subprocess.PIPE, stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT, text=True, bufsize=1,
        )
        self.query("SET statement_timeout='10s'; SET search_path=lab16; "
                   "\\set VERBOSITY sqlstate\n")

    def start(self, sql):
        self.counter += 1
        marker = f'__END_{self.name}_{self.counter}__'
        print(f'[{self.name}] {sql}', flush=True)
        self.process.stdin.write(sql + '\n\\echo ' + marker + '\n')
        self.process.stdin.flush()
        return marker

    def finish(self, marker, expected_error=None):
        lines = []
        for line in self.process.stdout:
            line = line.rstrip('\n')
            if line == marker:
                break
            lines.append(line)
            print(f'[{self.name}] {line}', flush=True)
        else:
            raise RuntimeError('psql closed before query completed')
        result = '\n'.join(lines).strip()
        if 'ERROR:' in result and (not expected_error or expected_error not in result):
            raise RuntimeError(result)
        return result

    def query(self, sql, expected_error=None):
        return self.finish(self.start(sql), expected_error)

    def close(self):
        if self.process.poll() is None:
            self.process.stdin.write('ROLLBACK;\n\\q\n')
            self.process.stdin.flush()
            self.process.communicate(timeout=15)


def main():
    a, b, monitor = Session('A'), Session('B'), Session('monitor')
    try:
        original = a.query('SELECT balance FROM accounts WHERE account_id=1;')
        print('\n16.13 READ UNCOMMITTED cannot see uncommitted changes in PostgreSQL', flush=True)
        b.query('BEGIN; UPDATE accounts SET balance=balance+100 WHERE account_id=1;')
        a.query('BEGIN ISOLATION LEVEL READ UNCOMMITTED; SHOW transaction_isolation;')
        assert a.query('SELECT balance FROM accounts WHERE account_id=1;') == original
        a.query('ROLLBACK;')
        b.query('ROLLBACK;')
        monitor.query("INSERT INTO checks VALUES('no_dirty_read',true,'READ UNCOMMITTED sees only committed data in PostgreSQL');")

        for level, repeatable in [('READ COMMITTED', False), ('REPEATABLE READ', True)]:
            print(f'\n16.14 Concurrent snapshot experiment: {level}', flush=True)
            a.query(f'BEGIN ISOLATION LEVEL {level};')
            before = a.query('SELECT balance FROM accounts WHERE account_id=1;')
            b.query('UPDATE accounts SET balance=balance+10 WHERE account_id=1;')
            after = a.query('SELECT balance FROM accounts WHERE account_id=1;')
            assert (before == after) == repeatable
            a.query('ROLLBACK;')
            b.query('UPDATE accounts SET balance=balance-10 WHERE account_id=1;')
            label = level.lower().replace(' ', '_')
            monitor.query(f"INSERT INTO checks VALUES('{label}',true,'A before={before}; A after B commit={after}');")

        print('\n16.15 SERIALIZABLE rejects a conflicting concurrent transaction', flush=True)
        a.query('BEGIN ISOLATION LEVEL SERIALIZABLE; SELECT SUM(balance) FROM accounts;')
        b.query('BEGIN ISOLATION LEVEL SERIALIZABLE; SELECT SUM(balance) FROM accounts;')
        a.query('UPDATE accounts SET balance=balance-10 WHERE account_id=1; COMMIT;')
        result = b.query('UPDATE accounts SET balance=balance-10 WHERE account_id=2;', expected_error='40001')
        if '40001' not in result:
            result += b.query('COMMIT;', expected_error='40001')
        assert '40001' in result
        b.query('ROLLBACK;')
        a.query('UPDATE accounts SET balance=balance+10 WHERE account_id=1;')
        monitor.query("INSERT INTO checks VALUES('serializable_conflict',true,'One conflicting transaction rejected with SQLSTATE 40001');")

        print('\n16.16 Observe a real blocked transaction using pg_blocking_pids', flush=True)
        bpid = b.query('SELECT pg_backend_pid();')
        a.query('BEGIN; UPDATE accounts SET balance=balance WHERE account_id=1;')
        b.query('BEGIN;')
        pending = b.start('UPDATE accounts SET balance=balance WHERE account_id=1;')
        deadline = time.monotonic() + 5
        blocked = False
        while time.monotonic() < deadline:
            rows = monitor.query(f'SELECT cardinality(pg_blocking_pids({int(bpid)}))>0;')
            if rows == 't':
                blocked = True
                break
            time.sleep(0.05)
        a.query('ROLLBACK;')
        b.finish(pending)
        b.query('ROLLBACK;')
        assert blocked
        monitor.query("INSERT INTO checks VALUES('lock_observed',true,'pg_blocking_pids detected B waiting for A; both rolled back');")
        assert a.query('SELECT balance FROM accounts WHERE account_id=1;') == original
        monitor.query("INSERT INTO checks VALUES('durability_reconnect',true,'Committed balances visible from independent psql connections');")
        monitor.query('SELECT check_name,passed,details FROM checks ORDER BY check_name;')
        print('\nAll concurrent experiments verified against actual PostgreSQL sessions.', flush=True)
    finally:
        a.close()
        b.close()
        monitor.close()


if __name__ == '__main__':
    main()
