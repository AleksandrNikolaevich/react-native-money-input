public class Mask {
  public struct Options {
    let groupingSeparator: String
    let fractionSeparator: String
    let suffix: String?
    let prefix: String?
    let maximumIntegerDigits: Int?
    let maximumFractionalDigits: Int
    var suffixLength: Int {
      get {
        suffix?.count ?? 0
      }
    }
  }

  static private let staticFractionSeparator = "."
  
  public static func apply(for text: String, withOptions options: Options) -> String {
    let rawText = Mask.unmask(text: text, withOptions: options)
      .replace(substring: staticFractionSeparator, withTemplate: options.fractionSeparator)
    
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
    
    guard let fractionalPart = fractionSeparators[safe: 1] else {
      return result
        .with(prefix: options.prefix)
        .with(suffix: options.suffix)
    }
    
    result += options.fractionSeparator
    result += fractionalPart[safe: 0...options.maximumFractionalDigits]
    
    return result
      .with(prefix: options.prefix)
      .with(suffix: options.suffix)
  }
  
  public static func unmask(text: String, withOptions options: Options) -> String {
    return text
      .replace(substring: options.fractionSeparator, withTemplate: staticFractionSeparator)
      .replace(pattern: "[^\\d\\.]", withTemplate: "")
  }
}
