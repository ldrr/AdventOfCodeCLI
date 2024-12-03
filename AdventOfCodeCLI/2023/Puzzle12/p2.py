from functools import cache

def compute(line: str):
    res = 0
    d, ns = line.split()
    ns = tuple(map(int, ns.split(',')))
    d = '?'.join([d]*5)
    ns = ns*5
    d += '.'
    cnt = count(d, ns)
    res += cnt
    return res

@cache
def count(d, ns):
    if ns == ():
        return 0 if '#' in d else 1
    dlen = len(d)
    nslen = len(ns)
    n = ns[0]
    res = 0
    for i in range(dlen-(nslen-1+sum(ns[1:]))-(n+1)+1):
        if d[i+n] == '#':
            continue
        if '#' in d[:i]:
            break
        if '.' not in d[i:i+n]:
            res += count(d[i+n+1:], ns[1:])
    return res

print(sum(map(compute, open('data.txt'))))