private struct Point: Hashable {
    let x: Int
    let y: Int
}

private struct Number: Hashable {
    let value: Int
    let start: Point
    let length: Int
    let neighbors: [Point]
    
    init(value: Int, start: Point, length: Int) {
        self.value = value
        self.start = start
        self.length = length
        self.neighbors = (start.x - 1...start.x + length).flatMap { x in
            (start.y - 1...start.y + 1).map { y in
                Point(x: x, y: y)
            }
        }
    }
}

struct Day03: AdventDay {
    
    var data: String
    
    private var symbols: Set<Point> = []
    private var numbers: Set<Number> = []
    private var gears: Set<Point> = []
    
    init(data: String) {
        self.data = data
        
        let lines = data.split(separator: "\n")
        
        for (y, line) in lines.enumerated() {
            for (x, char) in line.enumerated() {
                if char != "." && !char.isNumber {
                    self.symbols.insert(.init(x: x, y: y))
                }
                if char == "*" {
                    self.gears.insert(.init(x: x, y: y))
                }
            }
            let digits = line.enumerated().filter({ $1.isNumber })
            
            var value = digits[0].element.wholeNumberValue!
            var start = digits[0].offset
            var previousOffset = start
            var length = 1
            
            for digit in digits.dropFirst() {
                if digit.offset == previousOffset + 1 {
                    value = value * 10 + digit.element.wholeNumberValue!
                    previousOffset = digit.offset
                    length += 1
                } else {
                    self.numbers.insert(.init(value: value, start: .init(x: start, y: y), length: length))
                    value = digit.element.wholeNumberValue!
                    start = digit.offset
                    previousOffset = start
                    length = 1
                }
            }
            self.numbers.insert(.init(value: value, start: .init(x: start, y: y), length: length))
        }
    }
    
    func part1() async throws -> Any {
        numbers
            .filter { !symbols.intersection($0.neighbors).isEmpty }
            .reduce(0, { $0 + $1.value })
    }
    
    func part2() async throws -> Any {
        gears
            .map { gear in
                numbers.filter { $0.neighbors.contains(gear) }
            }
            .filter { $0.count == 2 }
            .map { nums in
                nums.reduce(1, { $0 * $1.value })
            }
            .reduce(0, { $0 + $1 })
    }
}
