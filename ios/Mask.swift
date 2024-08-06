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
  }

  static let systemDecimalSeparator = NumberFormatter().decimalSeparator ?? "."
  
  public static func apply(for text: String, withOptions options: Options) -> String {
    let rawText = Mask.range(
      text: Mask.unmask(text: text, withOptions: options),
      minValue: options.minValue,
      maxValue: options.maxValue
    )
      .replace(substring: systemDecimalSeparator, withTemplate: options.fractionSeparator)
    
    if rawText.count == 0 {
      return ""
    }
    
    let fractionSeparators = rawText.components(separatedBy: options.fractionSeparator)
    
    let integerPart = Int(fractionSeparators[0]) ?? 0

    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumIntegerDigits = options.maximumIntegerDigits ?? numberFormatter.maximumIntegerDigits
    numberFormatter.groupingSeparator = options.groupingSeparator
    
    var result = numberFormatter.string(from: NSNumber(value: integerPart)) ?? ""
    
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
      .replace(substring: options.fractionSeparator, withTemplate: systemDecimalSeparator)
      .replace(prefix: options.prefix ?? "", withTemplate: "")
      .replace(suffix: options.suffix ?? "", withTemplate: "")
      .replace(pattern: "[^\\d\\\(systemDecimalSeparator)]", withTemplate: "")
  }
  
  private static func range(text: String, minValue: Double?, maxValue: Double?) -> String {
    var result = text == systemDecimalSeparator
      ? "0."
      : text
        .replace(substring: systemDecimalSeparator, withTemplate: ".")
    
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
}
