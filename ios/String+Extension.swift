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
  
  func replace(substring: String, withTemplate template: String, range: Range<String.Index>? = nil) -> String {
    return self.replacingOccurrences(of: substring, with: template, options: .literal, range: range)
  }
  
  func replace(prefix text: String, withTemplate template: String) -> String {
    if (self.count < text.count) {
      return self
    }
    let range = text.startIndex..<text.endIndex
    return self.replace(substring: text, withTemplate: template, range: range)
  }
  
  func replace(suffix text: String, withTemplate template: String) -> String {
    if (self.count < text.count) {
      return self
    }
    let range = self.index(self.endIndex, offsetBy: -text.count)..<self.endIndex
    return self.replace(substring: text, withTemplate: template, range: range)
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
