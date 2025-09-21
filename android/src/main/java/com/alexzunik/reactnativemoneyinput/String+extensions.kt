package com.alexzunik.reactnativemoneyinput

fun String.replaceSuffix(oldSuffix: String, newSuffix: String): String {
    return if (this.endsWith(oldSuffix)) {
        this.removeSuffix(oldSuffix) + newSuffix
    } else {
        this
    }
}