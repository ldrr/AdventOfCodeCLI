f = open("input.txt")

grid = []
data = []
currGrid = []
for x in f:
    if x != '\n':
        currGrid.append(x.strip())
    else:
        grid.append(currGrid)
        currGrid = []
grid.append(currGrid)

def checkSame(k,n,lines):
    if k >= 0 and n < len(lines):
        if lines[k] == lines[n]:
            return 1
        else: return -1
    return 0
def findMirror(data):
    for i in range(len(data)-1):
        res = checkSame(i,i+1,data)
        if res < 1: continue
        elif res == 1:
            if i == 0: 
                return i+1 
            elif i == len(data)-1:
                print("Last line, check up")
                return i+1
            val = loopThough(i,data)
            if val == -1: continue
            else: return val
    return -1

def loopThough(i,data):
    idx = 0
    for j in range(i,0,-1):
        idx += 1
        cellRes = checkSame(i-idx, i+idx+1,data)
        if cellRes == -1: return -1
        elif cellRes == 0: return i+1
    return i+1

cnt = 0
id = 0
for x in grid:
    id += 1
    res = findMirror(x)
    if res == -1:
        data = list(map(list, zip(*x)))
        res = findMirror(data)
        if res == -1: 
            print("No sol found for:",id)
        print(res)
        cnt += res
    else: 
        print(res * 100)
        cnt += res * 100
# my time and rank:
print("Part1:", cnt) #02:38:14    8387