package com.alexzunik.reactnativemoneyinput

import java.text.DecimalFormat
import java.text.DecimalFormatSymbols

class Mask {
  class Options(
    val groupingSeparator: String,
    val fractionSeparator: String,
    val prefix: String,
    val suffix: String,
    val maximumIntegerDigits: Int?,
    val maximumFractionalDigits: Int
  ){}


  companion object {
    private const val staticFractionSeparator = "."

    fun apply(forText: String, options: Options): String {
      val rawText = unmask(forText, options)
        .replace(staticFractionSeparator, options.fractionSeparator)

      if (rawText.isEmpty()) {
        return ""
      }

      val fractionSeparators = rawText.split(options.fractionSeparator)
      val integerPart = fractionSeparators[0].toBigInteger()

      val formatter = DecimalFormat()

      formatter.maximumIntegerDigits = options.maximumIntegerDigits ?: formatter.maximumIntegerDigits
      val decimalFormatSymbols = DecimalFormatSymbols()
      decimalFormatSymbols.groupingSeparator = options.groupingSeparator.toCharArray()[0]
      formatter.decimalFormatSymbols = decimalFormatSymbols
      var result = formatter.format(integerPart)

      if (fractionSeparators.count() == 1) {
        return add(result,  options.prefix, options.suffix)
      }

      result += options.fractionSeparator

      val fraction = fractionSeparators[1]

      result += if (fraction.count() > options.maximumFractionalDigits)
        fraction.slice(0 until options.maximumFractionalDigits)
      else
        fraction

      return add(result, options.prefix, options.suffix)
    }

    fun unmask(text: String, options: Options): String {
      return text
        .replace(options.fractionSeparator, staticFractionSeparator)
        .replace(Regex("[^\\d\\.]"), "")
    }

    private fun add(text: String, prefix: String, suffix: String): String {
      if (text.isEmpty()) {
        return  text
      }
      return prefix + text + suffix
    }
  }
}
