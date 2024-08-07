import React, { useState } from 'react';

import {
  StyleSheet,
  View,
  Text,
  Button,
  Keyboard,
  KeyboardAvoidingView,
  Platform,
} from 'react-native';
import { MoneyTextInput } from '@alexzunik/react-native-money-input';

function getRandom(min: number, max: number) {
  return Math.round(Math.random() * (max - min) + min);
}

export default function App() {
  const [value, setValue] = useState<string>();
  const [isUsd, setIsUsd] = useState<boolean>(true);
  const [isFocused, setFocus] = useState<boolean>(false);

  return (
    <KeyboardAvoidingView
      style={{ flex: 1 }}
      enabled={Platform.OS === 'ios'}
      behavior="padding"
    >
      <View style={styles.container}>
        <Text>Money masked field</Text>
        <MoneyTextInput
          style={styles.input}
          value={value}
          onChangeText={(_, unmasked) => setValue(unmasked)}
          onChange={({ nativeEvent }) => console.log(nativeEvent)}
          onKeyPress={({ nativeEvent }) => console.log(nativeEvent)}
          onFocus={() => setFocus(true)}
          onBlur={() => setFocus(false)}
          prefix={isUsd ? '$' : ''}
          suffix={isUsd ? '' : ' EUR'}
          groupingSeparator={isUsd ? ',' : ' '}
          fractionSeparator={isUsd ? '.' : ','}
          maximumIntegerDigits={9}
          maximumFractionalDigits={2}
          placeholder="$0,000,000.00"
          autoFocus
        />

        <View style={styles.separator} />

        <Text>System fraction separator</Text>
        <MoneyTextInput
          style={styles.input}
          value={value}
          onChangeText={(_, unmasked) => setValue(unmasked)}
          onChange={({ nativeEvent }) => console.log(nativeEvent)}
          onKeyPress={({ nativeEvent }) => console.log(nativeEvent)}
          onFocus={() => setFocus(true)}
          onBlur={() => setFocus(false)}
          prefix={value ? '+' : ''}
          suffix={' шт'}
          groupingSeparator={' '}
          maximumIntegerDigits={9}
          maximumFractionalDigits={2}
          minValue={2}
          maxValue={5.44}
        />

        <Text>Value: {value}</Text>
        <Text>Is focused: {isFocused ? 'true' : 'false'}</Text>
        <Button
          title="Set random value"
          onPress={() => {
            setValue(`${getRandom(10000, 9999999)}.${getRandom(1, 9999999)}`);
          }}
        />
        <Button title="Hide keyboard" onPress={Keyboard.dismiss} />
        <Button
          title="Change currency"
          onPress={() => {
            setIsUsd((prev) => !prev);
          }}
        />
      </View>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingHorizontal: 20,
    justifyContent: 'center',
  },
  input: {
    height: 48,
    paddingHorizontal: 14,
    backgroundColor: '#eee',
    borderRadius: 10,
  },
  separator: {
    height: 20,
  },
});
