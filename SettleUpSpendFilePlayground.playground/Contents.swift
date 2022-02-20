import Foundation

extension String {
    func matches(regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}

if let path = Bundle.main.path(forResource: "spendings", ofType: "txt") {
    do {
        let data = try String(contentsOfFile: path, encoding: .utf8)
        let lines = data.components(separatedBy: .newlines)
        
        // Fetch every line's last signed-number (ex: +100, -230)
        let signedNumberRegexFormat = "^*[+-][0-9]+$"
        let numbers = lines
            .compactMap { $0.matches(regex: signedNumberRegexFormat).last }
            .compactMap { Int($0) }
        
        print("#### Numbers: \(numbers)")
        
        let sum = numbers.reduce(0, +)
        print("#### Sum: \(sum)")
        
    } catch {
        print("#### Error: \(error)")
    }
} else {
    print("#### File Not found")
}
