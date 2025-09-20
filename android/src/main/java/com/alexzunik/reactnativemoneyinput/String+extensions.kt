package com.alexzunik.reactnativemoneyinput

fun String.replaceLast(oldValue: String, newValue: String): String {
    val index = this.lastIndexOf(oldValue)
    return if (index >= 0) {
        this.substring(0, index) + newValue + this.substring(index + oldValue.length)
    } else {
        this
    }
}