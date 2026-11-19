"""Builds the SD-card zip of the release: python3 tools/package.py [version]
Needs build/vicecity.nro (tools/build.sh) and the reVC game files in third_party/revc/gamefiles.
Writes dist/vicecity-switch2-<version>.zip and dist/SHA256SUMS.txt."""
import hashlib
import os
import sys
import zipfile

root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
version = sys.argv[1] if len(sys.argv) > 1 else '1.0.0'
nro = os.path.join(root, 'build', 'vicecity.nro')
gamefiles = os.path.join(root, 'third_party', 'revc', 'gamefiles')
for f in (nro, gamefiles):
    if not os.path.exists(f):
        sys.exit('%s is missing' % f)

readme = """Vice City for Switch 2
======================
1. Copy these folders of your own GTA Vice City (Steam) into this folder, next to the ones that are here:
   Audio, anim, data, models, mp3, skins, TEXT, txd
   Keep the files of this download when asked, they replace the original ones.
2. Start Vice City from the homebrew menu.

A Joy-Con on a table works as a mouse. Click both sticks together to turn the FPS counter on or off.
If the game does not start, the reason is in log.txt in this folder.
"""

os.makedirs(os.path.join(root, 'dist'), exist_ok=True)
out = os.path.join(root, 'dist', 'vicecity-switch2-%s.zip' % version)


def add(z, name, data):
    i = zipfile.ZipInfo(name, (2026, 1, 1, 0, 0, 0))
    i.compress_type = zipfile.ZIP_DEFLATED
    i.external_attr = 0o644 << 16
    z.writestr(i, data)


with zipfile.ZipFile(out, 'w', zipfile.ZIP_DEFLATED) as z:
    add(z, 'switch/vicecity.nro', open(nro, 'rb').read())
    add(z, 'switch/gtavc/README.txt', readme.encode())
    for d, _, files in sorted(os.walk(gamefiles)):
        for f in sorted(files):
            p = os.path.join(d, f)
            add(z, 'switch/gtavc/' + os.path.relpath(p, gamefiles).replace(os.sep, '/'), open(p, 'rb').read())
sha = hashlib.sha256(open(out, 'rb').read()).hexdigest()
open(os.path.join(root, 'dist', 'SHA256SUMS.txt'), 'w').write('%s  %s\n' % (sha, os.path.basename(out)))
print(out)
print(sha)
