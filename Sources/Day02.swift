struct Day02: AdventDay {
    
    private let maxNumberOfCubes = [
        "red": 12,
        "green": 13,
        "blue": 14
    ]
    
    var data: String
    
    func part1() async throws -> Any {
        data.split(separator: "\n").reduce(0) { partialResult, line in
            let gameInfo = line.split(separator: ":")
            let gameId = Int(gameInfo[0].split(separator: " ")[1])!
            let cubeSets = gameInfo[1].split(separator: ";").map({ $0.split(separator: ",") })
            for cubeSet in cubeSets {
                for cubes in cubeSet {
                    let selectedNumberOfCubes = Int(String(cubes.split(separator: " ")[0]))!
                    let selectedColorOfCubes = String(cubes.split(separator: " ")[1])
                    if maxNumberOfCubes[selectedColorOfCubes]! < selectedNumberOfCubes {
                        return partialResult
                    }
                }
            }
            return partialResult + gameId
        }
    }
    
}
