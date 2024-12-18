//
//  puzzle2417.swift
//  AdventOfCodeCLI
//
//  Created by Christoph Lederer on 18.12.24.
//

import Foundation

class Puzzle2417: CustomStringConvertible {
    var description: String {
        "A = \(String(a, radix: 8)), B = \(b), C = \(c), pointer = \(pointer), output = \(output.map { String($0) }.joined(separator: ","))"
    }

    var a: Int, b: Int, c: Int

    var cmds: [Int]
    var pointer: Int = 0
    var output: [Int] = []

    init(input: String) {
        let lines = input.components(separatedBy: "\n")

        self.a = Int(lines[0].suffix(12))!
        self.b = Int(lines[1].suffix(12))!
        self.c = Int(lines[2].suffix(12))!

        let cmdString = lines[4].suffix(9)
        self.cmds = cmdString.components(separatedBy: ",").map { Int($0)! }
    }

    func reset(withA: Int) {
        self.a = withA
        self.b = 0
        self.c = 0
        self.pointer = 0
        self.output = []
    }

    func part1() -> String {
        while pointer < cmds.count {
            runInstruction(opcode: cmds[pointer], operand: cmds[pointer + 1])
            print(self)
        }
        return output.map { String($0) }.joined(separator: ",")
    }

    func runComputer(a: Int) -> [Int] {
        reset(withA: a)
        while pointer < cmds.count {
            runInstruction(opcode: cmds[pointer], operand: cmds[pointer + 1])
        }
        return self.output
    }

    private func get(combo: Int) -> Int {
        switch combo {
        case 0...3:
            return combo
        case 4:
            return self.a
        case 5:
            return self.b
        case 6:
            return self.c
        default:
            fatalError("combo out of bounds")
        }
    }

    private func runInstruction(opcode: Int, operand: Int) {
        switch opcode {
        case 0:
            self.a = self.a >> get(combo: operand)
            self.pointer += 2
        case 1:
            self.b = self.b ^ operand
            self.pointer += 2
        case 2:
            self.b = get(combo: operand) % 8
            self.pointer += 2
        case 3:
            guard self.a != 0 else {
                self.pointer += 2
                return
            }
            pointer = operand
        case 4:
            self.b = self.b ^ self.c
            self.pointer += 2
        case 5:
            output.append(get(combo: operand) % 8)
            self.pointer += 2
        case 6:
            self.b = self.a >> get(combo: operand)
            self.pointer += 2
        case 7:
            self.c = self.a >> get(combo: operand)
            self.pointer += 2
        default:
            fatalError("Unexpected opcode \(opcode) with \(operand)")
        }
    }

    func part2b() -> Int {
        var i = 0
        var pos = self.cmds.count - 1
        while(true) {
            let result = runComputer(a: i)
            if result[0] == self.cmds[pos] {
                pos -= 1
                if pos < 0 { return i }
                i = i << 3
            } else {
                i += 1
            }
        }
    }
}

func puzzle2417() {
    let p = Puzzle2417(input: data)
    print(p.part1())
    print(p.part2b())
}

private let testdata = """
Register A: 0
Register B: 0
Register C: 9

Program: 2,6
"""

private let data1 = """
Register A: 729
Register B: 0
Register C: 0

Program: 0,1,5,4,3,0
"""

private let data = """
Register A: 60589763
Register B: 0
Register C: 0

Program: 2,4,1,5,7,5,1,6,4,1,5,5,0,3,3,0
"""
