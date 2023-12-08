import Foundation

private struct Almanac {
    let seeds: [Int]
    let maps: [SeedMap]
    
    init(data: String) {
        let lines = data.split(separator: "\n").map({ String($0) })
        self.seeds = lines[0].split(separator: ":")[1].split(separator: " ").compactMap({ Int($0) })
        self.maps = lines.groupedByDigits().map({ SeedMap($0) })
    }
    
    func location(for seed: Int) -> Int {
        var seed = seed
        for map in maps {
            for range in map.ranges {
                if seed >= range.source && seed <= range.destination {
                    seed += range.adjustment
                    break
                }
            }
        }
        return seed
    }
}

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
    
    init(_ seeds: [[Int]]) {
        self.ranges = seeds.map({ MapRange(source: $0[0], destination: $0[0] + $0[1] - 1, adjustment: $0[1]) })
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
    private let almanac: Almanac
    
    init(data: String) {
        self.almanac = Almanac(data: data)
    }
    
    func part1() async throws -> Any {
        var minLocation = Int.max
        for seed in almanac.seeds {
            let seedLocation = almanac.location(for: seed)
            minLocation = min(seedLocation, minLocation)
        }
        return minLocation
    }
    
    func part2() async throws -> Any {
        let seedRanges = SeedMap(almanac.seeds.groupedByTwoNumbers()).ranges
        var minLocation = Int.max
        for seedRange in seedRanges {
            for seed in (seedRange.source..<seedRange.destination) {
                let seedLocation = almanac.location(for: seed)
                minLocation = min(seedLocation, minLocation)
            }
        }
        return minLocation
    }
    
//    func part2() async throws -> Any {
//        let seedRanges = SeedMap(seeds.groupedByTwoNumbers())
//        for seedRange in seedRanges.ranges {
//            var possibleRanges = [seedRange]
//            for map in maps {
//                var tempRanges = possibleRanges
//                for range in map.ranges {
//                    for tempRange in tempRanges {
//                        let range1 = MapRange(
//                            source: max(range.source, tempRange.source),
//                            destination: min(range.destination, tempRange.destination),
//                            adjustment: min(range.destination, tempRange.destination) - max(range.source, tempRange.source)
//                        )
//                        let range2 = MapRange(
//                            source: tempRange.source,
//                            destination: range1.source,
//                            adjustment: range1.source - tempRange.source
//                        )
//                        let range3 = MapRange(
//                            source: range1.destination,
//                            destination: tempRange.destination,
//                            adjustment: tempRange.destination - range1.destination
//                        )
//                        let newPossibleRange = MapRange(
//                            source: range1.source + range.adjustment,
//                            destination: range1.destination + range.adjustment,
//                            adjustment: range1.destination + range.adjustment - range1.source + range.adjustment
//                        )
//                        possibleRanges.append(newPossibleRange)
//                        if tempRange == tempRanges.last {
//                            possibleRanges.append(contentsOf: [range2, range3])
//                        }
//                    }
//                }
//            }
//            print(possibleRanges.min(by: { $0.source < $1.source }))
//        }
//        return 0
//    }
    
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

extension Array where Element == Int {
    func groupedByTwoNumbers() -> [[Int]] {
        var arr: [[Int]] = []
        var tmp: [Int] = []
        self.forEach { int in
            if tmp.isEmpty {
                tmp.append(int)
            } else {
                tmp.append(int)
                arr.append(tmp)
                tmp = []
            }
        }
        return arr
    }
}
