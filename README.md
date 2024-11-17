# react-native-money-input

<p align="center">
  <a href="https://opensource.org/licenses/MIT">
    <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT license" />
  </a>
  <a href="https://npmjs.org/package/@alexzunik/react-native-money-input">
    <img src="http://img.shields.io/npm/v/@alexzunik/react-native-money-input.svg" alt="Current npm package version" />
  </a>
  <a href="https://npmjs.org/package/@alexzunik/react-native-money-input">
    <img src="http://img.shields.io/npm/dm/@alexzunik/react-native-money-input.svg" alt="Downloads" />
  </a>
  <a href="https://npmjs.org/package/@alexzunik/react-native-money-input">
    <img src="http://img.shields.io/npm/dt/@alexzunik/react-native-money-input.svg?label=total%20downloads" alt="Total downloads" />
  </a>
</p>

🔥🔥🔥 Fully native money input for React Native. Based original TextInput component.

## 🚀 Example

|iOS|Android|
|-|-|
| ![iOS Demo](https://raw.githubusercontent.com/AleksandrNikolaevich/react-native-money-input/master/assets/ios.gif) | ![Android Demo](https://raw.githubusercontent.com/AleksandrNikolaevich/react-native-money-input/master/assets/android.gif) |




## 📥 Installation

```sh
yarn add @alexzunik/react-native-money-input

npx pod-install
```

## 🎮 Usage

```js
import { MoneyTextInput } from '@alexzunik/react-native-money-input';

// ...

const Component = () => {
  const [value, setValue] = React.useState<string>();
  return (
    <MoneyTextInput
        value={value}
        onChangeText={(formatted, extracted) => {
          console.log(formatted) // $1,234,567.89
          console.log(extracted) // 1234567.89
          setValue(extracted)
        }}
        prefix="$"
        groupingSeparator=","
        fractionSeparator="."
      />
  )
}
```


## 📦 Props

The component fully inherits TextInput props and brings new props. See below:

```ts
export interface MoneyTextInputProps extends TextInputProps, MaskOptions {
  /**
   * Callback with entered value
   *
   * @param formatted {string} formatted text
   * @param extracted {string} extracted text
   */
  onChangeText: (formatted: string, extracted?: string) => void;
}
```

```ts

interface MaskOptions {
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
```

## 👨‍🔧 Testing

in order to load mocks provided by react-native-money-input add following to your jest config in jest.config.json:

```
"setupFiles": ["./node_modules/@alexzunik/react-native-money-input/jest/setup.js"]
```

## 🤝 Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
