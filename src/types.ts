export interface MaskOptions {
  /**
   * Separator between integer number groups
   *
   * Default: `space`
   */
  groupingSeparator?: string;
  /**
   * Separator between integer and fraction parts
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
   *
   * Default: `Infinity`
   */
  maximumIntegerDigits?: number;
  /**
   * Maximum length in fractional part
   *
   * Default: `2`
   */
  maximumFractionalDigits?: number;
}
