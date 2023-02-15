package com.alexzunik.reactnativemoneyinput

import android.text.Editable
import android.text.TextWatcher
import android.widget.EditText

class MaskedTextWatcher(
  private val field: EditText,
  private val options: Mask.Options,
): TextWatcher {
  private var old = ""
  override fun beforeTextChanged(sequence: CharSequence?, start: Int, count: Int, afterChange: Int) {
    if (sequence == null) {
      return
    }
    old = sequence.subSequence(start, start+count).toString();
  }

  override fun onTextChanged(sequence: CharSequence?, start: Int, count: Int, afterChange: Int) {}

  override fun afterTextChanged(value: Editable?) {
    if (value != null && value.toString() == old) {
      return
    }
    val newValue = Mask.apply(value.toString(), options)
    field.setText(newValue)
    val newCursorPosition = newValue.length - options.suffix.length
    if (newCursorPosition > 0) {
      field.setSelection(newCursorPosition)
    }
  }
}
