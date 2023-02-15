extension UITextField {
  var allTextRange: UITextRange? {
    return self.textRange(from: self.beginningOfDocument, to: self.endOfDocument)
  }
  
  var allText: String {
    get {
      guard let all: UITextRange = allTextRange
      else { return "" }
      return self.text(in: all) ?? ""
    }
    
    set(newText) {
      guard let all: UITextRange = allTextRange
      else { return }
      self.replace(all, withText: newText)
    }
  }
  
  var caretPosition: Int {
    get {
      if let responder = self as? UIResponder {
        guard responder.isFirstResponder
        else { return allText.count }
      }
      
      if let range: UITextRange = selectedTextRange {
        let selectedTextLocation: UITextPosition = range.start
        return offset(from: beginningOfDocument, to: selectedTextLocation)
      } else {
        return 0
      }
    }
    
    set(newPosition) {
      if newPosition < 0 {
        return
      }
      if let responder = self as? UIResponder {
        guard responder.isFirstResponder
        else { return }
      }
      
      if newPosition > allText.count {
        return
      }
      
      let from: UITextPosition = position(from: beginningOfDocument, offset: newPosition)!
      let to:   UITextPosition = position(from: from, offset: 0)!
      selectedTextRange = textRange(from: from, to: to)
    }
  }
}
