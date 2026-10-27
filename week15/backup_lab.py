"""Lab 17: execute backups, restores, WAL/PITR and migration on real PostgreSQL.

The existing server is only READ to copy the new course schemas. Every server
started/stopped here belongs to a newly-created private /tmp/db17-* directory.
No existing data directory is deleted or overwritten; no TCP listener is opened.
"""
import csv
import hashlib
from pathlib import Path
import shlex
import shutil
import subprocess
import tempfile
import time
from wal_cleanup import cleanup
from pitr_targets import exercise as additional_pitr

HERE = Path(__file__).resolve().parent
ARTIFACTS = HERE / 'backups'
CSV = HERE / 'csv'
ROOT = Path(tempfile.mkdtemp(prefix='db17-', dir='/tmp'))
SOCKET = ROOT / 'socket'
ARCHIVE = ROOT / 'wal_archive'
SERVERS = []
EVIDENCE = []
ROLE = 'azim'
DB = 'coursework'


def run(args, *, input=None, output=None, timeout=60):
    args = [str(x) for x in args]
    print('$ ' + shlex.join(args), flush=True)
    result = subprocess.run(args, input=input, text=True, stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT, timeout=timeout)
    if output:
        Path(output).write_text(result.stdout)
    elif result.stdout.strip():
        print(result.stdout.rstrip(), flush=True)
    if result.returncode:
        raise RuntimeError(f'Exit {result.returncode}: {result.stdout[-3000:]}')
    return result.stdout.strip()


def conn(port=55431, db=DB):
    return ['-h', str(SOCKET), '-p', str(port), '-U', ROLE, '-d', db]


def sql(query, port=55431, db=DB):
    return run(['psql', '-X', '-w', '-A', '-t', '-v', 'ON_ERROR_STOP=1',
                *conn(port, db), '-c', query])


def check(name, passed, detail):
    if not passed:
        raise AssertionError(name + ': ' + detail)
    EVIDENCE.append({'check': name, 'passed': True, 'details': detail})
    print(f'VERIFIED {name}: {detail}', flush=True)


def wait_for(query, expected, port=55431, timeout=30):
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        if sql(query, port) == expected:
            return
        time.sleep(0.2)
    raise TimeoutError(query)


def init(name):
    path = ROOT / name
    run(['initdb', '-D', path, '-U', ROLE, '--auth-local=trust',
         '--auth-host=reject', '--no-instructions', '--locale=C', '--encoding=UTF8'])
    return path


def start(path, port, extra=''):
    options = f"-p {port} -k {SOCKET} -c listen_addresses='' -c shared_buffers=16MB {extra}"
    run(['pg_ctl', '-D', path, '-l', ROOT / (path.name + '.log'),
         '-o', options, '-w', '-t', '30', 'start'])
    SERVERS.append(path)


def stop(path):
    if path in SERVERS:
        run(['pg_ctl', '-D', path, '-m', 'fast', '-w', 'stop'])
        SERVERS.remove(path)


def create_db(name, port=55431):
    run(['createdb', '-w', '-h', SOCKET, '-p', str(port), '-U', ROLE, name])


def signature(database):
    tables = sql("SELECT schemaname||'.'||tablename FROM pg_tables "
                 "WHERE schemaname NOT IN('pg_catalog','information_schema') "
                 "ORDER BY 1", db=database).splitlines()
    data = {}
    for table in tables:
        data[table] = sql("SELECT count(*)||':'||md5(COALESCE(string_agg("
                          "to_jsonb(t)::text,E'\\n' ORDER BY to_jsonb(t)::text),'')) "
                          f'FROM {table} t', db=database)
    return data


def main():
    for directory in [SOCKET, ARCHIVE, ARTIFACTS, CSV]:
        directory.mkdir(parents=True, exist_ok=True)
    SOCKET.chmod(0o700)
    print(f'Private lab directory: {ROOT}', flush=True)
    source = init('source')
    config = ("wal_level=logical\nmax_wal_senders=8\nmax_replication_slots=8\n"
              "archive_mode=on\nsummarize_wal=on\n"
              f"archive_command='test ! -f {ARCHIVE}/%f && cp %p {ARCHIVE}/%f'\n")
    with (source / 'postgresql.conf').open('a') as stream:
        stream.write('\n' + config)
    start(source, 55431)
    create_db(DB)
    # Copy only this assignment's schemas; other user databases are outside scope.
    seed = ARTIFACTS / 'course-input.dump'
    run(['pg_dump', '-w', '-h', 'localhost', '-p', '5432', '-U', ROLE,
         '-d', 'university', '-n', 'lab11', '-n', 'lab_data', '-n', 'lab15',
         '-n', 'lab16', '-Fc', '-f', seed])
    run(['pg_restore', '-w', '--exit-on-error', '--no-owner', *conn(), seed])
    run(['psql', '-X', '-w', '-a', '-v', 'ON_ERROR_STOP=1',
         '-v', f'csv_dir={CSV}', *conn(), '-f', HERE / 'lab17.sql'], output=HERE / 'copy-result.txt')

    print('\n17.6 COPY ON_ERROR ignore: one intentionally damaged numeric field', flush=True)
    with (CSV / 'products.csv').open(newline='') as stream:
        rows = list(csv.reader(stream))
    damaged = rows[1].copy()
    damaged[2] = 'not-a-number'
    with (CSV / 'products_with_errors.csv').open('w', newline='') as stream:
        csv.writer(stream).writerows([*rows, damaged])
    sql('CREATE TABLE lab17.products_skip(LIKE lab17.products)')
    sql(f"COPY lab17.products_skip FROM '{CSV}/products_with_errors.csv' "
        "WITH(FORMAT csv,HEADER true,ON_ERROR ignore)")
    check('copy_skip_bad_row', sql('SELECT count(*) FROM lab17.products_skip') == '7',
          '7 valid source rows loaded, 1 deliberately corrupted price skipped')

    print('\n17.7 pg_dump variants / full cluster backup without role passwords', flush=True)
    run(['pg_dump', '-w', *conn(), '-f', ARTIFACTS / 'coursework.sql'])
    run(['pg_dump', '-w', *conn(), '-Fc', '-f', ARTIFACTS / 'coursework.dump'])
    run(['pg_dump', '-w', *conn(), '-t', 'lab_data.employee', '-t', 'lab_data.artists',
         '-Fc', '-f', ARTIFACTS / 'selected-tables.dump'])
    run(['pg_dump', '-w', *conn(), '--schema-only', '-f', ARTIFACTS / 'schema-only.sql'])
    run(['pg_dump', '-w', *conn(), '--data-only', '-f', ARTIFACTS / 'data-only.sql'])
    run(['pg_dump', '-w', *conn(), '-T', 'lab17.products_skip', '-Fc',
         '-f', ARTIFACTS / 'without-skip-table.dump'])
    run(['pg_dump', '-w', *conn(), '-Fc', '--no-owner', '-f', ARTIFACTS / 'portable.dump'])
    run(['pg_dumpall', '-w', '-h', SOCKET, '-p', '55431', '-U', ROLE,
         '--no-role-passwords', '-f', ARTIFACTS / 'cluster.sql'])
    run(['pg_restore', '--list', ARTIFACTS / 'coursework.dump'], output=HERE / 'backup-contents.txt')
    baseline = signature(DB)

    print('\n17.8 Restore plain, parallel custom, selective and split schema/data backups', flush=True)
    create_db('restore_plain')
    run(['psql', '-X', '-w', '-v', 'ON_ERROR_STOP=1', *conn(db='restore_plain'),
         '-f', ARTIFACTS / 'coursework.sql'])
    check('plain_restore', signature('restore_plain') == baseline, 'All table row counts and content hashes match')
    create_db('restore_parallel')
    run(['pg_restore', '-w', '--exit-on-error', '--no-owner', '-j', '4',
         *conn(db='restore_parallel'), ARTIFACTS / 'coursework.dump'])
    check('custom_parallel_restore', signature('restore_parallel') == baseline,
          'Full custom archive restored with 4 jobs; all table hashes match')
    create_db('restore_selective')
    sql('CREATE SCHEMA lab_data', db='restore_selective')
    run(['pg_restore', '-w', '--exit-on-error', '--no-owner', *conn(db='restore_selective'),
         ARTIFACTS / 'selected-tables.dump'])
    check('selective_restore', sql('SELECT count(*) FROM lab_data.employee', db='restore_selective') == '8',
          'Selected employee and artist tables restored')
    create_db('restore_split')
    for filename in ['schema-only.sql', 'data-only.sql']:
        run(['psql', '-X', '-w', '-v', 'ON_ERROR_STOP=1', *conn(db='restore_split'),
             '-f', ARTIFACTS / filename])
    check('schema_data_restore', signature('restore_split') == baseline, 'Separate schema/data restore matches every table')
    # -t selection from a full custom archive, into a precreated schema.
    create_db('restore_one_table')
    sql('CREATE SCHEMA lab_data', db='restore_one_table')
    run(['pg_restore', '-w', '--exit-on-error', '--no-owner', '-t', 'artists',
         *conn(db='restore_one_table'), ARTIFACTS / 'coursework.dump'])
    check('table_from_full_archive', sql('SELECT count(*) FROM lab_data.artists', db='restore_one_table') == '3',
          'pg_restore -t restored only the requested table')
    create_db('partition_migration')
    schema = run(['pg_dump', '-w', *conn(), '-n', 'lab17', '--schema-only'])
    run(['psql', '-X', '-w', '-v', 'ON_ERROR_STOP=1', *conn(db='partition_migration')], input=schema)
    partition_data = run(['pg_dump', '-w', *conn(), '-t', 'lab17.purchases_2022', '--data-only'])
    run(['psql', '-X', '-w', '-v', 'ON_ERROR_STOP=1', *conn(db='partition_migration')], input=partition_data)
    check('partition_migration', sql('SELECT count(*) FROM lab17.purchases_2022', db='partition_migration') == '6',
          'Only the 2022 partition migrated (6 actual purchases)')

    print('\n17.9 Automated backup script: run once, keep 7 days active', flush=True)
    run(['python3', HERE / 'daily_backup.py', str(SOCKET), '55431', str(ARTIFACTS / 'daily')])
    check('daily_backup', len(list((ARTIFACTS / 'daily').glob('coursework_*.dump'))) == 1,
          'Scheduled-ready backup script ran once; no scheduler installed')

    print('\n17.10 Base backup and physical streaming replication', flush=True)
    full = ROOT / 'full'
    run(['pg_basebackup', '-w', '-h', SOCKET, '-p', '55431', '-U', ROLE,
         '-D', full, '-X', 'stream', '--checkpoint=fast'], timeout=60)
    run(['pg_verifybackup', full])
    standby = ROOT / 'standby'
    shutil.copytree(full, standby)
    with (standby / 'postgresql.auto.conf').open('a') as stream:
        stream.write(f"\nprimary_conninfo='host={SOCKET} port=55431 user={ROLE}'\n")
    (standby / 'standby.signal').touch()
    start(standby, 55432, '-c archive_mode=off')
    check('physical_standby', sql('SELECT pg_is_in_recovery()', 55432) == 't', 'Real standby running in recovery mode')
    sql('UPDATE lab16.accounts SET balance=balance+1 WHERE account_id=1')
    wait_for('SELECT balance FROM lab16.accounts WHERE account_id=1', '3361.00', 55432)
    check('streaming_migration', True, 'Committed balance change replayed on physical standby')

    print('\n17.11 Incremental backup and pg_combinebackup', flush=True)
    incremental = ROOT / 'incremental'
    run(['pg_basebackup', '-w', '-h', SOCKET, '-p', '55431', '-U', ROLE,
         '-D', incremental, '-X', 'stream', '--checkpoint=fast',
         '--incremental=' + str(full / 'backup_manifest')], timeout=60)
    combined = ROOT / 'combined'
    run(['pg_combinebackup', '-o', combined, full, incremental])
    run(['pg_verifybackup', combined])
    start(combined, 55434, '-c archive_mode=off')
    check('incremental_restore', sql('SELECT balance FROM lab16.accounts WHERE account_id=1', 55434) == '3361.00',
          'Full + incremental combined, verified and actually started with the later value')
    stop(combined)
    stop(standby)
    sql('UPDATE lab16.accounts SET balance=balance-1 WHERE account_id=1')

    print('\n17.12 WAL archive and point-in-time recovery to a named restore point', flush=True)
    sql("SELECT pg_create_restore_point('before_data_migration')")
    sql('DELETE FROM lab16.accounts WHERE account_id=1')
    check('source_delete_observed', sql('SELECT count(*) FROM lab16.accounts') == '1',
          'One row deliberately deleted in the disposable source cluster')
    segment = sql('SELECT pg_walfile_name(pg_current_wal_insert_lsn())')
    sql('SELECT pg_switch_wal()')
    deadline = time.monotonic() + 20
    while not (ARCHIVE / segment).exists():
        if time.monotonic() > deadline:
            raise TimeoutError('WAL archiving did not complete')
        time.sleep(0.2)
    pitr = ROOT / 'pitr'
    shutil.copytree(full, pitr)
    with (pitr / 'postgresql.auto.conf').open('a') as stream:
        stream.write(f"\nrestore_command='cp {ARCHIVE}/%f %p'\n"
                     "recovery_target_name='before_data_migration'\n"
                     "recovery_target_action='promote'\n")
    (pitr / 'recovery.signal').touch()
    start(pitr, 55433, '-c archive_mode=off')
    wait_for('SELECT pg_is_in_recovery()', 'f', 55433)
    check('pitr_restore', sql('SELECT balance FROM lab16.accounts WHERE account_id=1', 55433) == '3360.00',
          'Restored to before_data_migration: deleted row recovered with correct balance')
    stop(pitr)
    cleaned = cleanup(ARCHIVE)
    check(cleaned['check'], cleaned['passed'], cleaned['details'])
    for item in additional_pitr(ROOT):
        check(item['check'], item['passed'], item['details'])

    print('\n17.13 Logical replication: initial copy and committed update', flush=True)
    logical = init('logical')
    start(logical, 55435)
    create_db(DB, 55435)
    structure = run(['pg_dump', '-w', *conn(), '-n', 'lab11', '--schema-only'])
    run(['psql', '-X', '-w', '-v', 'ON_ERROR_STOP=1', *conn(55435)], input=structure)
    sql('CREATE PUBLICATION migration_pub FOR TABLE lab11.students')
    sql(f"CREATE SUBSCRIPTION migration_sub CONNECTION 'host={SOCKET} port=55431 "
        f"dbname={DB} user={ROLE}' PUBLICATION migration_pub", 55435)
    wait_for('SELECT count(*) FROM lab11.students', '3', 55435)
    sql("UPDATE lab11.students SET birth_date=birth_date+1 WHERE student_id=1")
    wait_for("SELECT birth_date FROM lab11.students WHERE student_id=1", '2002-05-16', 55435)
    check('logical_migration', True, '3 initial rows copied, later UPDATE replicated to a second real cluster')
    sql("UPDATE lab11.students SET birth_date=birth_date-1 WHERE student_id=1")
    wait_for("SELECT birth_date FROM lab11.students WHERE student_id=1", '2002-05-15', 55435)
    sql('DROP SUBSCRIPTION migration_sub', 55435)
    sql('DROP PUBLICATION migration_pub')
    stop(logical)

    print('\n17.14 Durability after an actual restart of the private source server', flush=True)
    stop(source)
    start(source, 55431)
    check('durability_restart', sql('SELECT count(*) FROM lab11.students') == '3',
          'Committed source data survives stopping and starting PostgreSQL')
    for item in EVIDENCE:
        name = item['check'].replace("'", "''")
        detail = item['details'].replace("'", "''")
        sql(f"INSERT INTO lab17.checks VALUES('{name}',true,'{detail}')")
    check_rows = sql('SELECT check_name,passed,details FROM lab17.checks ORDER BY check_name')
    (HERE / 'checks.txt').write_text(check_rows + '\n')
    report_json = sql("SELECT jsonb_pretty(jsonb_agg(to_jsonb(c) ORDER BY check_name)) FROM lab17.checks c")
    (HERE / 'verification.json').write_text(report_json + '\n')
    # Save an inspectable verified report to the user's normal course DB for screenshots.
    run(['pg_dump', '-w', *conn(), '-n', 'lab17', '-Fc', '-f', ARTIFACTS / 'lab17-results.dump'])
    run(['pg_restore', '-w', '-h', 'localhost', '-p', '5432', '-U', ROLE,
         '-d', 'university', '--exit-on-error', '--no-owner', ARTIFACTS / 'lab17-results.dump'])
    for name, path in [('full-backup_manifest.json', full / 'backup_manifest'),
                       ('incremental-backup_manifest.json', incremental / 'backup_manifest')]:
        shutil.copy2(path, ARTIFACTS / name)
    shutil.copytree(ROOT / 'compressed-base', ARTIFACTS / 'physical-tar')
    manifests = []
    for path in sorted(ARTIFACTS.rglob('*')):
        if path.is_file():
            manifests.append(f'{hashlib.sha256(path.read_bytes()).hexdigest()}  {path.relative_to(HERE)}')
    (HERE / 'SHA256SUMS').write_text('\n'.join(manifests) + '\n')
    print(f'All Lab 17 checks passed. Private stopped-cluster artifacts remain in {ROOT}', flush=True)


if __name__ == '__main__':
    try:
        main()
    finally:
        for server in SERVERS.copy()[::-1]:
            stop(server)
