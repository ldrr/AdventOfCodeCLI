//
//  puzzle2.swift
//  AdventOfCodeCLI
//
//  Created by Christoph Lederer on 09.12.23.
//

import Foundation

func puzzle2() {
    let lines = data2.split(separator: "\n").map({ String($0)} )

    let games = lines.map { Game(rawGame: $0) }
    let validIds = games.filter({ $0.isValid })
    let sumId = validIds.reduce(0) { $0 + $1.ID }

    print(sumId)
    // 2278
    let powerSumNeeded = games.map({ $0.setNeeded })
    let powerSum = powerSumNeeded.reduce(0) { $0 + $1.power }
    print(powerSum)

    // 67953
    struct Game {
        let ID: Int
        let sets: [Set]

        struct Set {
            let red: Int
            let blue: Int
            let green: Int

            var isValid: Bool {
                return red <= 12 && blue <= 14 && green <= 13
            }

            var power: Int {
                red * blue * green
            }
        }

        init(rawGame: String) {
            let data = rawGame.split(separator: ":")

            self.ID = Int((String(data[0]).replacingOccurrences(of: "Game ", with: "")))!
            let rawSets = data[1].split(separator: ";").map({ String($0) }).map({ Self.splitStringRegEx($0) })

            var sets: [Set] = []

            rawSets.forEach { rawSet in
                var blue = 0, red = 0, green = 0
                rawSet.forEach { (number, color) in
                    switch color {
                    case "blue":
                        blue = number
                    case "red":
                        red = number
                    case "green":
                        green = number
                    default:
                        break
                    }
                }
                sets.append(Set(red: red, blue: blue, green: green))
            }
            self.sets = sets
        }

        static let regex = try! NSRegularExpression(pattern: #"(\d+)\s+(\w+)"#, options: [])

        static func splitStringRegEx(_ string: String) -> [(Int, String)] {
            var result: [(Int, String)] = []
            let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
            for match in matches {
                if let range = Range(match.range, in: string) {
                    let matchString = String(string[range])
                    let components = matchString.components(separatedBy: " ")
                    if let number = Int(components[0]), let color = components.last {
                        result.append((number, color))
                    }
                }
            }
            return result
        }

        static func splitString(_ string: String) -> [(Int, String)] {
            var result: [(Int, String)] = []

            let components = string.components(separatedBy: ",")

            for component in components {
                let trimmedComponent = component.trimmingCharacters(in: .whitespaces)

                let numberString = trimmedComponent.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                let colorString = trimmedComponent.components(separatedBy: CharacterSet.letters.inverted).joined()

                if let number = Int(numberString), !colorString.isEmpty {
                    result.append((number, colorString))
                }
            }

            return result
        }


        var isValid: Bool {
            return self.sets.filter({!$0.isValid}).isEmpty
        }

        var setNeeded: Set {
            var red = 0, green = 0, blue = 0
            red = (self.sets.max(by: { $0.red < $1.red })?.red) ?? 0
            green = (self.sets.max(by: { $0.green < $1.green })?.green) ?? 0
            blue = (self.sets.max(by: { $0.blue < $1.blue })?.blue) ?? 0
            return Set(red: red, blue: blue, green: green)
        }
    }
}
