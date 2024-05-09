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
            var min: Int?
            var max: Int?
            var left = 0
            var right = race.time - 1
            while left < right {
                guard min == nil || max == nil else {
                    break
                }
                if min == nil && race.maxDistance(for: left) > race.distance {
                    min = left
                }
                if max == nil && race.maxDistance(for: right) > race.distance {
                    max = right
                }
                left += 1
                right -= 1
            }
            return partialResult * (max! - min! + 1)
        }
    }
    
    func part2() async throws -> Any {
        let race = Race(time: 44707080, distance: 283113411341491)
        var min: Int?
        var max: Int?
        var left = 0
        var right = race.time - 1
        while left < right {
            guard min == nil || max == nil else {
                break
            }
            if min == nil && race.maxDistance(for: left) > race.distance {
                min = left
            }
            if max == nil && race.maxDistance(for: right) > race.distance {
                max = right
            }
            left += 1
            right -= 1
        }
        return max! - min! + 1
    }
}

private extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
