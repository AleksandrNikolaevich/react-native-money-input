extension String {
  subscript(safe range: ClosedRange<Int>) -> String {
    if self.count < range.count {
      return self
    }

    let index = self.index(self.startIndex, offsetBy: range.count - 1)
    let result = String(self[..<index])
    return result
  }
  
  func replace(pattern: String, withTemplate: String) -> String {
    guard let removeCharactersExpression = try? NSRegularExpression(pattern: pattern) else { return self }
  
    let range = NSMakeRange(0, self.count)
    
    return removeCharactersExpression.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: withTemplate)
  }
  
  func replace(substring: String, withTemplate: String) -> String {
    return self.replacingOccurrences(of: substring, with: withTemplate, options: .literal, range: nil)
  }
  
  func with(suffix: String?) -> String {
    guard let suffix = suffix else {
      return self
    }
    if self.count > 0 {
      return self + suffix
    }
    return self
  }
  
  func with(prefix: String?) -> String {
    guard let prefix = prefix else {
      return self
    }
    if self.count > 0 {
      return prefix + self
    }
    return self
  }
}
