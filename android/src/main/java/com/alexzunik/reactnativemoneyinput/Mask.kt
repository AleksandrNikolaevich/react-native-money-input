package com.alexzunik.reactnativemoneyinput

import java.text.DecimalFormat
import java.text.DecimalFormatSymbols
import kotlin.math.floor

class Mask {
  class Options(
    val groupingSeparator: String,
    val fractionSeparator: String,
    val prefix: String,
    val suffix: String,
    val maximumIntegerDigits: Int?,
    val maximumFractionalDigits: Int,
    val minValue: Double?,
    val maxValue: Double?,
  ){}


  companion object {
    val systemDecimalSeparator = DecimalFormat().decimalFormatSymbols.decimalSeparator.toString()
    val jsDecimalSeparator = "."

    fun apply(forText: String, options: Options): String {
      val rawText = range(
        text =  unmask(forText, options),
        minValue = options.minValue,
        maxValue = options.maxValue
      )
        .replace(systemDecimalSeparator, options.fractionSeparator)

      if (rawText.isEmpty()) {
        return ""
      }

      val fractionSeparators = rawText.split(options.fractionSeparator)

      val decimalFormatSymbols = DecimalFormatSymbols()
      decimalFormatSymbols.groupingSeparator = options.groupingSeparator.toCharArray()[0]

      val formatter = DecimalFormat()

      val maximumIntegerDigits = options.maximumIntegerDigits ?: formatter.maximumIntegerDigits

      formatter.maximumIntegerDigits = maximumIntegerDigits
      formatter.decimalFormatSymbols = decimalFormatSymbols

      val integerPart = if (fractionSeparators[0].isEmpty()) 0
        else truncate(fractionSeparators[0], maximumIntegerDigits).toBigInteger()

      var result = formatter.format(integerPart)

      if (fractionSeparators.count() == 1) {
        return result
          .withPrefix(options.prefix)
          .withSuffix(options.suffix)
      }

      if (options.maximumFractionalDigits > 0) {
        result += options.fractionSeparator

        val fraction = fractionSeparators[1]

        result += if (fraction.count() > options.maximumFractionalDigits)
          fraction.slice(0 until options.maximumFractionalDigits)
        else
          fraction
      }


      return result
        .withPrefix(options.prefix)
        .withSuffix(options.suffix)
    }

    fun unmask(text: String, options: Options): String {
      return text
        .replace(options.fractionSeparator, jsDecimalSeparator)
        .removePrefix(options.prefix)
        .removeSuffix(options.suffix)
        .replace(Regex("[^\\d\\$jsDecimalSeparator]"), "")
    }

    private fun range(text: String, minValue: Double?, maxValue: Double?): String {
      var result = if (text == jsDecimalSeparator)
        "0."
      else
        text

      if (minValue != null) {
        val value = result.toDoubleOrNull() ?: return ""

        if (minValue > value) {
          result = minValue.format()
        }
      }

      if (maxValue != null) {
        val value = result.toDoubleOrNull() ?: return ""

        if (maxValue < value) {
          result = maxValue.format()
        }
      }

      return result
        .replace(".", systemDecimalSeparator)
    }

    private fun truncate(string: String, length: Int): String {
      return if (string.length > length) {
        string.substring(0, length)
      } else {
        string
      }
    }

    private fun Double.format(): String {
      val likeInteger = floor(this) == this
      return if (likeInteger)
          this.toString().replace(".0", "")
        else
          this.toString()
    }

    private fun String.withSuffix(suffix: String): String {
      if (this.isEmpty()) {
        return this
      }
      return this + suffix
    }

    private fun String.withPrefix(prefix: String): String {
      if (this.isEmpty()) {
        return this
      }
      return prefix + this
    }
  }
}
