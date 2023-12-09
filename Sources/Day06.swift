private struct Race {
    let time: Int
    let distance: Int
    
    func maxDistance(for seconds: Int) -> Int {
        (time - seconds) * seconds
    }
}

struct Day06: AdventDay {
    private let races: [Race]
    
    init(data: String) {
        let lines = data
            .split(separator: "\n").compactMap({ String($0) })
            .map({ $0.split(separator: ":")[1].split(separator: " ").compactMap({ Int(String($0)) }) })
        self.races = lines
            .first!
            .enumerated()
            .map({ Race(time: $1, distance: lines[1][$0]) })
    }
    
    func part1() async throws -> Any {
        races.reduce(1) { partialResult, race in
            var records = 0
            for time in 1..<race.time {
                if race.maxDistance(for: time) > race.distance {
                    records += 1
                }
            }
            records = records == 0 ? 1 : records
            return partialResult * records
        }
    }
}
