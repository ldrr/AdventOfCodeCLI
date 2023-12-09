//
//  puzzle8.swift
//  AdventOfCodeCLI
//
//  Created by Christoph Lederer on 08.12.23.
//

import Foundation
import RegexBuilder

// Puzzle1: 14893
// Puzzle2: 10241191004509

func puzzle8() {
    var rows = puzzle8Data.split(separator: "\n").map({ String($0) })
    let instructions = rows.removeFirst()
    let puzzle = Puzzle8Map(nodes: rows.map({ Node(row: $0) }), instructions: instructions)
    print(puzzle.go())
    print(puzzle.go2())
}

class Puzzle8Map {
    let nodes: [Node]
    let instructions: [Character]

    let nodesMap: [String: Node]

    init(nodes: [Node], instructions: String) {
        self.nodes = nodes
        self.instructions = Array(instructions)
        self.nodesMap = nodes.reduce(into: [String: Node](), { $0[$1.pos] = $1 })
    }

    func go() -> Int {
        var steps = 0

        var currentNode = nodesMap["AAA"]!
        while currentNode.pos != "ZZZ" {
            currentNode = next(node: currentNode, step: steps)
            steps += 1
        }
        return steps
    }

    func go2() -> Int {
        let startNodes = self.nodes.filter({ $0.pos.last! == "A" })
        let steps = startNodes.map { node in
            var node = node
            var steps = 0
            while !(node.pos.last! == "Z") {
                node = next(node: node, step: steps)
                steps += 1
            }
            return steps
        }
        print(steps)
        return steps.reduce(1) { lcm($0, $1) }
    }

    func next(node: Node, step: Int) -> Node {
        self.nodesMap[instructions[step % instructions.count] == "L" ? node.left : node.right]!
    }

    func lcm(_ a: Int, _ b: Int) -> Int {
        var numbers = [a, b]
        while numbers[1] != 0 {
            numbers = [numbers[1], numbers[0] % numbers[1]]
        }
        return a * b / numbers[0]
    }
}

struct Node {
    let pos: String
    let left: String
    let right: String

    init(row: String) {
        (pos, left, right) = row.ranges(of: /[A-Z]{3}/).map({ String(row[$0]) }).splat()
    }
}
