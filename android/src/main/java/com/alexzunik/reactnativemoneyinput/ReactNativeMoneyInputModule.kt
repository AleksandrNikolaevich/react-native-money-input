package com.alexzunik.reactnativemoneyinput

import android.text.TextWatcher
import android.widget.EditText
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.UIManagerModule
import com.facebook.react.uimanager.UIManagerHelper
import com.facebook.react.bridge.UiThreadUtil

class ReactNativeMoneyInputModule(private val reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String {
    return NAME
  }

  private val listeners = hashMapOf<String, TextWatcher?>()

  @ReactMethod
  fun applyMask(reactNode: Int, options: ReadableMap) {
    UiThreadUtil.runOnUiThread {
      val uiManager =
        UIManagerHelper.getUIManagerForReactTag(reactContext, reactNode)

      val editText = getComponent(reactNode) ?: return@runOnUiThread

      val prevListener = listeners[getKey(reactNode)]

      if (prevListener != null) {
        editText.removeTextChangedListener(prevListener)
      }

      val listener = MaskedTextWatcher(editText, getMaskOptions(options))

      listeners[getKey(reactNode)] = listener

      editText.addTextChangedListener(listener)
      editText.setSelection(editText.text.toString().length)
    }
  }

  @ReactMethod
  fun unmount(reactNode: Int) {
    val editText = getComponent(reactNode) ?: return
    val listener = listeners[getKey(reactNode)] ?: return
    editText.removeTextChangedListener(listener)
    listeners.remove(getKey(reactNode))
  }

  @ReactMethod
  fun mask(value: String, options: ReadableMap, promise: Promise) {
    promise.resolve(Mask.apply(value, getMaskOptions(options)))
  }

  @ReactMethod
  fun unmask(value: String, options: ReadableMap, promise: Promise) {
    promise.resolve(Mask.unmask(value, getMaskOptions(options)))
  }

  private fun getKey(reactNode: Int): String {
    return reactNode.toString()
  }

  private fun getMaskOptions(options: ReadableMap): Mask.Options {
    val groupingSeparator = safeResolveString(options, "groupingSeparator", " ")
    val fractionSeparator = safeResolveString(options, "fractionSeparator", Mask.systemDecimalSeparator)
    val prefix = safeResolveString(options, "prefix", "")
    val suffix = safeResolveString(options, "suffix", "")
    val maximumIntegerDigits = safeResolveInt(options, "maximumIntegerDigits")
    val maximumFractionalDigits = safeResolveInt(options, "maximumFractionalDigits", 2)
    val minValue = safeResolveDouble(options, "minValue")
    val maxValue = safeResolveDouble(options, "maxValue")
    val needBeforeUnmasking = safeResolveBoolean(options, "needBeforeUnmasking", true)

    return Mask.Options(
      groupingSeparator,
      fractionSeparator,
      prefix,
      suffix,
      maximumIntegerDigits,
      maximumFractionalDigits,
      minValue,
      maxValue,
      needBeforeUnmasking)
  }

  private fun safeResolveString(map: ReadableMap, key: String): String? {
    return try {
      map.getString(key)
    } catch (e: Exception) {
      null
    }
  }
  private fun safeResolveString(map: ReadableMap, key: String, defaultValue: String): String {
    return safeResolveString(map, key) ?: defaultValue
  }

  private fun safeResolveInt(map: ReadableMap, key: String): Int? {
    return try {
      map.getInt(key)
    } catch (e: Exception) {
      null
    }
  }
  private fun safeResolveInt(map: ReadableMap, key: String, defaultValue: Int): Int {
    return safeResolveInt(map, key) ?: defaultValue
  }

  private fun safeResolveDouble(map: ReadableMap, key: String): Double? {
    return try {
      map.getDouble(key)
    } catch (e: Exception) {
      null
    }
  }

  private fun safeResolveDouble(map: ReadableMap, key: String, defaultValue: Double): Double {
    return safeResolveDouble(map, key) ?: defaultValue
  }

  private fun safeResolveBoolean(map: ReadableMap, key: String): Boolean? {
    if (!map.hasKey(key)) {
      return null
    }
    return try {
      map.getBoolean(key)
    } catch (e: Exception) {
      null
    }
  }

  private fun safeResolveBoolean(map: ReadableMap, key: String, defaultValue: Boolean): Boolean {
    return safeResolveBoolean(map, key) ?: defaultValue
  }

  private fun getComponent(reactNode: Int): EditText? {
    val uiManager =
      UIManagerHelper.getUIManagerForReactTag(reactContext, reactNode)

    return try {
      uiManager?.resolveView(reactNode) as? EditText ?: return null
    } catch (e: Throwable) {
      return null
    }
  }

  companion object {
    const val NAME = "ReactNativeMoneyInput"
  }
}
