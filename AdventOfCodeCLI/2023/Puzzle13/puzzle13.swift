//
//  puzzle13.swift
//  AdventOfCodeCLI
//
//  Created by Christoph Lederer on 13.12.23.
//

import Foundation

// 18195 23465 36665 30032 43496 13431
func puzzle13() {

    let data = """
##.#.#####.####
##..#..#.##....
##.#..#.#.#.#..
##..##.#....##.
..##.#...##.#..
..##..###.#....
#####.##...#.##
##.....#.##..##
##..########...
###....#..#.###
...##.######.##
###...#########
##.#.##.##.##..
...##.####.#.##
##..#..###.#.##
###.##.##.#.###
...####..###...
"""

//    let mirror = Mirror(data1: data, data2: "")
//    print(mirror.magicNumber)
//    return
    let mirrors = puzzle13data.split(separator: "\n\n").map({ String($0) })
    print(mirrors.reduce(0) {
        $0 + Mirror(data1: $1).magicNumber
    })
}

func createTuples(_ array: [String]) -> [(String, String)] {
    var tuples: [(String, String)] = []

    for i in stride(from: 0, to: array.count - 1, by: 2) {
        let tuple = (array[i], array[i + 1])
        tuples.append(tuple)
    }

    return tuples
}

class Mirror {
    var mirror: [[Bool]]

    var numRows: Int { mirror.count }
    var numCols: Int { mirror.count > 0 ? mirror[0].count : 0}

    var magicNumber = 0

    init(data1: String) {
        self.mirror = data1.split(separator: "\n").map({
            Array(String($0)).map({ $0 == "#" })
        })
        magicNumber = findMagicNumber()
        print(magicNumber)
    }

    func findMagicNumber() -> Int {
        var n = findVerticalReflection()

        self.mirror = rotate()
        n = n + findVerticalReflection() * 100

        if n == 0 {
            printMirror()
            assert(false)
        }
        return n
    }

    func printMirror() {
        for r in 0..<numRows {
            let s = String(mirror[r].map({ $0 ? "#" : "."}))
            print(s)
        }
        print("")
    }

    func findVerticalReflection() -> Int {
        var bestReflection = 0
        var bestCol = 0
        for col in 0..<numCols-1 {
            if columnMatches(col1: col, col2: col+1) {
                let colsBefore = col
                let colsAfter = numCols - col
                bestReflection = 1
                bestCol = col + 1
                for i in 0..<min(colsBefore, colsAfter) {
                    let colMoreBefore = col - i - 1
                    let colMoreAfter = col + i + 2
                    if colMoreBefore < 0 || colMoreAfter >= numCols || columnMatches(col1: colMoreBefore, col2: colMoreAfter) {
                        let reflection = col - colMoreBefore + 1
                        if reflection > bestReflection {
                            bestCol = col + 1
                            bestReflection = reflection
//                            print("\(bestReflection) at \(bestRow), \(colMoreAfter), \(colMoreBefore)")
                        }
//                        break
                    }
                }
            }
        }
        return bestCol
    }

    func rotate() -> [[Bool]] {
        var newMirror = Array(repeating: Array(repeating: false, count: numRows), count: numCols)

        for (i, row) in mirror.enumerated() {
            for (j, col) in row.enumerated() {
                newMirror[j][i] = col
            }
        }
        return newMirror
    }

//    /** Returns the the row where the reflection happens, and the total differences = smudge */
//    function getReflection(grid: string[][], smudge: number): number {
//      rLoop: for (let r = 0; r < grid.length - 1; r++) {
//        let diffs = diff(grid[r], grid[r + 1]);
//        if (diffs <= smudge) {
//          const rowsBelow = r;
//          const rowsAbove = grid.length - r;
//          for (let i = 0; i < Math.min(rowsBelow, rowsAbove); i++) {
//            const lowRow = r - i - 1;
//            const highRow = r + 2 + i;
//            if (lowRow < 0 || highRow >= grid.length) break;
//            diffs += diff(grid[lowRow], grid[highRow]);
//            if (diffs > smudge) continue rLoop;
//          }
//          if (diffs === smudge) {
//            return r + 1;
//          }
//        }
//      }
//      return 0;
//    }

    func columnMatches(col1: Int, col2: Int) -> Bool {
        for i in 0..<numRows {
            if mirror[i][col1] != mirror[i][col2] {
                return false
            }
        }
        return true
    }
}

let puzzle13InputTest1 = """
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
"""
