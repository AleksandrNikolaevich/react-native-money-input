extension Double {
  func format() -> String {
    let likeInteger = floor(self) == self
    
    return likeInteger 
      ? String(self).replace(suffix: ".0", withTemplate: "")
      : String(self)
  }
}
