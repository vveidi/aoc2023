struct Day01: AdventDay {
    
    var data: String
    
    func part1() async throws -> Any {
        data.split(separator: "\n").reduce(0) { partialResult, line in
            guard let firstDigit = line.firstNonNil({ $0.wholeNumberValue }),
                  let secondDigit = line.lastNonNil({ $0.wholeNumberValue })
            else {
                return 0
            }
            return partialResult + (firstDigit * 10 + secondDigit)
        }
    }
    
    func part2() async throws -> Any {
        data.split(separator: "\n").reduce(0) { partialResult, line in
            var firstString = ""
            var secondString = ""
            
            let firstDigit = line.firstNonNil { char in
                firstString.append(char)
                let possibleSpelledOutWholeNumber = firstString.findDigitSpelledOutWithLetters()
                return char.wholeNumberValue ?? possibleSpelledOutWholeNumber
            }
            let secondDigit = line.lastNonNil { char in
                secondString.insert(char, at: secondString.startIndex)
                let possibleSpelledOutWholeNumber = secondString.findDigitSpelledOutWithLetters()
                return char.wholeNumberValue ?? possibleSpelledOutWholeNumber
            }
            
            guard let firstDigit, let secondDigit else {
                return 0
            }
            return partialResult + (firstDigit * 10 + secondDigit)
        }
    }
}

private extension String {
    private var digits: [String] {
        ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
    }
    func findDigitSpelledOutWithLetters() -> Int? {
        digits
            .compactMap { digit in
                if self.contains(digit) {
                    return (digits.firstIndex(of: digit) ?? 0) + 1
                } else {
                    return nil
                }
            }
            .first
    }
}

private extension Substring {
    func lastNonNil<Result>(_ transform: (String.Element) throws -> Result?) rethrows -> Result? {
        try self.reversed().firstNonNil(transform)
    }
}
