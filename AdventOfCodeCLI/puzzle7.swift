//
//  puzzle7.swift
//  AdventOfCodeCLI
//
//  Created by Christoph Lederer on 07.12.23.
//

func puzzle7() {
    let hands = puzzle7RealData.split(separator: "\n").map({ Hand(row: String($0) )}).sorted()
    let result = hands.enumerated().reduce(0) { $0 + ($1.element.amount * ($1.offset + 1)) }
    print(result)
}

struct Hand: Comparable {
    let cards: String
    let amount: Int
    let poker: Poker
    let jokers: Int

    enum Poker: Int {
        case fiveOfAKind = 7
        case fourOfAKind = 6
        case fullHouse = 5
        case threeOfAKind = 4
        case twoPair = 3
        case onePair = 2
        case highCard = 1
    }

    init(row: String) {
        let items = row.split(separator: " ")
        var cards = String(items[0])

        let charactersToReplace = ["A", "K", "Q", "J", "T"]
        let replacements = ["F", "E", "D", "0", "B"]

        for (index, char) in charactersToReplace.enumerated() {
            cards = cards.replacingOccurrences(of: char, with: replacements[index])
        }

        self.cards = cards

        self.amount = Int(items[1])!
        (self.poker, self.jokers) = Self.findPoker(of: self.cards)
    }

    static func findPoker(of cards: String) -> (Poker, Int) {
        let cardCounts = cards.reduce(into: [:]) { counts, char in
            counts[char, default: 0] += 1
        }.sorted(by: { $0.value > $1.value })

        let jokers = cardCounts.first(where: { $0.key == "0" })?.value ?? 0

        if jokers == 5 {
            return (.fiveOfAKind, 5)
        } else if jokers > 0 {
            let newCards: String = {
                if cardCounts[0].key == "0" {
                    return cards.replacingOccurrences(of: "0", with: String(cardCounts[1].key))
                } else {
                    return cards.replacingOccurrences(of: "0", with: String(cardCounts[0].key))
                }
            }()
            return Self.findPoker(of: newCards)
        }
        
        let type: Poker = {
            switch (cardCounts[0].value, cardCounts[at: 1]?.value) {
            case (5, _):
                return .fiveOfAKind
            case (4, _):
                return .fourOfAKind
            case (3, 2):
                return .fullHouse
            case (3, _):
                return .threeOfAKind
            case (2, 2):
                return .twoPair
            case (2, _):
                return .onePair
            default:
                return .highCard
            }
        }()

        return (type, jokers)
    }

    static func < (lhs: Hand, rhs: Hand) -> Bool {
        if lhs.poker.rawValue == rhs.poker.rawValue {
            return lhs.cards < rhs.cards
        }
        return lhs.poker.rawValue < rhs.poker.rawValue
    }
}
