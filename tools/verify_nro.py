"""Usage: verify_nro.py <program.nro> [link.map]

Checks an NRO before it goes to a console.
1. The NRO0 header, the MOD0 block and a libounce OUN0 entry (platform 2, version 1), which a Switch 1 build does not have.
2. The ASET block: a JPEG icon and a 0x4000 byte NACP.
3. With a linker map: it must name /libounce/lib/ and /portlibs/switch2/lib/ and must not name /libnx/ or the Switch 1
   EGL, GLESv2, glapi, drm_nouveau and vulkan libraries.
Exit code 0 means pass."""
import struct
import sys

path = sys.argv[1]
d = open(path, 'rb').read()
fail = []

if d[0x10:0x14] != b'NRO0':
    fail.append('no NRO0 magic at 0x10')
mod = struct.unpack_from('<I', d, 4)[0]
if d[mod:mod + 4] != b'MOD0':
    fail.append('no MOD0 magic at 0x%x' % mod)
else:
    found = None
    for i in range(8):
        off = mod + 0x1C + i * 12
        if d[off:off + 4] == b'OUN0':
            found = struct.unpack_from('<II', d, off + 4)
            break
    if found is None:
        fail.append('no OUN0 entry: this is not a Switch 2 (libounce) build')
    elif found != (2, 1):
        fail.append('OUN0 platform/version is %s, expected (2, 1)' % (found,))
    else:
        print('OK: OUN0 platform=%d version=%d' % found)

aset = struct.unpack_from('<I', d, 0x18)[0]
if d[aset:aset + 4] != b'ASET':
    fail.append('no ASET block')
else:
    ico_off, ico_size, nacp_off, nacp_size = struct.unpack_from('<4Q', d, aset + 8)
    if ico_size < 64 or d[aset + ico_off:aset + ico_off + 3] != b'\xff\xd8\xff':
        fail.append('the icon is not a JPEG')
    if nacp_size != 0x4000:
        fail.append('NACP size is 0x%x, expected 0x4000' % nacp_size)

if len(sys.argv) > 2:
    backslash = chr(92)
    m = open(sys.argv[2], encoding='utf-8', errors='replace').read().replace(backslash, '/')
    for bad in ('/libnx/', '/portlibs/switch/lib/libEGL.a', '/portlibs/switch/lib/libGLESv2.a', '/portlibs/switch/lib/libglapi.a',
                '/portlibs/switch/lib/libdrm_nouveau.a', '/portlibs/switch/lib/libvulkan.a', 'libdeko3d'):
        if bad in m:
            fail.append('the link map names a Switch 1 library: ' + bad)
    for need in ('/libounce/lib/', '/portlibs/switch2/lib/'):
        if need not in m:
            fail.append('the link map does not name ' + need)
    if not fail:
        print('OK: link map is Switch 2 only')

for f in fail:
    print('FAIL:', f)
print('RESULT:', 'FAIL' if fail else 'PASS', path)
sys.exit(1 if fail else 0)
