//
//  puzzle2415.swift
//  AdventOfCodeCLI
//
//  Created by Christoph Lederer on 15.12.24.
//

class Warehouse: CustomStringConvertible {
    var description: String {
        var desc = ""
        for y in 0..<plan.count {
            for x in 0..<plan[0].count {
                if bot == Pos(x: x, y: y) {
                    desc.append("@")
                } else {
                    desc.append("\(plan[y][x])")
                }
            }
            desc.append("\n")
        }
        return desc
    }

    struct Pos: Equatable {
        let x: Int
        let y: Int

        var left: Pos {
            Self(x: x-1, y: y)
        }
        var right: Pos {
            Self(x: x+1, y: y)
        }
        func `in`(direction: Step) -> Pos {
            switch direction {
            case .left:
                return Self(x: self.x - 1, y: self.y)
            case .right:
                return Self(x: self.x + 1, y: self.y)
            case .up:
                return Self(x: self.x, y: self.y - 1)
            case .down:
                return Self(x: self.x, y: self.y + 1)
            }
        }
    }

    enum Tile: Character, CustomStringConvertible {
        var description: String {
            String(self.rawValue)
        }

        case box = "O"
        case wall = "#"
        case empty = "."
        case bot = "@"
        case leftBox = "["
        case rightBox = "]"
    }

    enum Step: Character {
        case left = "<", right = ">", up = "^", down = "v"
    }

    var plan: [[Tile]]
    var bot: Pos
    var steps: [Step]

    init(data: String) {
        let parts = data.components(separatedBy: "\n\n")
        self.plan = parts[0].components(separatedBy: "\n").map({ $0.map {
            Tile(rawValue: $0)!
        } })
        self.bot = Pos(x: 0, y: 0)
        for y in 0..<plan.count {
            for x in 0..<plan[0].count {
                if plan[y][x] == .bot {
                    self.bot = Pos(x: x, y: y)
                    plan[y][x] = .empty
                    break
                }
            }
        }
        self.steps = parts[1].components(separatedBy: "\n").joined().map {
            Step(rawValue: $0)!
        }
    }

    var checksum: Int {
        var checksum = 0
        for y in 0..<plan.count {
            for x in 0..<plan[0].count {
                if self.plan[y][x] == .box || self.plan[y][x] == .leftBox {
                    checksum += (100 * y + x)
                }
            }
        }
        return checksum
    }

    func tile(at pos: Pos) -> Tile {
        self.plan[pos.y][pos.x]
    }

    func set(tile: Tile, at pos: Pos) {
        self.plan[pos.y][pos.x] = tile
    }

    func nextPosFrom(pos: Pos, with step: Step) -> Pos? {
        let nextPos = pos.in(direction: step)
        guard nextPos.x >= 0, nextPos.y >= 0, nextPos.x < plan[0].count, nextPos.y < plan.count else {
            return nil
        }
        return nextPos
    }

    func doNextStepForPart1() -> Bool {
        guard !self.steps.isEmpty else {
            return false
        }
        let step = self.steps.removeFirst()
        guard let nextPos = self.nextPosFrom(pos: bot, with: step) else {
            fatalError("we ran outside the warehouse")
        }
        switch tile(at: nextPos) {
        case .box:
            var nextSearchPos = nextPos, continueSearch = true
            while let nextBoxPos = self.nextPosFrom(pos: nextSearchPos, with: step), continueSearch {
                switch tile(at: nextBoxPos) {
                case .wall:
                    // we can't do anything
                    continueSearch = false
                case .bot, .leftBox, .rightBox:
                    // impossible
                    continueSearch = false
                case .box:
                    // continue search
                    break
                case .empty:
                    // that's it, that's what we're looking for
                    self.set(tile: .box, at: nextBoxPos)
                    self.set(tile: .empty, at: nextPos)
                    self.bot = nextPos
                    continueSearch = false
                }
                nextSearchPos = nextBoxPos
            }
        case .wall:
            return true // can't move
        case .empty:
            self.bot = nextPos
        case .bot, .leftBox, .rightBox:
            break   // impossible
        }
        return true
    }

    func canMove(moveableBoxes: [Pos], in direction: Step) -> Bool {
        return true
    }

    typealias BoxPosition =  (pos: Pos, tile: Tile)

    func moveMoreBoxes(_ step: Step, boxes: [BoxPosition]) -> Bool {
        var newBoxes: [BoxPosition] = []
        var emptyCount = 0
        for box in boxes {
            let nextPos = self.nextPosFrom(pos: box.pos, with: step)!
            let nextTile = tile(at: nextPos)
            if nextTile == .wall {
                return false
            }
            switch (box.tile, nextTile) {
            case (.leftBox, .rightBox):
                newBoxes.append(contentsOf: [
                    (nextPos, .rightBox),
                    (nextPos.left, .leftBox)
                ])
                break
            case (.rightBox, .leftBox):
                newBoxes.append(contentsOf: [
                    (nextPos, .leftBox),
                    (nextPos.right, .rightBox)
                ])
                break
            case (.leftBox, .leftBox), (.rightBox, .rightBox):
                newBoxes.append((nextPos, nextTile))
                break
            case (_, .empty):
                emptyCount += 1
            default:
                break
            }
        }
        if emptyCount == boxes.count {
            // move boxes
            for box in boxes {
                self.set(tile: box.tile, at: box.pos.in(direction: step))
                self.set(tile: .empty, at: box.pos)
            }
        } else {
            if moveMoreBoxes(step, boxes: newBoxes) {
                for box in boxes {
                    self.set(tile: box.tile, at: box.pos.in(direction: step))
                    self.set(tile: .empty, at: box.pos)
                }
                return true
            }
            return false
        }
        return true
    }

    func moveBoxesUpDown(_ step: Step, from: Pos) -> Bool {
        guard let nextPos = self.nextPosFrom(pos: from, with: step) else {
            fatalError("we ran outside the warehouse")
        }
        var newBoxes: [BoxPosition] = []
        let nextTile = tile(at: nextPos)
        newBoxes.append((nextPos, nextTile))
        switch nextTile {
        case .leftBox:
            newBoxes.append((nextPos.right, .rightBox))
            return moveMoreBoxes(step, boxes: newBoxes)
        case .rightBox:
            newBoxes.append((nextPos.left, .leftBox))
            return moveMoreBoxes(step, boxes: newBoxes)
        case .wall:
            return false
        case .bot, .box, .empty:
            break // impossible
        }
        return true
    }

    func doNextStepForPart2() -> Bool {
        guard !self.steps.isEmpty else {
            return false
        }
        let step = self.steps.removeFirst()
        guard let nextPos = self.nextPosFrom(pos: bot, with: step) else {
            fatalError("we ran outside the warehouse")
        }
        switch tile(at: nextPos) {
        case .leftBox, .rightBox:
            if step == .left || step == .right {
                var movableBoxes: [(Pos, Tile)] = [(nextPos, tile(at: nextPos))]
                var nextSearchPos = nextPos, continueSearch = true
                while let nextBoxPos = self.nextPosFrom(pos: nextSearchPos, with: step), continueSearch {
                    let nextTile = tile(at: nextBoxPos)
                    switch nextTile {
                    case .wall:
                        // we can't do anything
                        continueSearch = false
                    case .bot, .box:
                        // impossible
                        continueSearch = false
                    case .leftBox, .rightBox:
                        movableBoxes.append((nextBoxPos, nextTile))
                        break
                    case .empty:
                        // that's it, that's what we're looking for
                        self.set(tile: .empty, at: nextPos)
                        self.bot = nextPos
                        // now move all movable boxes to left or right
                        for pos in movableBoxes {
                            if step == .left {
                                self.set(tile: pos.1, at: Pos(x: pos.0.x - 1, y: pos.0.y))
                            } else {
                                // right
                                self.set(tile: pos.1, at: Pos(x: pos.0.x + 1, y: pos.0.y))
                            }
                        }
                        continueSearch = false
                    }
                    nextSearchPos = nextBoxPos
                }
            } else {
                if self.moveBoxesUpDown(step, from: self.bot) {
                    self.bot = nextPos
                }
            }
        case .wall:
            return true // can't move
        case .empty:
            self.bot = nextPos
        case .bot, .box:
            break   // impossible
        }
        return true
    }

    func extendPlan() {
        var newPlan: [[Tile]] = []
        for y in 0..<plan.count {
            var newRow: [Tile] = []
            for x in 0..<plan[0].count {
                switch plan[y][x] {
                case .bot, .leftBox, .rightBox:
                    break   // Impossible
                case .empty:
                    newRow.append(contentsOf: [.empty, .empty])
                case .box:
                    newRow.append(contentsOf: [.leftBox, .rightBox])
                case .wall:
                    newRow.append(contentsOf: [.wall, .wall])
                }
            }
            newPlan.append(newRow)
        }
        self.plan = newPlan
        self.bot = Pos(x: self.bot.x * 2, y: self.bot.y)
    }
}

func puzzle2415() {

    func part1(data: String) -> Int {
        let warehouse = Warehouse(data: data)
        while(warehouse.doNextStepForPart1()) {}
        return warehouse.checksum
    }

    func part2(data: String) -> Int {
        let warehouse = Warehouse(data: data)
        warehouse.extendPlan()
        print(warehouse)
        while(warehouse.doNextStepForPart2()) {
            // print(warehouse)
        }
        print(warehouse)
        return warehouse.checksum
    }

    print(part1(data: data1))
    print(part2(data: data))
}

private let data1 = """
#######
#...#.#
#.....#
#..OO@#
#..O..#
#.....#
#######

<vv<<^^<<^^
"""

private let data2 = """
##########
#..O..O.O#
#......O.#
#.OO..O.O#
#..O@..O.#
#O#..O...#
#O..O..O.#
#.OO.O.OO#
#....O...#
##########

<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
>^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^
"""

private let data = """
##################################################
#.O.......O.....#..OOO..O...O#.##.#.O...O...O....#
##....##........O#...O#OOOO.O..O.....O.OO..O#.OOO#
#.....O..O.O.....O......O...OOO....OO...O..#.#...#
#.O#O.OO.O..#.#......O..OO......#....O#O........O#
#.OOO.OO...O#......O.OOO.OO....O.....O...........#
#..#.....OO..O.OOO.......OO#....OOO#O#.O#O.O..O..#
##..O..O#.......O.O.O#OO...OO..OO.OO.O.#O....O...#
#...O...O...O.O..O............O.O#..O.O..OOO.....#
#......O.O#...OOO......O....O#.........#OO.O.#O..#
#.O....O....OOO#.#O#O#.........#O..OOO.O....OO.#O#
#..O.OO.#OO.O#O....O.O.O..O.OOOO.OO..O#O.#OO.OO.O#
#.O.....O.OO.OO...#.O...O..O..O...OO...O.O....O..#
#.#OOO...O......O.......O....O#...O..OO.O..O..O..#
##..O....#.##OOO......#OO..O.O..OO#...O..OO##O#.##
#O.OO.#...O#O..O.#.OO..O..###..#.O....OO......O..#
#.O.O...OO..O.O#O.OO..O...O..#O.....O..#.O.......#
#.O...#.O..O.O.O..OO.#.O.OO......#.OOO..O..#...#.#
#..OOO.O..O..OOOO.O.#.....O#...#O......O..O..O..##
#..O.....O#..OOO.O.......#..#.O.#..OOO..O........#
###O#.......#.......#O#.#OO.O...O..........O.....#
##...O..O.....O..OO.##....O.OO..#.O#.O..#..O.....#
##.O..O.#......O.O.OOO.........#..O...O.#O.O..O.O#
#.O.O#..#.O......#.O..#O...O...O..#.O...#.O.O#..O#
#.#O.OOO###.........OO#.@....O...O.O...#O..#OO.O.#
##.O.............###...O..O.#....O..O......OO....#
#.O.O...O...O.#........OO..OOO..OOOO....O.O......#
#..O.OO.O#.....O.OO..O.OO...OO......#O..O.O....###
###.O.O.......#...OO.OO......#.OO.O...O...#.....O#
#O..O.O.......O......O...O..O.#....O...#O#......O#
#....O.....O#O.#O...O........OOO.#.OO......OOO#..#
#...O....O...#..OO..OO...O..O....O....#O.#......##
#.#....O....##..O..#.#......O......O..O..O.OO#O#.#
#..O......O.O.O#O....#O..O#OO...O................#
#.O#..O........OO#O.O#.OO........#....O.O........#
#O...#.......O##OO..O......#O.#OO.#O.#O#OO..OO..O#
#O......O#.O.O.....#....OO....#........O..#...#..#
#O#...##OO.O.O..OO.....OOO....O.O......OO.....OO.#
##.....O..O.O.....#O...#.#...OOO#....OO.O..OO..#.#
#O...O...#OOO..O....#.#..O.O...#O.........OOOO.#O#
#.#OOO..OO.O.......O.O...OO.O....O#..#..........O#
#......O.......##..O...O#O..O...O#..O.O..#...OO..#
#O..O..OO......OO....####......O....O..OOO....O.O#
#O.......O..O..O...O...O.O#......O..........#...##
#..#......O.##.O..O.O.OO..O...........O.......O..#
#........#..#..##O.....OO.....#.#.O..O....O.O....#
#.....#.......O.....O...#O.O....O...O.........#..#
##O#O........#.......OO..O...#OO.O....#.......O..#
#...#...O..#O.O.....O...OO...OO..O....#O.O#.O..O.#
##################################################

<>>^>vv^^<v^>^>^v>>>^<vvv>^><<<<v>vv^>>v><^v>><vv>v>v>>^^><>^^^^^^<<<^>v<<><>^<<v^>v>><^^<vv^>^v>^>><>^v>^>>^><^^v><v<v<^>v^<>vv>v^v^^^>>vvv<^v>v^<^v><^v>^>^vv>>>vvvv>^<v^vv^v^>^>v>v^>^v<v>^<><><<<>v>><<>>>^v>>><v<>>>^<^>^<<><v^<v>vv>v^<^v^v^<<^^^>^><v<<<^^<v>^^^^>^>v^^^><^<v>^>^>>vv>>^v>>><>v>^<>^^v^<v>^><>^^>v^^<>>><vv^>^v<<<>^<^^<^v^<^^<v>>><v>>^^<^v<^^>v<>v<^v>>>v>><<v^>^<>>>^<v>>>^^v<v<>>^<<v^vv>^>v<v><v^<v><<<<v<^v^>v^<^v>vv^<><<<^><v>>v><^^>v<<vv^^^vvv<<<>>^^<>>>^>^^<><>>vv>v^>v^^>>^>^<<^>^>v>^<>>^^<><v^v<vv^>v<v<<<^>>v^<^^<>v>><<<^>^^<^v>^v^^vvv<^>^>>v<<<^>v><vv<^^<v^><>>>^^v><^v<vv<^>>>v<<v<vv^vvv^><<^<v<<<^<vvvv>v^v>^^v><>^>vv<>>v<vv^>><v>>v^><><^v^^<<^vvv>^><<><>>>^<<^<^<<^<>>^>>v>vvv>v^>>v<^v^<<^>^>^<^<>>^^><<v<<^^<<>v<><>><><>><>v<^^v>^^v>v><v>v^^v<>v>v<<^v<v><v<<<>v><v<vv>>^><><^v>>v>vv<<>^^^^^^^v^>>>>^<^^>>^^<^^>>^>v^<>^vv^<^>>^>v><^^<>vv<><v^v<>^^^^^>^>>v^>>>>^vv>>^>^<<<<>^><v>v^^vv<<<<^vvv^<^^>vv>v>v^v^<v>^v>^v^>>vv<>^<^v><><vv>v<><v>^v^<>v<<^>v><<>vv<>v>>>v><<^^<^v>^>
<v^>>^>>^v^^v^>v<v>^v><v>>^^vv^>>v^v^><<^v^^<<^>^v<^>>^<^^>><<^<^^^vv^<^>vv<v<^^<^v^<^>vv>><>^^^<v<vv<^^v^^<^vv><^v^<><vv>v><^<^^>><^v>^v<<>>>v<^^v>vvvv^v^v<>^<^^v<v<<<^>>^v<>>>>v<v^<>>^v^v^^^^^><<^v^>^<v><>>>v>>v><v<>^^v<<>v<<<<vv^^<v^<^^v^<><^v<v^>v>^^<<^v>^^><^><^^^v^^<>>><v^<<>vv^v^<<>v>^vv><vv>^v>v>>>>v<<v>>^^<^>>^vv>v<<<><><<^<<v<<<<v<>^^<v<<^^^^^v>v<^^v>>v<<v^v>>^v<<vv><><<>v<<><^<v^><vv^<>v<><v<vvv<>^v>^^^>v>^<>^^>vv^>^v>v<>^vvv><>^><<<<^^<^^^<>^>^^^^<>vv>>^<^>^vv^^^v<<^<^<^vv<vv^^^^^<^<^>^>^v^^^<^>v><>>>>^v<>v^v<<<<>v>^^<^v<v><^<>v<^<<>>^>^<<vvvv<<^v<^v>^v^<<^><<>vv>><^<^^vv<^>>^^><<<>v^^^vvv^<>^<^^^>v>^><v^>><<>>><v>v<^^^<<vvvvvv^vv<>><v><vv^>>>>^v<v><v<>v>^><<<<^>><v>^v^>v<>^><v><^^<>>><^^<<<<vv<^>>>^v<v^^v^v<v<><<v^<<v^<v^<^<^<vv>^v^v>><v>><v^vv<<v^^><><<v^v<^<v><<>><^<<><v<v>v<v<v^>v^^^>^^^^v>^>><^^<vv^<>v>vv^^<v^v<v<vv>><>^<^>v^v^^>^<^>><vvvv><<v^^^^<v<<v^^^^v<>>v<^<^>><<<<vv>^^>>vv^<>^>^><<v><<<^<<v^>^><<<<>><><v<^v^<^^<v<v<>vv><^<^^v><v<^v>^^^v>^>^<<^<vv>>><v^vv<^>>^^<<
<v<v>><v^vv^v<>^^v<^^<<v^^v<>>vv>^>^^>>v<v^<v<^v<v^v>>>^^<>^>^<<v^^<>vv<vv><^<<^vv>v^v^^<><vvv<^^v>^v<<><>^>>^>^>^v><<v<vv<v><<vv>^^<^<v^v^<vv^vv<v<^^^^<v<<^<<>>>><<<v<vv<<^<v^>v<>^vv>v><<<>vv^>^v<<><>>^>vvv<^v>vv^>><v>^^><^^v<>v<^<v<^vv^<^vv>>><v^v^>^vvvvv^v^^<^><^vv><>v>v<<v<^v<vvvvvv^vvv>>vvv^^<v>><<<><v>^^v<<>>vv<^>v>>vv>>><<>^<<<<^><>v><<>v><>v^>^^><<>><vvv<v>vv^><<>^^>^<^<v>^>v<^<<>v<>vvv<<<<>^vv><>^^^>v><v>^v^<^<^>^><v^<v<^>^>><v<v<v^<v<v><<v>vv^<vv>^<^<<><<vv>vv<<<<vv<v<^^><^vv^^^vv^^>^^>^<>^vv^<<v>v<^><v<v^vv^<^<v>v><<<><^>^<><<^<<<v<><^^^^vv>v<v<>vv^^>><>><vv^^v>v<vv<^<>v>v<v<^>^v>>^<<>^<>v><^v^>v>>>^v<v>vv>^^^<^^<^>^<<<^^>v><v<v>>><<<<^<vv<v<>v><v^^v<^vv>^v<><^v<<<^>^vv^^>^^^>vvv^>>^<^^>v<<<^<<^^<<^>>>^<><><<<<><^^^<<<>>>^>v^>>v^<<<v>v>>^><>>>^^><<<<v^>vvv<>v<v^><<<<<><vv^v<v^v^^>>>>v^v^><^><<^<>v><<>>><^<vvvv^<^^v^>><v^v><^<<<>vv^<^^>>>^><^><<<v<^vvv^vv<>v><>><vv>^<^>^<^^^v<>^<v>^<>v<>>^<^^v>vv^vv^^>^><><^v>^<^^><v^<^><v<^<>><^v>^<>^v<<<<<^<<<>^<^<v^<^^v<<vv<v<<<>^v^v>^vv^^
v^v<>><<^v><<<>^<^^><<^>>v^v<^v^><<<v>^vv<v>vv>^<v<<v<^>>>^^v^v^<<v<>v>vvv>>^^^<>^<v^vv^vv^vv>>>>v>>v^^v>vvv>^v^^^>^>>^<<<>^<<^<v^>v<><v<^><>^v<^<v^v><v^<^^><^vv^<^v^<^><><^<><>v<^<>>v^><<v<>^vv<>^>>^^<><<v^^<>^<v<v<^>><^vv<<<v<v>^<<>v<^^>>vv<v^^^vv^^><>>^>v<^v><^^^<^vv^vv<<<^<<><^v<^vv^>>>>vv>^vv>>^>^^<^v^v<><v^>v>vv^v><^v>>v^^<^<>>v<<<vv<v^<<>v>><>>^v^<v<><^v^<><>>><v>>v>>vvv<>vv>^>^^>v<<vv><^v<<><v<^>^<v>>^<v<>>>^^<^v<^<<<^<v>v^vv<^<>v<v<^>v>^><^^v^>^^v<>v^><v<<>^^vvv<^^^^v^^v^>vv^><<^^vvvv^^^v<^>>><<v<<v>v><<<^^vvvv<>>vv^<^>v>^vvvv^v^<<^>v<^<^<v^>v^^vv^^<vvv^><v>><v<v^v><vvvvv<>^vv><^vv>>>v>vv>>>vv^^^>><<v>>v>><>v<><vvv><>^^v<<v>v^><^^^^v<<v<vv>><<^<^^v^<<^>^v^>^<><<v^v^^v>^><v^^v>v><^v^<<><>v<<v>v>^<vv<>>>v<^><^v<^^>^v>><vv>>v<<v><^>>^<^<^>>vvvv^<>vv^v^v>vvvv>v^>^vv^^<<><v^>vvv<>>vvv^vv^<^v<^>v<vv>^<<v><^vv^<<<^v<>v<^v<><<vv^<v>v^<><<^^^v<<<><v^<><v<>^^v>v^vv>v><v>>vv>>^v><^<v<v^<v<^><v^<>>>^>^>vv<v>v^vv^>vvvv>v^<>>>^>^vv>v^<><^>>>^^>><<<v<^^<<>>^>><^v>^<<>v^v^^>><^^v^<^<^<v^v<>v<
><^>^v>>^^v><>^>vvv<v^^^vv<<v^^^>v^v><v<v>^^vvv>>>v<>><v>^^<^^^vv>><>v>v^<v^vv^>^v>^v><vvvvvvv<<<<^v<^^^v^>^vvv^^>>v<^<vv^<<>^<v>>^<>^<>v^><><v><>vv>^v^^^<^>>>v<^<^<<<v<>>>^v<v^>v<v^^><><><v><^>>^><^v<^<v><>^><>^v<v<v^v<v^^>v^>^<^<>><v<v<^<^>vv<v^^^^<<>vv<^v^v<v>>^v<>><^<<^^^^<v^>^v>><^vv^>^<^^vv>^>^<v>>^<^><><v>v<vv^<^<^v>>^>><^<>><>^<^<^^>^<v^>^<<^v<>v<<<>^><^^>v>><^^<^^<v^vv<v<^<<^^<<<v^^<v>^^v<<^v<<<>^<>>v><v>^<v<>^>^vvv>><>^>v><^<v<><^v^v^^vv>>^<<^<^v<>^vvv>v<^vv<^^v<^v><>><<>>^>v<>v>>v^<><<>^<<^v<>^vv<><>^vvv>v<v<^>^>^vv>>^<>v><^^^^<>v<<vv<<^v<v<>>>v^><>><^<<>v<^v>^v<<^v>v^><>^>^vv>vv>>^v<<v^^^>^<<>>>>>^>vv><^v^<vvv><>v^>><v^^v^^<>v^^<<^^v^>>v^^>v^v<<<>^>><v>v><<v<^><>>v>^^vv^>>v^>v^vvv^^vv<><>>v^^^<<vv^vv^<<>vv<>>>>^v^v^v>>vv<<<>^>v<<>><><<vvv<^<>v>v^<v^^^^vvvvv>><^^>>><^>^vv><^<<vvv^<><^<><>v<vv>>>><>vv<<^>v><<v>^<>^^v>v>v><^^><v^^<>v<>^>^<>vv>>v<>v>^v>>>v<><>^<^v^^<>^>v>v^^>v<<>vv>^v>vv>^<>v>^v<>^><>v<>>><vv<^v<>v><><v<^^^>^^^^v<>vvv^<vv>>^^^>^<vvv>>v<<<<^^>vvvvvvv<v<<>^^<>>v<
><v<>><v>^v^^>><<>v<v>^<<vv<<vv<^>^<v^>v>v<vvv>^vv<<^><^>^v<v>vv><^>^>v^<^v^^>>v<<^<<v>>v>>v><><<^<^v<^^v<<<v^>>^<>^^^>>v<v^<^<^^^vvv>v><<^<v>^^>>>>>^><^^>v^<v^>v^^^^^>>>><vv^>v^<><^vv<^^^^^>>^<^^^<<^<v<^vv^<><>^><v>^v<v^vvvv<v<vv<v<v<>v>^^<^^>v<<>v><<>^<>>>>^v>vv^<^v^>v^^v^^v<^^<^^>>v<<<<^^^<v<^vv<^v<v<^>><<>^v^<^<<v>^><^^^v>>>><^<<v^^><^^><^v<^<>^v^<>>v<<v>><<^v<>^<^v^v^<^<><^<>>^>><>^><vv>v<>>>v^v>^>^><vvvvvvv><vv^v^<^>>^>vv^vv<v<<<>>^<^v>>>v<><v<v<>>v>vv<><><><v>^<<<^vv<vv><vv<^v<^>>>vv^v<vv<<<>><v>^><<^vv^^<>vv>^>vv<^v^v>^>^^<<<>^>v>>>^^^v><>^<>^>><vv^<<>^>^v<^>>><>>><^^^vvvv><vv<>>^v<<<^<vv<<^<<^v>^>><<^<v>^v>><><>^<<>v<><>>><vv<^v<v>>vvv><>^<<<^<^v<^^^>v>v>^v>>^<<vv<>>^>v^>>>v>>>^<<<^<v<^vv^>>^^v<^^^^<<>vv<<<v<<v^<>>>^v>><>v>>v^^^<vv>>><<<<<><v><>vv<><v>>v<^vv<>v<vv^v^vv^>>>v>v<<^<^>v<^^<^^vv><^^<<<v>^>^v<vv^>^^<<v^v^^>^^<^^v<^<^^<^>>^vvv>^^v<v>><>^>>^<>^>><<v>vv^<>vv<vv><v^<^vv^<>>v^<^v^<^<v<>>^<v>^v>v>>^>vv^v<<><v<v^<>>>>^^<v><><v>>v<>>>><><>^v^>>>v^<<^<^^vv><><<<^v^<<v>v><vv^
vv><^v<^<v>vv<v<v<v<v>>^>^^v^<>vv^vvv<v^<<<><^<<^<>><<v<^>>><vv^^>v^<<^>vvvv<<^vv<^^>v>>>^^^>v<>^v<vv<>v<^^vv^^<>^v<>><vv>>vv<>v^<><vv<^^>v^^v><v<^vv>><v^^>>v<<>vv^<^vv^<v>v>vv<>^v<v><<^v^>^^>>v^v<v>>^^>^^>v^^vvv>>^<<vv>v<v><v<^>>^v^<>v<>^>^<<>^<vv^>^^v<<><<^<^<>v<><^^^<v<<<<vv^<>>^^<v<v>^<v<>vv<><v^<^>^>v<v<<v><v^^>v<^>^>>^>^<^^>v^v^v^>^<v^>v<>><<^^>>v>^v^<v<v^<>>>^vvvv^^>vv^v>v<v<<<^<>v^^>^vv<^v^v^><^>>>>>>v^v><>^>><v^^^<v^>>^>>>v^><<vv><<>>v>v<^>>v^<>^v>v^<vv^<v^^<>>v^v<^vv<^v<^v>>^v^<>v<v<<<>^<vv>^<<<<^^>^v^v>vvv^^>v>^>^<><><>^^^v^>v><<<>vv>v^v<v^v<<>v>vv<>>v<v><v<v^^><>>>>>>^>>>v<^>^v><<^vv<v<<^^v>v^v<^<<<^>><^v^v>>v><vv<>>v>>v>v>>^^^>^<^<^>^><<>^v<>^>vv^v^><v^<<v<v<<vv^>>vv><>><^vv>^^v>^v>^<^^><v^^<<<^<^>>^v^<v>v^<><vv<v<<vv>>>^<<^<<>><^<vv<><^>>v<>vv^v<^^<^^>>><^><<v^>v<>>^<^<^<^>>>^v^^<><<vv>v<>vv<><^v^v>><^^>vv^<^^^>^v^<^<vv<vv><v<>^>vv>^^<^>^<v>vv<^>v<>v<v^<^<vv<v<<<>^<<v^v<<<^>>^^<<v>>vvvv^^v<<>><v^^<vvvv>v<v<^>>>^><<^>><>v<^>>^v^<v<<v^^<^>>>^^v<v^>v^^v<v^vvv<vv>^<v><>>^<<><
>^v<^<v^v>><>v^><^<v^><<v<><<><>v<^<<<<><vv>^^><><^<<v<>^<^>><^^<^^^v^<>><^^vvv>v>>>v^^<<^<<>^^^vvvv^^<v<v^v>>><^v<>v<^v><^<v^v<<>vv<>vv<<>^>v>v<>^vv<<<<<v<<<>^^>v<>>^<^>^<v<>vvv>>^>vv<v^v>^^vvv<v<^^>>>><>vvv><>>^><vvv>v><>^v>>^>v^v>^>>^v<><^^><v>^><>^<<<<^v>v^>^<^v>>^^^^>><><<>><^<^<><<^>>^^<>^v<>^><^^<<^>><v^vv<^<v^>^v<>>v^<^^v<>^><^v<vvv><>v>^<<<^<<<^^<v<vv><^v>v>^v>>>^v>><<>v>^>^<<^<<v^>v^><^<^v<^v<><<>>vv>^^>v>v<><<^v<>v<^^<v>v^vv<<vv<<<<v^<^>vvv<^v>^<>v^v>vv>vv^><<vv<<<^vv^v><><v<v><>^v>v^v>vv>>vv<<vv>^>^^^v>^vvv^v^v<<<v^^^v>>^<><><>v<v<<>^v><v>><>^>^<<v^v<v>>v<v>v^>v>>v^>^v^>><^vvv>><^v^<><<vvv^<^<>^<><><>v>v^^<vv^^^>^<<<v>^>^<<vv>>>^<<^^<>^v>^^vv><>^^<v>><>>><^v>>^><v>v<<^v^<^^<>^<v<v>vv^<v>^v^>v>><^^^vv><<>><>>>>><<><^^>v<<>>v<v<vvv^<>v>^>^vv^<^v<<vv^<<<^^>>><<^<>^><^vv>^>v>v>^v>>v^<>>v>^^v<v>^v>><>v>v<^><^>^v><>^>>v^>v^v<^^v^>>^<v>v^<<^v<v<>^v<<vvv<<v<v^><vv^<><<v><<<vv<v>>^>>^^>^<^<><>>^^v>>v>>v>^v^vv<><^>>^>>^^^>><v^v^<<>>>v^vv<<v^<v<>>><<<>v><^vv><v^<>^v<>v<vv<>>^>v^<>>^v<
^<vv<vv^^^v>>>v<v^>v^v<>>^>^>^>^^<<^^>v>vv<^<^>v>>^^<^^^^v<v^^<^v^^^v^>>^<<^<^vv>^vv<v^<vv^^><^^><vv^v>>>v^><<>^^v^>^>v>^^><<v>^<v>>^^^<<^vv>>^v>>v^v>>><^><v<^<^>>>^^^<^<v<v>^<v>^^>vvv^v>^v><vvv<>^<<^<v>vv>><^^^^>vv>><^v><<^^<^^><>><<>><><<^^>^^>^<^v^vv>^^v^^<<^^^>v>>v>>^vv<^<v>v<vv<<^>^^<^^<v^>>^^<>v^<^^>v>^<^><^v<>vv^>>^>>^v>>>^>^v>v>v<^>^><vv^<^>^<^v^v>vvv<^<>v<<><v^^vv^^<^<<vv^<^^^^>^>^^<><<>^v>vv>^^v^^^<>^^v<v<<>>v>^^>v<^vvvvv>v>vv^^>>^<v<<>v^><^^>>^>>^v^<<^^^vv>>><>v<><>^>^^<v<^>^<<^v^>>v<^^>v>^^^^><^^v><v><vv^<^<<v<>>vv<>vv^^<v>^>>^>^<<v<<^>v<v^v^^^<>>vv^>><>^v><>v>v<<v>^>v<<vv>>^<^<<^>v<>^^>^vvv>>vv^v<v>^^>^^><^><><<v<v>^^<<v<><<>v>^^vvvvv^v^<v>>v>>>>><><^^>>v>vv<v^<<>>>vv<^<v>^<>^vv^vv>^v<>^>^v<^>^vv>^><<>>^>v<^>><^v<^^^^^<><v>v><v<>^v>v>^^<^>v>^v>vv^>>v<vv><>^<vv>vv<v><<v>^v^>vv>v^<>v<v<v>>^<^vv<>^><>>vv>^<>vv^^>v><vv>^<><>^v^<<><<vv><vvvv^v<><>v^^<^vvv^^<^>^<^>^v^v><v<vv>vv^^^<^^v^^v>v^<^<v><>^<^<^^>v>^v>>v>>^v^^>v>v>^<v>^<^<>v<<<<<v^<^>^^vv^^vv><><>>>>><<^v>>v<<v<<vv^<v><vv
<>v>>>vvv<v^<<>>^^^^v<^<<v<v^>^>^v>^>^^v><^><<^^<><<^v^v^vv<<<v^<vv><<^^^^>>^>^<vv^^v>v<<^v<vv>^^v<<^vv>><<>>v<<<>v^>vv>v>><^>v<^<>>v>v^^v<<vv^v>>^<^v^^><>>>>><^<^v^^<v>>v<>v<>^v^>^^><^v>^>v>><^>>^<>vv^^^>^><^<^v<^<^<v^v^v^>><^<^<v^<^^^>^>>^>^<>^>><>^>^>>>>vv><>v^>^^>><v<>>>^>v<>v^<vvv>^<>v>vv^^>vvv<^>^v>^^><v^>vv<<^<<<<v<>^^^v<v>vv<>v>^>v<<>^^^^<>^v^v>v>^>^><>vv^>^^<<>>vv<vv^^><^<<<v>^v^>^<>^<><>>^<v<vv>^v^<<^v>>^>>^><v^v<vvv><^<vv<v>^<^vvv><^vv>^v^<v>>v>^^<v<^<<<^v<>v^^<>^>>>v^^^>vv^v>>v^>^>^<^v><<><v<>v>>^<v^<^<>^v^^v<<v>>^vv<<<^<>v<^>v<^<^vv<>>v>^^^<>>^v><<v^^^>^v^>><>>><<<<>vv><v><>vv^>^>^vv<<<v>v>>vv^><>^>v^v<^><><><>v<<v<>>^v<>vv^>v^<^>^>vvv^<<<v^<><^^>>>>>v>^<>v>^<<^>>>v^v>v<^v^>v<>>vv<<^>v^<^><vv^^>v^v<^<<v>><v<v^<^^<v^>>vv<<^v<vv>^<><v^v^v>v>v<v^v<v^<v^^>><>^^<vvv^<^v>>^^v^><^>><<^^>><^<v^>^v<^>^<^<^v^<v^^<vv>^vvv<^>^^v<<>v<v^<><^^^<><>>v^^v^<<><^>>v>v<<<>^<^>v^^<>^<vv^<<^<<^<^^<<>v<^^>>v^v^v^>v<v<><<>>>><v^v<^v<^<<<vv<<>v<v><>vv><v><vvv^v^^><<^v<<><^vvv^v^^><>>^><>^vv>>^<>><
v><<<v>v<<<vv><^^<^^^^vv<<v^>^<^^>>v>^>v^^<><v>v<v><v<<v^vv<v>vvv>>^<<<<>v<<><>^>^v><^^><^>vv>>^^^<<>>^>><^^>vvv><<>v>v>>^v<^^><<v>v^vv^v^<^>^>^<v^<vvv^v<^v^>^v<^^^<^>v>^><>v<<>^^>><^<v><^>>>>v<v>vvvvv^^v>^>v^^<^<v>^^^^^vv<<<v^^^vv^<>^<^<^v<vv>^>vvvv><v<<vv<v>v><<v>>^><><^vv>vv^v<<<<v<<<>v>v<>^^<^<>v^v<^>v^>v^<>^^<<^<<v>v^<^><<<^^vv<<v<<>vv>v><>>><^<<<^v>v^>>^^v<^^^>>>^<^^^^<^^vvv^<^>v>^<><>v><<vv<^^>^>^<^<^v>^v>>><>^<<^<><^^<vv<^<><^^<^<v^<<<^^^v<^<v<><^^<^<>v<>>>^^^v^^<^^><vvvv^^v<<<^><^^v<<<vv<v^<<^<v^<^<<^v>v><>>v>v>^<v^^^v<^^<^^<<<>v<v>><^<><<vv>^<^>^v<v^vv>><>^v^^^^v^<><v^>^<>^<^>vv><>v^^><v>>v<<<>vv<<<vv<><^^>>v^>v^<<<<<<><^><<^^^<>><>^<vv><><^v^vv><><v<><<><^>v<<^>v^v>v^vv<v^v>^>^>><^^^v^v^>^<><^^>v>vv<<<vvv^v>>vv<<><>><>>>>^<v>>>><>>vvv<v<<>v><^<^<v<<vv>>v<^v^v>v<vvv^^^>>^v^^>>^^vv<>^vv^<vv>>v<>^>>^^^<v<<vvv<<v^v^>^^^>v>>>^vvv>vv<^<^^^>>vv^>v^>>>^<<<^v<><>^>v^^v>>><vv>>><v^<>^v>>^>^<^v^^>vvv^^vvvvv<^>>^^<vv<>^<vvv<^>^>vv<v^>^>^^<^v<vv<<><>vv<<^^vvvvv^^<^<>v>vv<>vv>>v<vvvv<vvvv
>^><^>vvv>>^<^<<vv>^v<^^<<v^^<^<<<^v>^^^<^vv><><v<^>^^^><v^^>v^^v<^^^v<<^<^^vv>>^>><^>^^^><vv^vv<>^^>vv>v<^v>^<>><>^>>v<^^>v^v<>v>^vv>>>v<<vv>v^<v>v>>><^^><<<><^<>^>^^v<^>><>^>v><>>>^v>vvv><>>>v>>v>>^<^^v><^<v^>^^^>v>>v<>v<v<<<>vv>v^^v><>^>vv^<>vv^^<<v>^<^<>^<>^v<v<<v^^v<<v^^><^^<v><>>^^^>>>vv><^>^vvv><>>>^^^^^v^v<>>vv>>v^^>^v<^<<<<><><<>v>>>vvv<>^^<^v>^<v>^<<^^<<><>vv^^<v^v^<v<v<v>^vv<^><<><>>vv^v><^<^v<v^>v<^><<><<<<<^<>>^<><><^^v>><<^<>>>>^v^<>><><^<<vv>^vv<><<^>v^^v^>^v^vvv^<<^^v<vvv>><vvv^^>>v^<>^v>^^<^v>>><v<<^<^^vv^^v<<<vv<>^v<^<>^<>^<^v><^v^^^>>><<>><<><v>>>>>v^><<>>>>v>vvvvv>>vv^^><^v>v<v^^v>v^><v>v>v<vv><<<>>>^>><^^<^vv<>>>vvv>v^<>>^^>v^^v<v>^>v<>^v>v>><>>v<^^<<^v<v^<>><><<^^^v<>>v>v^vv><>^>><v^v<<vvv>v^<vv<^v^<v>>vv<^>v^<<v><^^>><>^v^v>^vv<><v><v>>vv^<v><v><<vvv^^>><v<vv><<^<v<<^v<^<v<>>>>^^^^^<<^<v>^^<<^^<^v<^><>v^<>>>^vv>><<v><>v^<^v^v<<^<<<><<<v^>v^v^v^^<v>vv<<>v>v<>vv^<><v^<v>><vv<^<<<>^^<<vv<v<>^>v>v^vv>v<vvvv^^><<v<v^<<^>v<<>v^v<<<<^<<^v<v<>><vv<><^v<^^<v>^<<><v>v<<^^v
^v^>v><v>^^v^v^>^^^>^^^v^vv^^>v>>v<<v>>^v<>>v^<^v^v<v<<v^v>^<v>^^<<<<v^^>v><<^<<<v^<^^><>><v^><><v^v^vv><><v<^vvv>><^<<<>>^>><v^v^v>^><>vvv<<^v<>^>vvv^v<>^><>>^^><<^<vv^<>^v^^^<<vv>^>^<<>>v^^>><^^^>>^^<^^<>>>v>v^vv>v<^^^v>>^^v>><>>^vv<><^>>^<vv><<^^v>>v^>vv>v><>vv>>v<v<<^vv<^>^v^^<>v><><vv^vvv><>>^<v<>^^<^>>vv<^<<<<<vvvv>^<><<^<>^v<vv>v<<^^<><<^<^v^>>v><>v<^<<v><^>>>^^v><^v^^vv^<^><^v<><^>^v<^<>^<^v<>^v<><<^>^^<>>>>v^v^><>>^<><^v><v<v^<^^><<<>>^<v<v>v^>^<v><<<<v>><v^^^v<^>v^<vv<<>^>><^<^>>^><<v^>^<<>vv<v<<^v<v>v>^^>v^^<><^v>v>^>v<<^^v<^><>>^>^<^v<vv<>vv>>^<<<>>v<>v^^<><>vvvv><^<>^v<>v><>vv^>^v^<^vv^<^v^<v><^v^<v^v><vv>>>v<>v^vvv^>>^<v>>v<<v<>vv>>>>>>^<^^v<><<><<<<^<<v^v><^>v^<vv<vv^>v^<^><<>^>v<>^<^<<<v>>vv>>>v<v<v>^<>^v<>v^v<><v>>vvv>^>^^^^>^><<<><^vv^vv>^<><<v^<<<<<v^<^v>^^^<vv>^vv^>vv<>^<^>vv^>><^><^<>vv^v^^vv<^v^v><^>v<<^v<v<^<v>><vv^^<<><^^^>>^<^^<^^<<v^v<><<v<><vv<<v>>^<^<<v><>^^>>vvv<v^v<>>^<^<^<>>^>^>^^>^v><^^<<<v^<vv<^<v^<<v><>>v>^>v<v>><<^^^^vvv<>>>^v<^<v<vv^<^<<><v<^^<^v<v>^
v>^><><<><^v<^<v<><<><^v>><<<<<^^^>vv^^^v^<v^<^v>^^>v<>vv<<^>^<<>^vv^v<v<^^>>^^<v>^<v>^v<v>>><vv><v>v<>v<<^^v^^v<<^v<vv>^>^<>>>^<v><^^>>^<^v^v^^<^<^v>>^<<v>^^^<^<>v^>^<v<<>^^>^<v^>v>^<><>v^<v>v<<>^v<v<v><^v>^>^^^>v>>^<<^^vv>^<v>>>>^>v^><<^vv<^<vv^^<^<<<^^v^vvv^v>^>^<v^vv^^>^<>>v^^v<^^v<<^v>>vvvvv^vvv^v^v>^v<>^<v><<^^<<v^v<v><<<^vv<^^<^vv^v<<^><<^>^>>><v>^vvv>^^v>v^<^^vv<^>>^v<<^>vvv<<>^v^<<<><v<v^^<<>^v>vvv^v^<<<^v^vv^^><>v>^>^>vvvv>><<^v<<><>v^<^<>>v^^v>^^^^>v>>>v><vv<><^>v<<v<>v^><v^><>^v<vv<>v^<v^>vv<<><v<^v^<^vv^^<><^^<^<^<<>^>^^v>>v>vvv^^^v><v>><v<^<v^<v^>><v<<vv^v<>v^^v^^v>vv^<>v<<v^>>^<vv>>v^vv<<v<<><^><v^v<<<^v^v><^><>^vv>>vv>^><^vv^>^^>^<<>^v<^><>>^^<>^<<^v<^^^>v<<><<^>^<^>v<^>v<>>v>vvvv<^>^<v<>><<>v<^^<<>^^^<<vv^<>v^>v^v>v><>^<>v<<^^v><>^<>vv>^^<v<>>^v<^>>>^^^><^>^^>>vvv<>^v>^v<vv<v<>^>^>v>^^>>v<>>v^^^<^<v<><^v^<>^v^>v^<<>^^<^>^<>^^>^<^^>vv^^<<<v>><<<>^>^^v<>vv>v^v^<<<^>vv><v^^v<^^v^^<<<>v<<v^^^>>><^v<<^>>>>^<v><<<v>^vv<^<>>^^vv<>^^>v>^>>>>><^v>>>vv>v^^vv>>^^^<<<>vvv<^<<^v>^^
>vv<><>v^><v^<^>^vv<^<>^><>>vv^<<v^<<^v>^^^v<<v<^v>><^>v^^>v^<>^><^^v<><v<>>^v^<^^<^<<<v>v<>^<>v<<^^<^>>>vv>vvv>>v>^<^>>vv>>^>^vv^>>>>><<v>v^><v<<>>v^<>^^>>v<<vvvv<v><<><v^^^^^<>>^<v<<<><>>>vv<<^><v<<v^<<^vv>^<^>vv^v>>v<vvvv><<vv<<>^v>v<<<>^^^>v^v^^vvvv<>v>^v>><^><<<vvv>v<>^^v^><v^>^><v>vv>v><>><>>v>^vv^v^^>><<^><>>^>v>v^^^>>>^vv<v^^><v<^^<<v^<>v^<<<^<^<^<<^>v><v<v^<<v<>^v^v^>><^v><^^><<v^<^^><>v>v>>>^^>><>v^^v<<vv>vv^<>>^v^vv<<>^<<v<>>>^<^<<^<^>^^<<^v<^v<>v>^^^^<^v>^>^v^^<^^<<<^<<<>><>^<vv^>^^<<<^>v>v^v>v<v^v<^^v<>><><vv<^v^vv>^<v>^>^v<<>^^<^>^<>>vv^^^>>^<v<v^<><<<^><>>v^^v^<^v<><<><v>v<><v<<^<>^^^>^<>v>>^v^vv<<v^vvv>^^><v^<v^^^<v><>^^>^v>vv<v^^^>><^>^vv>v^>^>^><><<v^^v<^^v>v<<^>>v^>^>^v<>v^><vvvv^<>^<<^vv^vv<v<<>^v>v><^v^>>^^<<v^v^^v<<>><>>v^^><>v>v<v><^>vv><>v^>^><>>>v>^v^^^vv><v<^><<v^v<v>>>^>vvvvvv^^^v>>vvv<>^>v^<^^<><vv><vv^<^v<<^>^>><>><>^>^v^v^>>^vvvvv><v>>>>^v^>>v<<<><>^>^<v<v><^v<^<>vv<>v<v^vv^<v<^v<><vv>><<v>v<<>>>v<^>>>^^v>>><><v>>v^v^v><>>>v<>^^>^<<<^<v><^><>^^^>v^<>^^v>>^
<vvv^>^v>v^<^><>^^<<<<v>^<^^v<>v^^v>^><<v^^^<^><v^^^>>^^v>^>>vv<>v>^<>^^^vv<v>>><vv^<^v>>v>>^><>v^<^^v>v<^^><<v<>v<>v>vv<vv^<<<v>^<^^^<vv<v<v>^v^>vv<^^v>vvv^<v><v<<v<><v^^>^^^>v<^^>>^>><>^^<<vv^><v^>^^<^<><<>>^vvvvv^>^<v<>>^><>vv>^>^>^><v>>v^<>>^v<^<vv>v><v>v>>>^<^^v<<>>>v^vvv^v^>^^v^^>^^^^^><^v<v><<^v>vvv<vv<<vv>vvv>v><v>>><^v><vvv<<^>v>^>>^^^v^^v><<^><>>^v^<<>^^v<v>^^v><v^<>vv^><>vv><>^v>>^^<v<^^<^v>^>^<^vv>^^<>vv<^><>^<v><>>>>v^>^^>v>vv>^vv^v<>><<><^<vvv^v<v<<<v><v^>vvv<^>v<><v^>^vvv>v<<>><v>>^><>^^^>^vv><vv>v>vv<>^<<<<<<v^<v^<v<^v><>>>^v<>^v><>>>>v^v^<<>>^v<^><>vv<<>^>>v^>>v<>^<>vv><v<^v<vv^<<<vvv^<>>><<^v<v<>>>^^<^v><<v<>^>>v>v<><<^v^vv<><^>>>^><^<<v<^^v<v^vvv<^><<v^v^<^^>v>v<>^>><<^<^vv<^>^v^v^<v><^>>v<^><<v^<^^<^^v^<>><<^<v>><v<v>v<v>>^>><v<^><v>v<v^v^>^^v^^>v<vv^>v^><^>><<>^<^v<v>>><v><v^^<^v^><<>^<<vvvv>^vvv<^<>>^^^>>^v>^><^^<<<^<^v<vv^^vv<v>vv>^>>v>vv^v^vv^<<^^^<>v^^<><<v^v>^v<v><><<v^><^><^>^<<^^<<v^><<^<>^<^>>^<>>><><vv<^^^<><^>^<v<<v^^vvv^^^>^<^<vv>>vv>v>>^^<^><>v>><>>vv^^
><>><vv>v^v<v^v^^^^v><<v>>>>>vvv><<v^^<vv^^^<v<>>v><<><>^<<>^><>^<^><^^v<^v^v^^^v<v>vvv>>^<v<^>v<<^<v>vvvv<><v<>>v^><>^<<>v<>>^^^v><<><v<><^>>v>>^>^>v>^<^>><<>v<^<<><vv^^v><vv^>><<^>^>^v^^<>>vv>^<><vv^>><^v^v><<<>v^>>>v^>v<^vv^>>^<>v^<<>vv>vvv<<<><^^v^<><v<vv<>^^<><vvv<^<^><vvv<>>^v>^<>>>v><>v^>v<v<^^<>^><v>v><vvv<v<<><><v<v^^>>>v>^>v>^>v<<^v><<^>vv<<<v>>>^v^>v<v>><<>>><<^v>v<<v>><^^<^>>^<v^v<>v^v>v^v<v^^><v>^v>^v><>>v>vvv^v>^^<<v>v<^v><vvvv^<<<>^v^<v<>><^v^^<^<>vv<>>vv>^^^<<<><>><vv^v><v^v^v^<^v<<>>v>^^v^>v><<^v<<>^^vv^v^v^v>v^v^^vv^>v<<^^>^>>^vv>>>^^v<<>><v><<<^v^>^^v><vv^<vv<^>>>vv^><>>vv^^>>>^>>v>^vvv>>v>v>^vv>v>^><>^<>vv<v<v^<^^>^<<>^v>^<vv^v<^^<<vv<v>><^>>^<<^>^<^v<^vv>>>v>^^vvv^v^^^^^^^>^>^v>>^v<^^^>^vv>v>v<><^^^vv<^vv^>^v<<>^vv<v^>>^<v^^v<<v>v^v<>vv<>>^><<^<>^<v>^^vv^>^v<^<><<<><>v>v<v^^^v^>^>>v>^^^^>^^>><>v>vvv^vvv<^<>>v<><^<^>><<<<<vv<<><^v<vvvv>^^<><<<>v>^>>^v><^^v<^>v>^v^<vv^^<>^<<>^vv>>><v>^v<v<^<<<vv>^<><^v<v^<<v<v^>^v>v>^>^<<^<v>>vvv^v^>>^<^><vvvv>v>v^^<v<>vv^v>^^>>^<^v^
^<>vv>^^>v<><>^vvv<v^v^v><^^vv^<<^^<v^<<^^<<<v>>vvv>>><^^^^^v>^v<><<v>>^>^vv<v^<v^v^^>><vv<^<v><<^<v>vv<^v^^v><vv<<^^>>>^>^><v^^v>^v^>vvvv<><<>v>><>>v^>^<^^<>^^<<v^v<^^v^^^v<<v^<<<^<v<<>^v>>>^>^v<vv^<>>v><^<v<>v<><<>^^>v<<<^<><<^>^<v<><^>^<^^^^><v>^>^<^<^<>>^^<vv>^^^^>^<^<v<vv><vvv^^^v<><^^v^v<^^>>><>>v>v><>^<v<>vv<><v^^^>v>v<vv<vv>>>v>^<v<<v><>v>^<^^^^>>^v><<v<<>><>>v^>^v^v^v<v>vv<><^v>v^><v>^^<v^<v>v^><>v>vv<v<>><>v^vv>^>^^^^>^><^<^^>>v><<<<>^v>^^<^^^>v>^v^^v>vv>v<><v>^v^v<>>>>^>^>vv<><>v>v>^v^^<^^v<vv^v<<v^>>vv<>>>^^>>^<^^^<v<v^vv^^>><<v>^<vv>><^v>^>v<<>vv>v><>v^^<<>><<v^v<v>^^vv<>vv<<>v^>^>^^^v<>v>>>^v<>>>^^v<<>^<><v>vv>^<<v>vvvv^v^<><^>^>vvv^><<v<^<><>>^<v>v^^<^^>v<v^<>^v<<^^^^<^<^<v<^v^v><^vv>^<><^<>vv>^v^^<^^>^vv^^>>^<v^<v>^>><<vv^<<<>^>^^v>v>><<^>>^^>>^>>v<^<<v>><<^v>^<^^<<^^<><<<v<<vvvvv^<^>>>v<>^<vv^<^>>vv<^>><<^<^<<<>v^<^v^v>v^vvv<>^^>v<^v^^><v^>>>>v<<^^v^<<vv^<^v<<<^^<^v><vv^^v<<^><v<^<>^^v<^^<vv^vv>><<^^<v>^v^v<v^^^><v>v<><v^>^>><^^^v^>v><<vvv<v>^<v<<<v^<>v>^v>>>>>^>v^>v<>
<^>><<vv>^^>vv><^^v>>>vv<^^<<^^><<^>><^<v><^<v^v>v^<^^^<><>^>v<^>>v^<^^^<^^<^<^><><^>vv>vv<vv<<v><>>vv>^^>^v><v>>><^v^vvv<><<v^^^>^>v>>^<>v<>^v><v<><v><^<^v^<v^>^^v>vvv<><v^<<<v^<v<v<v^>>vv<vv>v<<<^v^vv><>vv>v^<<^^v^><<<>^<>^vv^>v^><v<v>><v^^<<>v<v>v^^v<<>^>^>vvv>>>>>>^^<>><^vv<v>v^v<<^v><^^<>><>><v>><v^>>^<^^>>^v^^<<v<^>>^^><<>v><vvvvv<<<^<<>v^^^v^v^<>>vv^<>v<^v<^<>>^<<><^>v<<v^>^<><>v>^^>>>v<^v>^^vvv<>^<<<^>v<><v^v<<^>^^>^<^>^<vvv<^v<^^<^v>v^>>v^v><v>>v<^^^^^^^vv^<<^<^<^vvv^^<>>v^v>v^<>vv>v^><v>v^>vv<<^v>v^^v^^><<<>^>^vv>>v<v><<vv^v^v^^v>v<>v<vv^v>v^v^<>^vv<v<v^^>^v>>>^^^<<v><>>>>^vv>v^<>><>>^^>v>><>>>^^<>^^>^vv^^vv^v<^v^>vv<><<<v^^^v>><><^^>v<<<><>^v>^<>v^<^<<<v>><><vv^v<<v^v^^v<v<>>v<^<^^^vvv>v^v>^^<^>v^v^vv>v<<<>v<^^><><>>v^<v>>>v^v<>v><v><^<^v<^^^^v>v^>>v<^vvv<><><^^^><>><<><^<vvv<<^v><v><<>><vv<^>><^>v^>>v><v^<>>^>><>v>>^v><^<<<><>>>>^vv>><v><>>^<vvvvv>v<^>>v><^^v<^^^^^>^^>v>vv<vv^v<^<^^<>v^<^vv>>^>v^v>v<v^<^<^vv^^^><<<>v>^>v^^^v^^>vv<>vv<vv^v>^^>vv<^<v>>^<^>>vvvv<<>><<^v^>>v<>>
>>vv>vv<^><>><v<^^^>>>^>v>v<vv>vv<^><v^<<>><><v^<^vv^v>><<<vv>^v<^^^^<^^<<^>v>><<<>><<>><v<>^<<<>v<<v^^<vvvv^^>vv<>v<^v^v>>>v<vvv^><v^v><^<^><>v>v^vv>^^>^^vv<<>^v>v^^^<^v<v^>^^^^<<^^^<><<<>>v<><vv>><>^<>v>>^v^>v<<v>^^^v<<><<>v^>>v<>^>v>^^v^^v<>^v<<v<v>vv^v<<>>v<<><>>^>^^>>^<v<><<v<>v>v><<>^>^v<^>>^<>v>>>vv>^>>^^^vv^<>^^>>><^^v<v><><^^vv<>^>^<<<vvvv^<^^<^<><<><^^<<>^>v><><v>>><>^v<<<<^<^<>>^<<>>v<>v^vvv^^^^^v<><<>v^vvv><^<>^vv^v^v>v^^^v^^v>>^<vv<<<<v^v>^<v>><<>>^>><>vv><v><>^vv<^>><<<^>^>v>vv^<>v><<v<<<vv>>>><v^>^>^v^<^>^<<^<^v><><>v<>^^>^^vvv^vv<<<<vv^v<><<^<^^^<<><<^^^^<^<^<>^vv>vv><^^^^<<^v^<>^^^v<>v>^>vvv<v><vv>v^>>>v>^>>^<<v<>^>vv<v^<<^>><<>^<><>>>^^>v><<^^v>>v^<^<^<>>^<<><<>^^^<v^^<>vvv><<<^<><v<>^^v^>vvv^v<>^<v<^>v<>^vv^<>>^<v>>>^<<^<^^<^^^<>><<<^^<^<<>vv>v<>v<^^<vv^>^<>^><v^vv<>vvv>^>^v^vv<^^^^v>^>>^v^>v>^>><^^^>>^>>v^><>v^<<<<<vv^^^<><><v<<>><>^<^<v^v^v>><<<v<v<<v<><<<>>^vv^^>v^^<<vvv^^^^^^^^>v>>>>v<<<v<>>v<v>^>><<>>><>v><v<>v><v<<><^v<v<<v^>v<v^^v<<^v<<<vvv>vvvv^^<vv<v>vvv^<vv
"""
