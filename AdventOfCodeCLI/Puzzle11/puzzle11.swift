//
//  puzzle11.swift
//  AdventOfCodeCLI
//
//  Created by Christoph Lederer on 10.12.23.
//

import Foundation

// 447073781166

func puzzle11() {
    let rows = puzzle11Input.split(separator: "\n").map({ String($0) })
    let galaxy = Galaxy(map: rows.map({ Array($0).map({ Space(char: $0)! }) }))

    let stars1 = galaxy.expand(expansionRate: 1)
    let pairs1 = galaxy.createPairs(from: stars1)
    print(pairs1.reduce(0) { $0 + galaxy.calculateDistanceBetween(star1: $1.0, star2: $1.1) })

    let stars2 = galaxy.expand(expansionRate: 1_000_000)
    let pairs2 = galaxy.createPairs(from: stars2)

    print(pairs2.reduce(0) { $0 + galaxy.calculateDistanceBetween(star1: $1.0, star2: $1.1) })
}

class Galaxy {
    var map: [[Space]]

    init(map: [[Space]]) {
        self.map = map
    }

    func expand(expansionRate: Int) -> [Pos] {
        var emptyRows = Set(0..<map.count)
        var emptyCols = Set(0..<map[0].count)
        var positions: [Pos] = []

        for(rowIndex, row) in map.enumerated() {
            for (colIndex, space) in row.enumerated() {
                switch(space) {
                case .star:
                    emptyCols.remove(colIndex)
                    emptyRows.remove(rowIndex)
                    positions.append(Pos(x: colIndex, y: rowIndex))
                default:
                    break
                }
            }
        }

        positions = positions.map({ pos in
            let rowsBefore = emptyRows.filter({ $0 < pos.y }).count
            let colsBefore = emptyCols.filter({ $0 < pos.x }).count

            return Pos(
                x: pos.x + colsBefore * (expansionRate - 1),
                y: pos.y + rowsBefore * (expansionRate - 1)
            )
        })

        return positions
    }

    func createPairs(from positions: [Pos]) -> [(Pos, Pos)] {
        var pairs: [(Pos, Pos)] = []

        for i in 0..<positions.count {
            for j in (i+1)..<positions.count {
                let pair = (positions[i], positions[j])
                pairs.append(pair)
            }
        }
        return pairs
    }

    func calculateDistanceBetween(star1: Pos, star2: Pos) -> Int {
        return abs(star1.x - star2.x) + abs(star1.y - star2.y)
    }
}

enum Space {
    case empty
    case star

    init?(char: Character) {
        switch char {
        case ".": self = .empty
        case "#": self = .star
        default: return nil
        }
    }
}

