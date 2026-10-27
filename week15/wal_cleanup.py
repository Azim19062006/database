"""Perform the document's WAL cleanup on a separate copy of this lab's archive."""
import json
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile


def cleanup(archive):
    original = Path(archive).resolve()
    root = Path(tempfile.mkdtemp(prefix='db17-cleanup-', dir='/tmp'))
    copied = root / 'archive-copy'
    shutil.copytree(original, copied)
    segments = sorted(p.name for p in copied.iterdir() if re.fullmatch('[0-9A-F]{24}', p.name))
    if len(segments) < 2:
        raise RuntimeError('Need at least two actual archived WAL segments')
    keep = segments[-1]
    for options in [['-n'], []]:
        args = ['pg_archivecleanup', *options, str(copied), keep]
        print('$ ' + ' '.join(args), flush=True)
        subprocess.run(args, check=True)
    remaining = sorted(p.name for p in copied.iterdir() if re.fullmatch('[0-9A-F]{24}', p.name))
    assert remaining == [keep]
    assert all((original / name).exists() for name in segments)
    result = {'check': 'wal_archive_cleanup', 'passed': True,
              'details': f'{len(segments)-1} obsolete WAL copies removed; original recovery archive retained'}
    print(json.dumps(result), flush=True)
    return result


if __name__ == '__main__':
    result = cleanup(sys.argv[1])
    Path(__file__).with_name('wal-cleanup.json').write_text(json.dumps(result, indent=2) + '\n')
