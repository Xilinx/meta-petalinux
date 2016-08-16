inherit go-osarchmap

def go_map_arch(a, d):
    import re
    if re.match('i.86', a):
        return '386'
    elif a == 'x86_64':
        return 'amd64'
    elif re.match('arm.*', a):
        return 'arm'
    elif re.match('aarch64.*', a):
        return 'arm64'
    elif re.match('p(pc|owerpc)(|64)', a):
        return 'powerpc'
    else:
        bb.warn("cannot map '%s' to a Go architecture" % a)
