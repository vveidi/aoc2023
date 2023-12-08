import Foundation

private struct SeedMap {
    let ranges: [MapRange]
    
    init(_ maps: [String]) {
        self.ranges = maps
            .map ({ $0.split(separator: " ").compactMap({ Int($0) }) })
            .map ({ ranges in
                MapRange(
                    source: ranges[1],
                    destination: ranges[1] + ranges[2] - 1,
                    adjustment: ranges[0] - ranges[1]
                )
            })
    }
}

private struct MapRange {
    let source: Int
    let destination: Int
    let adjustment: Int
    
    init(source: Int, destination: Int, adjustment: Int) {
        self.source = source
        self.destination = destination
        self.adjustment = adjustment
    }
}

struct Day05: AdventDay {
    private let seeds: [Int]
    private let maps: [SeedMap]
    
    init(data: String) {
        let lines = data.split(separator: "\n").map({ String($0) })
        self.seeds = lines[0].split(separator: ":")[1].split(separator: " ").compactMap({ Int($0) })
        self.maps = lines.groupedByDigits().map({ SeedMap($0) })
    }
    
    func part1() async throws -> Any {
        var location = Int.max
        for seed in seeds {
            var seed = seed
            for map in maps {
                for range in map.ranges {
                    if seed >= range.source && seed <= range.destination {
                        seed += range.adjustment
                        break
                    }
                }
            }
            location = min(location, seed)
        }
        return location
    }
    
}

extension Array where Element == String {
    func groupedByDigits() -> [[String]] {
        var maps: [[String]] = []
        var tmp: [String] = []
        self.dropFirst(2).forEach { line in
            if line.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
                tmp.append(line)
            } else {
                maps.append(tmp)
                tmp.removeAll()
            }
        }
        if !tmp.isEmpty {
            maps.append(tmp)
        }
        return maps
    }
}
