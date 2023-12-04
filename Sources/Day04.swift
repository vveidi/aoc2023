struct Day04: AdventDay {
    var data: String
    
    func part1() async throws -> Any {
        data.split(separator: "\n").reduce(0) { partialResult, line in
            var winningNumbers: Set<Int> = []
            var cardsNumbers: Set<Int> = []
            
            guard let range = line.range(of: ":") else {
                fatalError()
            }
            let sets = line[range.upperBound...].split(separator: "|")
            sets.forEach { set in
                if set == sets[0] {
                    winningNumbers = Set(set.split(separator: " ").map({ Int($0)! }))
                } else if set == sets[1] {
                    cardsNumbers = Set(set.split(separator: " ").map({ Int($0)! }))
                }
            }
            return partialResult + score(winningNumbers.intersection(cardsNumbers).count)
        }
    }
    
    func part2() async throws -> Any {
        let matches = data.split(separator: "\n").map { line in
            var winningNumbers: Set<Int> = []
            var cardsNumbers: Set<Int> = []
            
            guard let range = line.range(of: ":") else {
                fatalError()
            }
            let sets = line[range.upperBound...].split(separator: "|")
            sets.forEach { set in
                if set == sets[0] {
                    winningNumbers = Set(set.split(separator: " ").map({ Int($0)! }))
                } else if set == sets[1] {
                    cardsNumbers = Set(set.split(separator: " ").map({ Int($0)! }))
                }
            }
            return winningNumbers.intersection(cardsNumbers).count
        }
        var cards = [Int](repeating: 1, count: matches.count)
        
        for (index, match) in matches.enumerated() where match > 0 {
            for i in index + 1...index + match {
                cards[i] += cards[index]
            }
        }
        return cards.reduce(0, +)
    }
    
    private func score(_ numberOfCards: Int) -> Int {
        guard numberOfCards > 0 else {
            return 0
        }
        if numberOfCards == 1 {
            return 1
        } else {
            return score(numberOfCards - 1) * 2
        }
    }
}
