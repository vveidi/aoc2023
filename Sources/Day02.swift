struct Day02: AdventDay {
    
    private let maxNumberOfCubes = [
        "red": 12,
        "green": 13,
        "blue": 14
    ]
    
    var data: String
    
    func part1() async throws -> Any {
        data.split(separator: "\n").reduce(0) { partialResult, line in
            let gameInfo = line.split(separator: ": ")
            let gameId = Int(gameInfo[0].split(separator: " ")[1])!
            let cubeSets = gameInfo[1].split(separator: "; ").map({ $0.split(separator: ", ") })
            for cubeSet in cubeSets {
                for cubes in cubeSet {
                    let numberOfSelectedCubes = Int(String(cubes.split(separator: " ")[0]))!
                    let colorOfSelectedCubes = String(cubes.split(separator: " ")[1])
                    if maxNumberOfCubes[colorOfSelectedCubes]! < numberOfSelectedCubes {
                        return partialResult
                    }
                }
            }
            return partialResult + gameId
        }
    }
    
    func part2() async throws -> Any {
        data.split(separator: "\n").reduce(0) { partialResult, line in
            var minNumberOfRedCubes: Int?
            var minNumberOfGreenCubes: Int?
            var minNumberOfBlueCubes: Int?
            
            line.split(separator: ": ")[1]
                .split(separator: "; ")
                .map({ $0.split(separator: ", ") })
                .forEach { cubeSet in
                    cubeSet.forEach { cubes in
                        let numberOfSelectedCubes = Int(String(cubes.split(separator: " ")[0]))!
                        let colorOfSelectedCubes = String(cubes.split(separator: " ")[1])
                        switch colorOfSelectedCubes {
                        case "red":
                            minNumberOfRedCubes = max(minNumberOfRedCubes ?? 0, numberOfSelectedCubes)
                        case "green":
                            minNumberOfGreenCubes = max(minNumberOfGreenCubes ?? 0, numberOfSelectedCubes)
                        case "blue":
                            minNumberOfBlueCubes = max(minNumberOfBlueCubes ?? 0, numberOfSelectedCubes)
                        default:
                            break
                        }
                    }
            }
            let powerOfSets = [minNumberOfRedCubes, minNumberOfGreenCubes, minNumberOfBlueCubes]
                .compactMap({ $0 })
                .reduce(1) { x, y in x * y }
            return partialResult + powerOfSets
        }
    }
    
}
