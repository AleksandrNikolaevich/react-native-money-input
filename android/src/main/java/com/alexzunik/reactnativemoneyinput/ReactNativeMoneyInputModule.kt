package com.alexzunik.reactnativemoneyinput

import android.text.TextWatcher
import android.widget.EditText
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.UIManagerModule

class ReactNativeMoneyInputModule(private val reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String {
    return NAME
  }

  private val listeners = hashMapOf<String, TextWatcher?>()

  @ReactMethod
  fun applyMask(reactNode: Int, options: ReadableMap) {
    val uiManager = reactContext.getNativeModule(UIManagerModule::class.java)!!

    uiManager.addUIBlock { viewRegistry ->
      val editText = viewRegistry.resolveView(reactNode) as EditText
      val prevListener = listeners[getKey(reactNode)]

      editText.removeTextChangedListener(prevListener)

      val listener = MaskedTextWatcher(editText, getMaskOptions(options))

      listeners.set(getKey(reactNode), listener)

      editText.addTextChangedListener(listener)
      editText.setSelection(editText.text.toString().length)
    }
  }

  @ReactMethod
  fun unmount(reactNode: Int) {
    listeners[getKey(reactNode)] = null
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
    val fractionSeparator = safeResolveString(options, "fractionSeparator", ".")
    val prefix = safeResolveString(options, "prefix", "")
    val suffix = safeResolveString(options, "suffix", "")
    val maximumIntegerDigits = safeResolveInt(options, "maximumIntegerDigits")
    val maximumFractionalDigits = safeResolveInt(options, "maximumFractionalDigits", 2)

    return Mask.Options(
      groupingSeparator,
      fractionSeparator,
      prefix,
      suffix,
      maximumIntegerDigits,
      maximumFractionalDigits)
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

  companion object {
    const val NAME = "ReactNativeMoneyInput"
  }
}
