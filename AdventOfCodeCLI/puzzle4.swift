//
//  puzzle4.swift
//  AdventOfCodeCLI
//
//  Created by Christoph Lederer on 05.12.23.
//

import Foundation

func puzzle4() {
    // 39746 39710 19855
    let timeInterval = measureExecutionTime {
        let lines = contentPuzzle4.split(separator: "\n")
        let cards = lines.map({ ScratchCard(card: String($0)) })

        // puzzle 1
        print(cards.reduce(0) { $0 + $1.pot })

        // puzzle 2
        var cardsCount = lines.map({ _ in 1 })
        for (i, card) in cards.enumerated() {
            if(card.winnersCount > 0) {
                for pos in (i + 1)...(min(i + card.winnersCount, cardsCount.count - 1)) {
                    cardsCount[pos] += cardsCount[i]
                }
            }
        }
        print(cardsCount.reduce(0) { $0 + $1})
    }

    print(timeInterval)
}

struct ScratchCard {
    let id: Int
    let numbers: [Int]
    let winningNumbers: [Int]
    let winnersCount: Int
    let pot: Int

    init(card: String) {
        self.id = Int(card.prefix(8).suffix(3).trimmingCharacters(in: .whitespaces))!
        let numbersString = card.prefix(40).dropFirst(10).split(separator: " ")
        let winningString = card.suffix(74).split(separator: " ")
        let numbers = numbersString.map({ Int($0)! })
        let winningNumbers = winningString.map({ Int($0)! })

        self.winnersCount = {
            var winners: [Int] = []
            numbers.forEach { candidate in
                if winningNumbers.contains(candidate) {
                    winners.append(candidate)
                }
            }
            return winners.count
        }()

        self.numbers = numbers
        self.winningNumbers = winningNumbers
        self.pot = winnersCount > 0 ? Int(pow(2.0, Double(self.winnersCount - 1))) : 0
    }
}
