//
//  puzzle9.swift
//  AdventOfCodeCLI
//
//  Created by Christoph Lederer on 09.12.23.
//

import Foundation

func puzzle9() {
        let sum = puzzle9Data.split(separator: "\n").map({ String($0) }).reduce((0,0)) { partialResult, row in
        let interpolatedData = interpolate(startValues: row.split(separator: " ").map({ Int(String($0))! }))
        return (interpolatedData.0 + partialResult.0, interpolatedData.1 + partialResult.1)
    }
    print(sum)
}

func interpolate(startValues: [Int]) -> (Int, Int) {
    var minMaxValues = [(startValues.first!, startValues.last!)]
    var lastRow = startValues
    repeat {
        var newRow: [Int] = []
        for index in lastRow.indices {
            if index < lastRow.count - 1 {
                newRow.append(lastRow[index + 1] - lastRow[index])
            }
        }
        minMaxValues.append((newRow.first!, newRow.last!))
        lastRow = newRow
    } while(lastRow.first(where: { $0 != 0 }) != nil)

    var futureValue = 0
    var historyValue = 0
    for index in minMaxValues.indices.reversed() {
        if index > 0 {
            historyValue = minMaxValues[index - 1].0 - historyValue
            futureValue = minMaxValues[index - 1].1 + futureValue
        }
    }
    return (historyValue, futureValue)
}
