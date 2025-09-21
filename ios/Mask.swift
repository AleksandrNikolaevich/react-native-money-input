public class Mask {
  public struct Options {
    let groupingSeparator: String
    let fractionSeparator: String
    let suffix: String?
    let prefix: String?
    let maximumIntegerDigits: Int?
    let maximumFractionalDigits: Int
    let minValue: Double?
    let maxValue: Double?
    var suffixLength: Int {
      get {
        suffix?.count ?? 0
      }
    }
    let needBeforeUnmasking: Bool
  }
  
  static let systemDecimalSeparator = NumberFormatter().decimalSeparator ?? "."
  static let jsDecimalSeparator = "."
  
  public static func apply(for text: String, withOptions options: Options) -> String {
    let rawText = Mask.range(
      text: options.needBeforeUnmasking ? Mask.unmask(text: text, withOptions: options) : text,
      minValue: options.minValue,
      maxValue: options.maxValue
    )
      .replace(substring: systemDecimalSeparator, withTemplate: options.fractionSeparator)
    
    if rawText.count == 0 {
      return ""
    }
    
    let fractionSeparators = rawText.components(separatedBy: options.fractionSeparator)
    
    let numberFormatter = NumberFormatter()
    
    let maximumIntegerDigits = options.maximumIntegerDigits ?? numberFormatter.maximumIntegerDigits
    
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumIntegerDigits = maximumIntegerDigits
    numberFormatter.groupingSeparator = options.groupingSeparator
    
    let integerPart = Decimal(string: truncate(fractionSeparators[0], toLength: maximumIntegerDigits)) ?? 0
    
    var result = numberFormatter.string(from: NSDecimalNumber(decimal: integerPart)) ?? ""
    
    if (options.maximumFractionalDigits > 0) {
      guard let fractionalPart = fractionSeparators[safe: 1] else {
        return result
          .with(prefix: options.prefix)
          .with(suffix: options.suffix)
      }
      
      result += options.fractionSeparator
      result += fractionalPart[safe: 0...options.maximumFractionalDigits]
    }
    
    return result
      .with(prefix: options.prefix)
      .with(suffix: options.suffix)
  }
  
  public static func unmask(text: String, withOptions options: Options) -> String {
    return text
      .replace(substring: options.groupingSeparator, withTemplate: "")
      .replace(substring: options.fractionSeparator, withTemplate: jsDecimalSeparator)
      .replace(prefix: options.prefix ?? "", withTemplate: "")
      .replace(suffix: options.suffix ?? "", withTemplate: "")
      .replace(pattern: "[^\\d\\\(jsDecimalSeparator)]", withTemplate: "")
  }
  
  private static func range(text: String, minValue: Double?, maxValue: Double?) -> String {
    var result = text == systemDecimalSeparator
    ? "0."
    : text
    
    if (minValue != nil) {
      guard let value = Double(result) else {
        return ""
      }
      
      if (minValue! > value) {
        result = minValue!.format()
      }
    }
    
    if (maxValue != nil) {
      guard let value = Double(result) else {
        return ""
      }
      
      if (maxValue! < value) {
        result = maxValue!.format()
      }
    }
    
    return result
      .replace(substring: ".", withTemplate: systemDecimalSeparator)
  }
  
  private static func truncate(_ string: String, toLength length: Int) -> String {
    return string.count > length
    ? String(string.prefix(length))
    : string
  }
}
