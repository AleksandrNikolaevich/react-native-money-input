export interface MaskOptions {
  /**
   * Separator between integer number groups
   *
   * Default: `space`
   */
  groupingSeparator?: string;
  /**
   * Separator between integer and fraction parts.
   * Will be ignored if you set maximumFractionalDigits = 0
   *
   * Default: system separator
   */
  fractionSeparator?: string;
  /**
   * Prefix before number.
   *
   * For example: if prefix = `$` input will be `$1,234.43`
   *
   * Default: `undefined`
   */
  prefix?: string;
  /**
   * Suffix after number.
   *
   * For example: if suffix = ` EUR` input will be `1 234,43 EUR`
   *
   * Default: `undefined`
   */
  suffix?: string;
  /**
   * Maximum length in integer part, exclude separators
   * Maximum possible value is 36
   *
   * Default: `36`
   */
  maximumIntegerDigits?: number;
  /**
   * Maximum length in fractional part
   *
   * Default: `2`
   */
  maximumFractionalDigits?: number;
  /**
   * Minimum numeric value.
   * It will be set to input if user enters value less than minValue
   */
  minValue?: number;
  /**
   * Maximum numeric value.
   * It will be set to input if user enters value greater than maxValue
   */
  maxValue?: number;
}
