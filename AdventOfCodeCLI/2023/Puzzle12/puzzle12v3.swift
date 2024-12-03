//
//  puzzlev3.swift
//  AdventOfCodeCLI
//
//  Created by Christoph Lederer on 12.12.23.
//

import Foundation

func puzzle12() {
    let rows = puzzle12Input.split(separator: "\n").map({ String($0) })
    let sum = rows.reduce(0) { $0 + calc3(row: $1) }
    print(sum)
}

func calc3(row: String) -> Int {
    let data = row.split(separator: " ").map({ String($0) })
    let cont = data[1].split(separator: ",").map({ Int($0)! })
    let cont2 = Array(repeating: cont, count: 5).flatMap { $0 }
    let newRow = Array(repeating: data[0], count: 5).joined(separator: "?")
    return SpringerV2(row: newRow, groups: cont2).count()
}

class SpringerV2 {
    var cache: [String: Int] = [:]
    let row: String
    let groups: [Int]

    init(row: String, groups: [Int]) {
        self.row = row
        self.groups = groups
    }

    func count(index: Int = 0, groupCount: Int = 0, length: Int = 0) -> Int {
        let key = "\(index):\(groupCount):\(length)"
        if let cachedValue = cache[key] {
            return cachedValue
        }

        var length = length
        var groupCount = groupCount

        if index == row.count {
            if groupCount == groups.count - 1 && length == groups[groupCount] {
                groupCount += 1
                length = 0
            }
            if groupCount == groups.count && length == 0 {
                return 1
            } else {
                return 0
            }
        }

        var result = 0

        let char = row[index]

        if char == "." || char == "?" {
            if length == 0 {
                result += count(
                    index: index + 1,
                    groupCount: groupCount,
                    length: 0
                )
            } else if groupCount < groups.count && groups[groupCount] == length {
                result += count(
                    index: index + 1,
                    groupCount: groupCount + 1,
                    length: 0
                )
            }
        }

        if char == "?" || char == "#" {
            result += count(index: index + 1, groupCount: groupCount, length: length + 1)
        }

        cache[key] = result
        return result
    }
}
