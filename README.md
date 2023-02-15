# react-native-money-input

Fully native money input for React Native

## Example

|iOS|Android|
|-|-|
| ![iOS Demo](https://raw.githubusercontent.com/AleksandrNikolaevich/react-native-money-input/master/assets/ios.gif) | ![Android Demo](https://raw.githubusercontent.com/AleksandrNikolaevich/react-native-money-input/master/assets/android.gif) |




## Installation

```sh
yarn add @alexzunik/react-native-money-input

npx pod-install
```

## Usage

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


## Props

```ts

interface MaskOptions {
  /**
   * Separator between integer number groups
   *
   * Default: `space`
   */
  groupingSeparator?: string;
  /**
   * Separator between integer and fraction parts
   *
   * Default: `,`
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
```

## Testing

in order to load mocks provided by react-native-money-input add following to your jest config in jest.config.json:

```
"setupFiles": ["./node_modules/@alexzunik/react-native-money-input/jest/setup.js"]
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
