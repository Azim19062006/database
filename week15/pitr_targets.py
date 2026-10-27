"""Exercise the other two PITR targets and compressed base backups from Lab 17.

Only a private cluster made by backup_lab.py is accepted as the source.
"""
from datetime import date, timedelta
import json
from pathlib import Path
import shutil
import subprocess
import sys
import time


def exercise(root):
    root = Path(root).resolve()
    if not root.name.startswith('db17-') or not (root/'source'/'PG_VERSION').is_file():
        raise ValueError('Expected this assignment\'s private PostgreSQL cluster')
    socket, archive, source = root/'socket', root/'wal_archive', root/'source'
    started = []
    results = []

    def run(args):
        args = [str(x) for x in args]
        print('$ ' + ' '.join(args), flush=True)
        r = subprocess.run(args, text=True, stdout=subprocess.PIPE,
                           stderr=subprocess.STDOUT, timeout=60)
        if r.stdout.strip():
            print(r.stdout.rstrip(), flush=True)
        if r.returncode:
            raise RuntimeError(r.stdout)
        return r.stdout.strip()

    def sql(query, port=55431):
        return run(['psql','-X','-w','-At','-v','ON_ERROR_STOP=1',
                    '-h',socket,'-p',port,'-U','azim','-d','coursework','-c',query])

    def start(path, port):
        run(['pg_ctl','-D',path,'-l',root/(path.name+'.log'),'-w','start','-o',
             f"-p {port} -k {socket} -c listen_addresses='' -c archive_mode=off -c shared_buffers=16MB"])
        started.append(path)

    def record(name, details):
        results.append({'check':name,'passed':True,'details':details})
        print('VERIFIED '+name+': '+details, flush=True)

    state = subprocess.run(['pg_ctl','-D',str(source),'status'], capture_output=True)
    try:
        if state.returncode == 3:
            # Preserve the source's archive configuration rather than using start().
            run(['pg_ctl','-D',source,'-l',root/'source.log','-w','start','-o',
                 f"-p 55431 -k {socket} -c listen_addresses='' -c shared_buffers=16MB"])
            started.append(source)
        elif state.returncode:
            raise RuntimeError('Cannot determine source server state')
        original = date.fromisoformat(sql('SELECT birth_date FROM lab11.students WHERE student_id=1'))
        expected = str(original + timedelta(days=1))
        full = root/'targets-base'
        run(['pg_basebackup','-w','-h',socket,'-p','55431','-U','azim',
             '-D',full,'-X','stream','--checkpoint=fast'])
        xid = sql('WITH changed AS (UPDATE lab11.students SET birth_date=birth_date+1 '
                  'WHERE student_id=1 RETURNING *) SELECT pg_current_xact_id() FROM changed')
        target_time = sql('SELECT clock_timestamp()')
        sql('UPDATE lab11.students SET birth_date=birth_date+1 WHERE student_id=1')
        segment = sql('SELECT pg_walfile_name(pg_current_wal_insert_lsn())')
        sql('SELECT pg_switch_wal()')
        deadline = time.monotonic()+20
        while not (archive/segment).exists():
            if time.monotonic()>deadline:
                raise TimeoutError('WAL segment not archived')
            time.sleep(0.2)
        for kind, value, port in [('time',target_time,55436),('xid',xid,55437)]:
            restored = root/('pitr-'+kind)
            shutil.copytree(full,restored)
            with (restored/'postgresql.auto.conf').open('a') as f:
                f.write(f"\nrestore_command='cp {archive}/%f %p'\n"
                        f"recovery_target_{kind}='{value}'\n"
                        "recovery_target_inclusive=on\nrecovery_target_action='promote'\n")
            (restored/'recovery.signal').touch()
            start(restored,port)
            deadline = time.monotonic()+20
            while sql('SELECT pg_is_in_recovery()',port)!='f':
                if time.monotonic()>deadline:
                    raise TimeoutError('Recovery did not reach target')
                time.sleep(0.2)
            actual = sql('SELECT birth_date FROM lab11.students WHERE student_id=1',port)
            assert actual == expected, (actual,expected)
            record('pitr_'+kind+'_restore',f'Target {kind}={value}; first update kept ({expected}), second excluded')
        sql(f"UPDATE lab11.students SET birth_date='{original}' WHERE student_id=1")
        compressed = root/'compressed-base'
        run(['pg_basebackup','-w','-h',socket,'-p','55431','-U','azim',
             '-D',compressed,'-Ft','-z','-X','stream','--checkpoint=fast'])
        run(['pg_verifybackup','-n',compressed])
        record('compressed_base_backup','Tar/gzip base backup and streamed WAL archive passed pg_verifybackup -n')
        return results
    finally:
        for path in started[::-1]:
            run(['pg_ctl','-D',path,'-m','fast','-w','stop'])


if __name__=='__main__':
    results = exercise(sys.argv[1])
    Path(__file__).with_name('pitr-targets.json').write_text(json.dumps(results,indent=2)+'\n')
