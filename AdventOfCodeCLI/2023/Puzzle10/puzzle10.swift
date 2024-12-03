//
//  puzzle10.swift
//  AdventOfCodeCLI
//
//  Created by Christoph Lederer on 10.12.23.
//

import Foundation

func puzzle10() {
    let rows = puzzle10Input.split(separator: "\n").map({ String($0) })
    var puzzle = Puzzle(rows: rows)
    // print(puzzle)
    print(puzzle.go())
    puzzle.clearPuzzleLeftovers()
//    print(puzzle)
    puzzle.createMaze()
    puzzle.floodFill()
    print(puzzle.mazeDescription(withRuler: false))
    print(puzzle)
    print(puzzle.emptyCounts)
}

struct Puzzle: CustomStringConvertible {
    var puzzle: [[Tile]]
    var maze: [[Tile]]

    var width: Int {
        puzzle[0].count
    }
    var height: Int {
        puzzle.count
    }

    func mazeDescription(withRuler ruler: Bool = true) -> String {
        var desc = ""
        var rowIdx = 0
        if(ruler) {
            desc+=" "
            for i in 0..<maze[0].count {
                desc += "\(i % 10)"
            }
            desc.append("\n")
        }
        maze.forEach { row in
            desc += (ruler ? "\(rowIdx % 10)" : "")
            row.forEach { tile in
                desc.append(tile.rawValue)
            }
            desc.append("\n")
            rowIdx+=1
        }
        return desc

    }
    var description: String {
        var desc = ""
        var rowIdx = 0
        desc+=" "
        for i in 0..<puzzle[0].count {
            desc += "\(i % 10)"
        }
        desc.append("\n")
        puzzle.forEach { row in
            desc += "\(rowIdx % 10)"
            row.forEach { tile in
                desc.append(tile.rawValue)
            }
            desc.append("\n")
            rowIdx+=1
        }
        return desc
    }

    mutating func floodFill() {
        let numRows = maze.count
        let numCols = maze[0].count

        var stack = [Pos(x: 0, y: 0)]

        while !stack.isEmpty {
            let current = stack.popLast()!

            if current.y >= 0, current.y < numRows, current.x >= 0, current.x < numCols {
                if tile(at: current, inMaze: true) == .empty {
                    setType(at: current, to: .excluded, inMaze: true)
                    let puzzlePos = Pos(x: current.x / 3, y: current.y / 3)
                    if(tile(at: puzzlePos) == .empty) {
                        setType(at: puzzlePos, to: .excluded)
                    }

                    stack.append(current.up)
                    stack.append(current.left)
                    stack.append(current.right)
                    stack.append(current.down)
                }
            }
        }
    }

    init(rows: [String]) {
        var puzzle = rows.map({
            var row = Array($0).map({ Tile(rawValue: $0)! })
            row.append(.empty)
            row.insert(.empty, at: 0)
            return row
        })
        puzzle.append(Array(repeating: .empty, count: puzzle[0].count))
        puzzle.insert(Array(repeating: .empty, count: puzzle[0].count), at: 0)
        self.puzzle = puzzle
        self.maze = []
    }

    mutating func go() -> Int {
        let start = self.findStart()
        var pos = start
        var steps = 0
        repeat {
            let newPos = self.findNext(from: pos, includeStart: steps > 1)
            if steps > 0 {
                self.clearTile(at: pos)
            }
            pos = newPos
            steps += 1
        } while(tile(at: pos) != .start)
        return steps / 2
    }

    mutating func createMaze() {
        var maze: [[Tile]] = []
        for (_, row) in puzzle.enumerated() {
            var row1: [Tile] = []
            var row2: [Tile] = []
            var row3: [Tile] = []
            for (_, tile) in row.enumerated() {
                switch tile {
                case .doneNorthEast:
                    row1.append(contentsOf: [.empty, .block, .empty])
                    row2.append(contentsOf: [.empty, .block, .block])
                    row3.append(contentsOf: [.empty, .empty, .empty])
                case .doneNorthWest:
                    row1.append(contentsOf: [.empty, .block, .empty])
                    row2.append(contentsOf: [.block, .block, .empty])
                    row3.append(contentsOf: [.empty, .empty, .empty])
                case .doneSouthEast:
                    row1.append(contentsOf: [.empty, .empty, .empty])
                    row2.append(contentsOf: [.empty, .block, .block])
                    row3.append(contentsOf: [.empty, .block, .empty])
                case .doneSouthWest:
                    row1.append(contentsOf: [.empty, .empty, .empty])
                    row2.append(contentsOf: [.block, .block, .empty])
                    row3.append(contentsOf: [.empty, .block, .empty])
                case .doneVertical:
                    row1.append(contentsOf: [.empty, .block, .empty])
                    row2.append(contentsOf: [.empty, .block, .empty])
                    row3.append(contentsOf: [.empty, .block, .empty])
                case .doneHorizontal:
                    row1.append(contentsOf: [.empty, .empty, .empty])
                    row2.append(contentsOf: [.block, .block, .block])
                    row3.append(contentsOf: [.empty, .empty, .empty])
                case .start:
                    row1.append(contentsOf: [.empty, .block, .empty])
                    row2.append(contentsOf: [.block, .block, .block])
                    row3.append(contentsOf: [.empty, .block, .empty])
                default:
                    row1.append(contentsOf: [.empty, .empty, .empty])
                    row2.append(contentsOf: [.empty, .empty, .empty])
                    row3.append(contentsOf: [.empty, .empty, .empty])
                }
            }
            maze.append(row1)
            maze.append(row2)
            maze.append(row3)
        }

        self.maze = maze
    }

    func findStart() -> Pos {
        for (index, row) in puzzle.enumerated() {
            if let rowIndex = row.firstIndex(where: { $0 == .start }) {
                return Pos(x: Int(rowIndex), y: index)
            }
        }
        return Pos(x: 0, y: 0)
    }

    func tile(at pos: Pos, inMaze: Bool = false) -> Tile {
        if inMaze {
            return maze[pos.y][pos.x]
        } else {
            return puzzle[pos.y][pos.x]
        }
    }

    mutating func setType(at pos: Pos, to tile: Tile, inMaze: Bool = false) {
        if inMaze {
            self.maze[pos.y][pos.x] = tile
        } else {
            self.puzzle[pos.y][pos.x] = tile
        }
    }

    mutating func clearPuzzleLeftovers() {
        for (y, row) in puzzle.enumerated() {
            for (x, tile) in row.enumerated() {
                if !tile.isDone && tile != .start {
                    puzzle[y][x] = .empty
                }
            }
        }
    }

    mutating func clearTile(at pos: Pos) {
        puzzle[pos.y][pos.x] = {
            switch(tile(at: pos)) {
            case .horizontal:
                return .doneHorizontal
            case .vertical:
                return .doneVertical
            case .northEast:
                return .doneNorthEast
            case .northWest:
                return .doneNorthWest
            case .southEast:
                return .doneSouthEast
            case .southWest:
                return .doneSouthWest
            default:
                return .done
            }
        }()
    }

    func findNext(from pos: Pos, includeStart: Bool) -> Pos {
        let thisTile = tile(at: pos)
        let startOrDummy = includeStart ? Tile.start : Tile.dummy

        let right = tile(at: pos.right)
        let left = tile(at: pos.left)
        let up = tile(at: pos.up)
        let down = tile(at: pos.down)

        if(!includeStart) {
            if [Tile.horizontal, Tile.northWest, Tile.southWest, startOrDummy].contains(right) {
                return pos.right
            }
            if [Tile.horizontal, Tile.northEast, Tile.southEast, startOrDummy].contains(left) {
                return pos.left
            }

            if [Tile.vertical, Tile.southWest, Tile.southEast, startOrDummy].contains(up) {
                return pos.up
            }

            if [Tile.vertical, Tile.northWest, Tile.northEast, startOrDummy].contains(down) {
                return pos.down
            }
        } else {
            switch thisTile {
            case .southEast:
                return down.isDone ? pos.right : pos.down
            case .southWest:
                return down.isDone ? pos.left : pos.down
            case .northEast:
                return up.isDone ? pos.right : pos.up
            case .northWest:
                return up.isDone ? pos.left : pos.up
            case .horizontal:
                return left.isDone ? pos.right : pos.left
            case .vertical:
                return up.isDone ? pos.down : pos.up
            default:
                break
            }
        }

        return Pos(x: -1, y: -1)    // crashes next time when fail, lol
    }

    var emptyCounts: Int {
        self.puzzle.reduce(0) { partialResult, row in
            return row.reduce(partialResult) { partialResult, tile in
                return partialResult + (tile == .empty ? 1 : 0)
            }
        }
    }
}

struct Pos: Equatable, CustomStringConvertible {
    var description: String {
        "(\(x)\\\(y))"
    }
    let x: Int
    let y: Int

    var left: Pos {
        Pos(x: self.x - 1, y: self.y)
    }
    var right: Pos {
        Pos(x: self.x + 1, y: self.y)
    }
    var up: Pos {
        Pos(x: self.x, y: self.y - 1)
    }
    var down: Pos {
        Pos(x: self.x, y: self.y + 1)
    }
    var upLeft: Pos {
        Pos(x: self.x - 1, y: self.y - 1)
    }
    var upRight: Pos {
        Pos(x: self.x + 1, y: self.y - 1)
    }
    var downLeft: Pos {
        Pos(x: self.x - 1, y: self.y + 1)
    }
    var downRight: Pos {
        Pos(x: self.x + 1, y: self.y + 1)
    }
}

enum Tile: Character, CustomStringConvertible {
    var description: String {
        String(self.rawValue)
    }

    case vertical = "|"     // is a vertical pipe connecting north and south.
    case horizontal = "-"   // is a horizontal pipe connecting east and west.
    case northEast = "L"    // is a 90-degree bend connecting north and east.
    case northWest = "J"    // is a 90-degree bend connecting north and west.
    case southWest = "7"    // is a 90-degree bend connecting south and west.
    case southEast = "F"    // is a 90-degree bend connecting south and east.
    case empty = "."        // is ground; there is no pipe in this tile.
    case start = "S"
    case dummy = "?"
    case doneVertical   = "│"
    case doneHorizontal = "─"
    case doneNorthEast  = "└"
    case doneNorthWest  = "┘"
    case doneSouthWest  = "┐"
    case doneSouthEast  = "┌"
//    case doneVertical   = "║"
//    case doneHorizontal = "═"
//    case doneNorthEast  = "╚"
//    case doneNorthWest  = "╝"
//    case doneSouthWest  = "╗"
//    case doneSouthEast  = "╔"
    case done = "X"
    case block = "█"
    case included = "I"
    case excluded = " "

    func `is`(_ tiles: [Tile]) -> Bool {
        return tiles.contains(self)
    }

    var isDone: Bool {
        self.is([.done, .doneVertical, .doneHorizontal, .doneNorthEast, .doneNorthWest, .doneSouthEast, .doneSouthWest])
    }
}
