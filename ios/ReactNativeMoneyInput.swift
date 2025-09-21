@objc(ReactNativeMoneyInput)
class ReactNativeMoneyInput: NSObject, RCTBridgeModule {
  static func moduleName() -> String! {
    return "ReactNativeMoneyInput"
  }
  
  
  var bridge: RCTBridge!
  
  var methodQueue: DispatchQueue {
    return DispatchQueue.main
  }
  
  private var masks: [String:MoneyMaskDelegate] = [:]
  private var listeners: [String:TextFieldAdapter] = [:]
  
  @objc(applyMask:options:)
  func applyMask(reactNode: NSNumber, options: NSDictionary) -> Void {
    guard let view = bridge.uiManager.view(forReactTag: reactNode) else { return }
    guard let textInput = getTextInput(with: bridge, for: view) else { return }
    
    let key = self.getKey(byNode: reactNode)
    let options = self.getMaskOptions(from: options)
    let listener = TextFieldAdapter(textField: textInput)
    
    let delegate = MoneyMaskDelegate(listener: listener, options: options) { textField, value in
      textInput.textInputDelegate?.textInputDidChange()
    }
    
    self.listeners[key] = listener
    self.masks[key] = delegate
    
    textInput.delegate = delegate
  }
  
  @objc(unmount:)
  func unmount(reactNode: NSNumber) -> Void {
    let key = self.getKey(byNode: reactNode)
    self.masks[key] = nil
    self.listeners[key] = nil
  }
  
  @objc(mask:options:resolve:reject:)
  func mask(value: NSString, options: NSDictionary, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
    let options = getMaskOptions(from: options)
    
    resolve(
      Mask.apply(for: String(value), withOptions: options)
    )
  }
  
  @objc(unmask:options:resolve:reject:)
  func unmask(value: NSString, options: NSDictionary, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
    let options = getMaskOptions(from: options)

    resolve(
      Mask.unmask(text: String(value), withOptions: options)
    )
  }
  
  private func getKey(byNode tag: NSNumber) -> String {
    return tag.stringValue
  }
  
  private func getMaskOptions(from options: NSDictionary) -> Mask.Options {
    let groupingSeparator = options["groupingSeparator"] as? String ?? " "
    let fractionSeparator = options["fractionSeparator"] as? String ?? Mask.systemDecimalSeparator
    let suffix = options["suffix"] as? String
    let prefix = options["prefix"] as? String
    let maximumIntegerDigits = options["maximumIntegerDigits"] as? Int
    let maximumFractionalDigits = options["maximumFractionalDigits"] as? Int ?? 2
    let maxValue = options["maxValue"] as? Double
    let minValue = options["minValue"] as? Double
    let needBeforeUnmasking: Bool = options["needBeforeUnmasking"] as? Bool ?? true
    
    return Mask.Options(
      groupingSeparator: groupingSeparator,
      fractionSeparator: fractionSeparator,
      suffix: suffix,
      prefix: prefix,
      maximumIntegerDigits: maximumIntegerDigits,
      maximumFractionalDigits: maximumFractionalDigits,
      minValue: minValue,
      maxValue: maxValue,
      needBeforeUnmasking: needBeforeUnmasking)
  }
  
  private func getTextInput(with bridge: RCTBridge,for view: UIView) -> RCTUITextField? {
    // For bridgeless mode
    // TODO: need to find a better way
    if NSStringFromClass(type(of: view)) == "RCTTextInputComponentView" {
      guard let textInput = view.value(forKey: "_backedTextInputView") as? RCTUITextField else { return nil }
      
      return textInput
    }
    
    // With bridge
    guard let textInputWrapper = view as? RCTBaseTextInputView else { return nil }
    guard let textInput = textInputWrapper.backedTextInputView as? RCTUITextField else { return nil }
    
    return textInput
  }
}

class TextFieldAdapter : RCTBackedTextFieldDelegateAdapter, InputListener {}
