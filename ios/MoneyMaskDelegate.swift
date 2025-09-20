
import UIKit

protocol InputListener: UITextFieldDelegate {}

class MoneyMaskDelegate: NSObject, UITextFieldDelegate {
  weak var listener: InputListener?
  
  let options: Mask.Options
  let onChange: (_ textField: UITextField, _ value: String) -> Void
  
  init(listener: InputListener, options: Mask.Options, onChange: @escaping (_ textField: UITextField, _ value: String) -> Void) {
    self.listener = listener
    self.options = options
    self.onChange = onChange
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let text = textField.text ?? ""
    let suffix = (options.suffix ?? "")
    let resultString = text
      .replacingCharacters(in: Range(range, in: text)!, with: string)
      .replace(
        suffix: Mask.systemDecimalSeparator + suffix,
        withTemplate: options.fractionSeparator + suffix
      )
    
    let maskedText = Mask.apply(for: resultString, withOptions: options)
    
    textField.text = maskedText
    textField.caretPosition = maskedText.count - options.suffixLength
    
    self.onChange(textField, maskedText)
    
    return false
  }
}

// MARK: default RNTextInput handlers
extension MoneyMaskDelegate {
  open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    return listener?.textFieldShouldBeginEditing?(textField) ?? true
  }
  
  open func textFieldDidBeginEditing(_ textField: UITextField) {
    listener?.textFieldDidBeginEditing?(textField)
  }
  
  open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    return listener?.textFieldShouldEndEditing?(textField) ?? true
  }
  
  open func textFieldDidEndEditing(_ textField: UITextField) {
    listener?.textFieldDidEndEditing?(textField)
  }
  
  @available(iOS 10.0, *)
  open func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
    if listener?.textFieldDidEndEditing?(textField, reason: reason) != nil {
      listener?.textFieldDidEndEditing?(textField, reason: reason)
    } else {
      listener?.textFieldDidEndEditing?(textField)
    }
  }
}
