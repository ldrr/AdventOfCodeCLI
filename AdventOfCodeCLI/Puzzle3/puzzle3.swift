//
//  puzzle3.swift
//  AdventOfCodeCLI
//
//  Created by Christoph Lederer on 09.12.23.
//

import Foundation

func puzzle3() {
    // puzzle 1: 337584, 61489, 330727, 535235
    // puzzle 2: 170819, 45425501, 79844424
    // ["#", "$", "%", "&", "*", "+", "-", ".", "/", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "=", "@"]

    let machine = Machine(content: data3)
    print(machine.process())
    print(machine.processPart2())

    struct Machine {
        let machineData: [[Character]]
        let input: String
        let rowLength: Int

        init(content: String) {
            self.input = content
            self.machineData = self.input.split(separator: "\n").map({ Array(String($0)) })
            self.rowLength = self.machineData.first!.count
        }

        func process() -> Int {
            var partNumbers: Set<Int> = Set()
            var otherPartNumbers: [Int] = []

            for (row, line) in self.input.split(separator: "\n").enumerated() {
                let numbers = self.findNumbers(in: String(line))
                numbers.forEach { (start, length, value) in
                    let valid = isAdjacentToSymbol(row: row, start: start, length: length)
                    if valid {
                        // print(value)
                        partNumbers.insert(value)
                        otherPartNumbers.append(value)
                    }
                }
            }

            print(partNumbers.sorted())
            return otherPartNumbers.reduce(0) { $0 + $1 }
        }

        func isAdjacentToSymbol(row: Int, start: Int, length: Int) -> Bool {
            for x in max(start - 1, 0)...min(start + length, self.rowLength - 1) {
                for y in max(row - 1, 0)...min(row + 1, self.machineData.count - 1) {
                    let char = machineData[y][x]
                    if(!char.isNumber && char != ".") {
                        return true
                    }
                }
            }
            return false
        }

        func findNumbers(in string: String) -> [(start: Int, length: Int, value: Int)] {
            let regex = try! NSRegularExpression(pattern: #"\d+"#, options: [])
            let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))

            let numbers = matches.compactMap { match -> (start: Int, length: Int, value: Int)? in
                if let range = Range(match.range, in: string), let number = Int(string[range]) {
                    return (match.range.lowerBound, match.range.length, number)
                }
                return nil
            }

            return numbers
        }

        func processPart2() -> Int {
            let numbers = self.machineData.map({ self.findNumbers(in: String($0) )})

            // print(numbers)
            var gears: [Int] = []
            for (row, line) in self.input.split(separator: "\n").enumerated() {
                let stars = findStars(in: String(line))
                // print("\(stars) in \(line)")
                // find numbers in row above
                stars.forEach { starPosition in
                    var starGears: [Int] = []

                    // Row 0
                    if(row > 0) {
                        let row0Gears = numbers[row - 1].filter({ (start, length, value) in
                            let end = start + length - 1
                            // print("s:\(start) l:\(length) e:\(end) v:\(value) star:\(starPosition)")
                            if (starPosition >= start - 1 && starPosition <= start + 1) {
                                // print("\(value) is catched 1 in row0")
                                return true

                            }
                            else if (end >= starPosition - 1 && end <= starPosition + 1)
                            {
                               //  print("\(value) is catched 2 in row0")
                                return true
                            }
                            return false
                        }
                        ).map({ $0.value })

                        starGears.append(contentsOf: row0Gears)
                    }

                    // Row 1
                    let row1Gears = numbers[row].filter { (start: Int, length: Int, value: Int) in
                        let end = start + length - 1
                        if(starPosition == end + 1 || starPosition == start - 1) {
                            // print("\(value) is catched in row1")
                            return true
                        }
                        return false
                    }.map({ $0.value })
                    starGears.append(contentsOf: row1Gears)

                    // Row 2
                    if(row < machineData.count) {
                        let row2Gears = numbers[row + 1].filter({ (start, length, value) in
                            let end = start + length - 1
                            if (starPosition >= start - 1 && starPosition <= start + 1) {
                               // print("\(value) is catched 1 in row2")
                                return true
                            }
                            else if (end >= starPosition - 1 && end <= starPosition + 1)
                            {
                                // print("\(value) is catched 2 in row2")
                                return true
                            }
                            return false
                        }
                        ).map({ $0.value })
                        starGears.append(contentsOf: row2Gears)
                    }
                    // print("StarGears: \(starGears)")
                    if starGears.count == 2 {
                        print(starGears)
                        gears.append(starGears[0] * starGears[1])
                    } else if starGears.count > 2{
                        print("too many values for \(row)\(starPosition)")
                    }
                }
            }
            print(gears)
            return gears.reduce(0) { $0 + $1 }
        }


        func adjacentGearRations(row: Int, column: Int) -> [Int] {
            var gearRations: [Int] = []
            for x in max(column - 1, 0)...min(column + 1, self.rowLength - 1) {
                for y in max(row - 1, 0)...min(row + 1, self.machineData.count - 1) {
                    let char = machineData[y][x]
                    if char.isNumber {
                        gearRations.append(Int(String(char))!)
                    }
                }
            }
            return gearRations
        }

        func findStars(in string: String) -> [Int] {
            return string.indices.filter({ string[$0] == "*" }).map({ $0.utf16Offset(in: string) })
        }
    }
}
