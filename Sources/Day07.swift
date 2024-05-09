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
    
    struct Hand: Comparable {
        static let strength: [Character] = ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]
        
        static func < (lhs: Day07.Hand, rhs: Day07.Hand) -> Bool {
            if lhs.rank == rhs.rank {
                for (lhsIndex, lhsCard) in lhs.cards.enumerated() {
                    let rhsIndex = rhs.cards.index(rhs.cards.startIndex, offsetBy: lhsIndex)
                    let rhsCard = rhs.cards[rhsIndex]
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
        
        static func rank(for hand: String) -> Rank {
            var grouped: [Character: Int] = [:]
            
            for ch in hand {
                grouped[ch, default: 0] += 1
            }
            
            let pattern = grouped.values.sorted(by: >)
            
            switch pattern {
            case [5]: return .fiveOfAKind
            case [4, 1]: return .fourOfAKind
            case [3, 2]: return .fullHouse
            case [3, 1, 1]: return .threeOfAKind
            case [2, 2, 1]: return .twoPair
            case [2, 1, 1, 1]: return .onePair
            default: return .highCard
            }
        }
        
        let cards: String
        let bid: Int
        let rank: Rank
        
        init(cards: String, bid: Int) {
            self.cards = cards
            self.bid = bid
            self.rank = Day07.Hand.rank(for: cards)
        }
        
    }
    
    let hands: [Hand]
    
    init(data: String) {
        self.hands = data
            .split(separator: "\n")
            .map({ $0.split(separator: " ") })
            .map({ line in
                let cards = String(line[0])
                let bid = Int(String(line[1]))!
                return Hand(cards: cards, bid: bid)
            })
    }
    
    func part1() async throws -> Any {
        hands.sorted().enumerated().reduce(0) { acc, hand in
            acc + (hand.element.bid * (hand.offset + 1))
        }
    }
    
    func part2() async throws -> Any {
        return 0
    }
    
}

