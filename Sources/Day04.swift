struct Day04: AdventDay {
    var data: String
    
    func part1() async throws -> Any {
        data.split(separator: "\n").reduce(0) { partialResult, line in
            var winningNumbers: Set<Int> = []
            var cardsNumbers: Set<Int> = []
            
            guard let range = line.range(of: ":") else {
                return partialResult
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
    
    func score(_ numberOfCards: Int) -> Int {
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
