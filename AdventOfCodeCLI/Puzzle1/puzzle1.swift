//
//  puzzle1.swift
//  AdventOfCodeCLI
//
//  Created by Christoph Lederer on 09.12.23.
//

import Foundation

func puzzle1() {
    func convertWrittenNumbersToNumeric2(_ input: String) -> String {
        var output = input

        let writtenNumbers: [String: String] = [
            "one": "1",
            "two": "2",
            "three": "3",
            "four": "4",
            "five": "5",
            "six": "6",
            "seven": "7",
            "eight": "8",
            "nine": "9"
        ]


        for (writtenNumber, numericValue) in writtenNumbers {
            output = output.replacingOccurrences(of: writtenNumber, with: numericValue)
        }

        return output
    }

    data1.split(separator: "\n").forEach { substring in
        let s1 = convertWrittenNumbersToNumeric(String(substring))
        let s2 = convertWrittenNumbersToNumeric2(String(substring))
        let c1 = code(s1)
        let c2 = code(s2)
        if c1 != c2 {
            print("\(substring) \(s1) \(s2) \(c1) \(c2)")
        }
    }

    func convertWrittenNumbersToNumeric(_ input: String) -> String {
        var output = input

        let writtenNumbers: [String: String] = [
            "one": "on1ne",
            "two": "tw2wo",
            "three": "thr3ree",
            "four": "fo4ur",
            "five": "fi5ve",
            "six": "si6ix",
            "seven": "sev7en",
            "eight": "eig8ht",
            "nine": "ni9ne"
        ]


        for (writtenNumber, numericValue) in writtenNumbers {
            output = output.replacingOccurrences(of: writtenNumber, with: numericValue)
        }

        return output
    }

    func code(_ value: String) -> Int {
        var firstDigit: Character?
        var lastDigit: Character?

        for char in value {
            if char.isNumber {
                if firstDigit == nil {
                    firstDigit = char
                }
                lastDigit = char
            }
        }

        guard let firstDigit, let lastDigit else {
            return 0
        }

        let value = Int("\(firstDigit)\(lastDigit)")!
       // print("\(line) => \(converted) => \(value)")
        return value
    }

    let pairs = data1.split(separator: "\n").map { line in
        let converted = convertWrittenNumbersToNumeric(String(line))
        return code(converted)
    }

    let sum = pairs.reduce(0) { $0 + $1 }
    print(sum)
}
