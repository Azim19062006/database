"""One invocation of the source document's daily backup/7-day retention workflow.

No scheduler is installed. Expired backups are moved to an expired/ subfolder,
so rotation is recoverable rather than permanently deleting a backup.
"""
from datetime import datetime, timedelta
from pathlib import Path
import re
import shutil
import subprocess
import sys

socket, port, destination = sys.argv[1:]
directory = Path(destination).resolve()
directory.mkdir(parents=True, exist_ok=True)
target = directory / ('coursework_' + datetime.now().strftime('%Y%m%d_%H%M%S') + '.dump')
if target.exists():
    raise FileExistsError(target)
subprocess.run(['pg_dump', '-w', '-h', socket, '-p', port, '-U', 'azim',
                '-d', 'coursework', '-Fc', '-f', str(target)], check=True)
cutoff = (datetime.now() - timedelta(days=7)).timestamp()
rotated = 0
for path in directory.iterdir():
    if path.is_file() and re.fullmatch(r'coursework_\d{8}_\d{6}\.dump', path.name) and path.stat().st_mtime < cutoff:
        expired = directory / 'expired'
        expired.mkdir(exist_ok=True)
        if (expired / path.name).exists():
            raise FileExistsError(expired / path.name)
        shutil.move(path, expired / path.name)
        rotated += 1
print(f'Created {target.name}; expired backups moved: {rotated}')
