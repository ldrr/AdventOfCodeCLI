//
//  puzzle2411.swift
//  AdventOfCodeCLI
//
//  Created by Christoph Lederer on 10.12.24.
//

import Foundation

struct StoneCash: Hashable {
    let data: Int
    let stepsLeft: Int
}

func puzzle2411() {
    func printStones() {
        print(stones.map { "\($0)"}.joined(separator: " "))
    }

    var cache: [StoneCash: Int] = [:]

    func process(stone: Int, stepsLeft: Int) -> Int {
        if let cacheItem = cache[StoneCash(data: stone, stepsLeft: stepsLeft)] {
            return cacheItem
        }
        if stepsLeft == 0 {
            return 1
        }
        let result: Int!

        if stone == 0 {
            result = process(stone: 1, stepsLeft: stepsLeft - 1)
        } else {
            let string = "\(stone)"

            if string.count % 2 == 0 {
                result = process(stone: Int(string.prefix(string.count / 2))!, stepsLeft: stepsLeft - 1) +
                process(stone: Int(string.suffix(string.count / 2))!, stepsLeft: stepsLeft - 1)
            }
            else {
                result = process(stone: stone * 2024, stepsLeft: stepsLeft - 1)
            }
        }

        cache[StoneCash(data: stone, stepsLeft: stepsLeft)] = result
        return result
    }

    func step(stones: [Int]) -> [Int] {
        var newStones: [Int] = []
        stones.forEach { val in
            if val == 0 {
                newStones.append(1)
            } else {
                let string = "\(val)"

                if string.count % 2 == 0 {
                    newStones.append(Int(string.prefix(string.count / 2))!)
                    newStones.append(Int(string.suffix(string.count / 2))!)
                }
                else {
                    newStones.append(val * 2024)
                }
            }
        }
        return newStones
    }

    func part1(stones: [Int], steps: Int = 25) -> Int {
        return stones.reduce(0, { partialResult, val in
            partialResult + process(stone: val, stepsLeft: steps)
        })
    }

    func part2(stones: [Int]) -> Int {
        part1(stones: stones, steps: 75)
    }

    let stones = data2.components(separatedBy: " ").map { Int(String($0))! }
    print(part1(stones: stones))
    print(part2(stones: stones))
}

private let data1 = "125 17"
private let data2 = "773 79858 0 71 213357 2937 1 3998391"
