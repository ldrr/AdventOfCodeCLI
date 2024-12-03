//
//  puzzle12.swift
//  AdventOfCodeCLI
//
//  Created by Christoph Lederer on 12.12.23.
//

import Foundation

func puzzle12v1() {
    let rows = puzzle12Input.split(separator: "\n").map({ String($0) })
    let sum = rows.reduce(0) { $0 + calc(row: $1) }
    print(sum)
}

func calc(row: String) -> Int {
    let data = row.split(separator: " ").map({ String($0) })
    let spring = Array(data[0]).map({ Spring(rawValue: $0)! })
    let cont = data[1].split(separator: ",").map({ Int($0)! })

    let springer = Springer(numbers: cont)

    var count: Int = 0
    springer.countVariations(spring: spring, count: &count)
    return count
}

class Springer {
    let numbers: [Int]
    let numberOfDamaged: Int

    init(numbers: [Int]) {
        self.numbers = numbers
        self.numberOfDamaged = numbers.reduce(0) { $0 + $1 }
    }

    func countVariations(spring: [Spring], count: inout Int ) {
        print(String(spring.map({ $0.rawValue })))

        var spring = spring

        generateCombinations(spring: &spring, index: 0, count: &count)
    }

    func generateCombinations(spring: inout [Spring], index: Int, count: inout Int) {
        if index == spring.count {
            if(checkMatch(spring: spring, numbers: self.numbers)) {
                count += 1
            }
            return
        }

        if spring[index] == .unknown {
            spring[index] = .operational
            generateCombinations(spring: &spring, index: index + 1, count: &count)

            spring[index] = .damaged
            generateCombinations(spring: &spring, index: index + 1, count: &count)

            spring[index] = .unknown
            generateCombinations(spring: &spring, index: index + 1, count: &count)

        } else {
            generateCombinations(spring: &spring, index: index + 1, count: &count)
        }
    }

    func checkMatch(spring: [Spring], numbers: [Int]) -> Bool {
        if spring.contains(where: { $0 == .unknown }) || spring.filter({ $0 == .damaged }).count != self.numberOfDamaged {
            return false
        }
        var index = 0
        var count = 0

        for type in spring {
            if type == .damaged {
                count += 1
            } else {
                if count > 0 {
                    if index >= numbers.count || count != numbers[index] {
                        return false
                    }
                    index += 1
                    count = 0
                }
            }
        }

        if count > 0 {
            if index >= numbers.count || count != numbers[index] {
                return false
            }
            index += 1
        }

        return index == numbers.count
    }
}

enum Spring: Character {
    case operational = "."
    case damaged = "#"
    case unknown = "?"
}

let puzzle12InputTest1 = """
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
"""
