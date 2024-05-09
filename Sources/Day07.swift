//
//  Day07.swift
//
//
//  Created by Вадим Буркин on 09.05.2024.
//

struct Day07: AdventDay {
    
    enum Rank: Int, Comparable {
        static func < (lhs: Day07.Rank, rhs: Day07.Rank) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        case highCard
        case onePair
        case twoPair
        case threeOfAKind
        case fullHouse
        case fourOfAKind
        case fiveOfAKind
    }
    
    struct Hand {
        let cards: String
        let bid: Int
        let rank: Rank
        
        init(cards: String, bid: Int, rank: Rank) {
            self.cards = cards
            self.bid = bid
            self.rank = rank
        }
        
    }
    
    let lines: [[String]]
    
    init(data: String) {
        self.lines = data
            .components(separatedBy: .newlines)
            .map({ $0.components(separatedBy: .whitespaces) })
            .dropLast()
    }
    
    func part1() async throws -> Any {
        lines
            .map { line in
                let cards = String(line[0])
                let bid = Int(String(line[1]))!
                return Hand(cards: cards, bid: bid, rank: rank(for: cards, usingJoker: false))
            }
            .sorted(by: sortDeckWithoutJokers)
            .enumerated()
            .reduce(0) { acc, hand in
                acc + (hand.element.bid * (hand.offset + 1))
            }
    }
    
    func part2() async throws -> Any {
        lines
            .map { line in
                let cards = String(line[0])
                let bid = Int(String(line[1]))!
                return Hand(cards: cards, bid: bid, rank: rank(for: cards, usingJoker: true))
            }
            .sorted(by: sortDeckWithJokers)
            .enumerated()
            .reduce(0) { acc, hand in
                acc + (hand.element.bid * (hand.offset + 1))
            }
    }
    
    func rank(for hand: String, usingJoker: Bool) -> Rank {
        var grouped: [Character: Int] = [:]
        
        for ch in hand {
            grouped[ch, default: 0] += 1
        }
        
        let pattern = grouped.values.sorted(by: >)
        
        if usingJoker {
            return rank(for: pattern, jokers: grouped["J"] ?? 0)
        } else {
            return rank(for: pattern)
        }
    }
    
    private func rank(for pattern: [Int]) -> Rank {
        switch pattern {
        case [5]: .fiveOfAKind
        case [4, 1]: .fourOfAKind
        case [3, 2]: .fullHouse
        case [3, 1, 1]: .threeOfAKind
        case [2, 2, 1]: .twoPair
        case [2, 1, 1, 1]: .onePair
        default: .highCard
        }
    }
    
    private func rank(for pattern: [Int], jokers: Int) -> Rank {
        switch pattern {
        case [5]: .fiveOfAKind
        case [4, 1]: jokers > 0 ? .fiveOfAKind : .fourOfAKind
        case [3, 2]: jokers > 0 ? .fiveOfAKind : .fullHouse
        case [3, 1, 1]: jokers > 0 ? .fourOfAKind : .threeOfAKind
        case [2, 2, 1]: jokers == 2 ? .fourOfAKind : jokers == 1 ? .fullHouse : .twoPair
        case [2, 1, 1, 1]: jokers > 0 ? .threeOfAKind : .onePair
        default: jokers > 0 ? .onePair : .highCard
        }
    }
    
    private func sortDeckWithoutJokers(_ lhs: Hand, rhs: Hand) -> Bool {
        let strength: [Character] = ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]
        return sort(strength, lhs, rhs)
    }
    
    private func sortDeckWithJokers(lhs: Hand, rhs: Hand) -> Bool {
        let strength: [Character] = ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J"]
        return sort(strength, lhs, rhs)
    }
    
    private func sort(_ strength: [Character], _ lhs: Hand, _ rhs: Hand) -> Bool {
        if lhs.rank == rhs.rank {
            for (lhsIndex, lhsCard) in lhs.cards.enumerated() {
                let rhsCard = rhs.cards[rhs.cards.index(rhs.cards.startIndex, offsetBy: lhsIndex)]
                if lhsCard != rhsCard {
                    let lhsStrength = strength.firstIndex(of: lhsCard)!
                    let rhsStrength = strength.firstIndex(of: rhsCard)!
                    return lhsStrength > rhsStrength
                }
            }
            return false
        } else {
            return lhs.rank < rhs.rank
        }
    }
}
