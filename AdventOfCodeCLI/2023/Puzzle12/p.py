from functools import cache

def f(line):
    P, N = line.split()
    P = '?'.join([P] * 5)
    N = [int(n) for n in N.split(',')] * 5

    @cache
    def dp(p, n):
        r = 0
        if p >= len(P): return n == len(N)

        if P[p] in '.?': r += dp(p+1, n)

        print(P[p:p+N[n]])
        print(P[p+N[n]])
        if P[p] in '#?' and n < len(N) and \
            (p + N[n] <= len(P) and '.' not in P[p:p+N[n]]) and \
            (p + N[n] == len(P) or  '#' not in P[p+N[n]]):
            r += dp(p+N[n]+1, n+1)

        return r

    return dp(0, 0)

print(f(".??..??...?##. 1,1,3"))
# print(sum(map(f, open('data.txt'))))