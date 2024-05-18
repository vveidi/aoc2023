//
//  Day08.swift
//  
//
//  Created by Вадим Буркин on 17.05.2024.
//

struct Day08: AdventDay {
    
    let instructions: [Character]
    let nodes: [String: [String]]
    
    init(data: String) {
        let lines = data.components(separatedBy: .newlines)
        
        self.instructions = Array(lines[0])
        self.nodes = lines[1...]
            .filter({ !$0.isEmpty })
            .map { line in
                line
                    .components(separatedBy: "=")
                    .map { element in
                        element
                            .components(separatedBy: .alphanumerics.inverted)
                            .filter({ !$0.isEmpty })
                            .joined(separator: ",")
                    }
            }
            .grouped(by: { $0[0] })
            .mapValues({ $0.flatMap({ $0 })[1].components(separatedBy: ",") })
    }
    
    func part1() async throws -> Any {
        var isExitFound = false
        var node = nodes.first(where: { $0.key == "AAA" })!
        var index = 0
        var iteration = 0
        
        while !isExitFound {
            iteration += 1
            let element = node.value[instructions[index].number]
            if element == "ZZZ" {
                isExitFound = true
            } else {
                index = (index == instructions.count - 1) ? 0 : (index + 1)
                node = nodes.first(where: { $0.key == element })!
            }
        }
        return iteration
    }
    
    func part2() async throws -> Any {
        let selectedNodes = nodes.filter({ $0.key.hasSuffix("A")})
        var paths = [Int](repeating: 0, count: selectedNodes.count)
        
        for (i, node) in selectedNodes.enumerated() {
            var node = node
            var index = 0
            var iteration = 0
            while true {
                iteration += 1
                let element = node.value[instructions[index].number]
                if element.hasSuffix("Z") {
                    paths[i] = iteration
                    break
                } else {
                    index = (index == instructions.count - 1) ? 0 : (index + 1)
                    node = nodes.first(where: { $0.key == element })!
                }
            }
        }
        return paths.reduce(1, lcm(_:_:))
    }
    
    func gcd(_ a: Int, _ b: Int) -> Int {
        let remainder = a % b
        return remainder == 0 ? b : gcd(b, remainder)
    }

    func lcm(_ a: Int, _ b: Int) -> Int {
        return a * b / gcd(a, b)
    }
}

private extension Character {
    var number: Int {
        switch self {
        case "L": 0
        case "R": 1
        default: fatalError()
        }
    }
}
