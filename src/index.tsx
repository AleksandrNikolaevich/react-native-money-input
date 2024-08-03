import React, {
  forwardRef,
  useCallback,
  useEffect,
  useImperativeHandle,
  useMemo,
  useRef,
  useState,
} from 'react';
import type { TextInputProps } from 'react-native';
import { findNodeHandle } from 'react-native';
import { NativeModules, Platform, TextInput } from 'react-native';
import type { MaskOptions } from './types';

const LINKING_ERROR =
  `The package '@alexzunik/react-native-money-input' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const ReactNativeMoneyInput = NativeModules.ReactNativeMoneyInput
  ? NativeModules.ReactNativeMoneyInput
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

/**
 * Apply mask to TextInput
 *
 * @param reactNode {number}
 * @param options {MaskOptions}
 */
export function applyMask(reactNode: number, options: MaskOptions) {
  ReactNativeMoneyInput.applyMask(reactNode, options);
}

/**
 * Release source for applied mask
 *
 * @param reactNode {number}
 */
export function unmount(reactNode: number) {
  ReactNativeMoneyInput.unmount(reactNode);
}

/**
 * Apply mask to any text, return promise with result
 *
 * @param reactNode {number}
 * @param options {MaskOptions}
 */
export function mask(text: string, options: MaskOptions): Promise<string> {
  return ReactNativeMoneyInput.mask(text, options);
}

/**
 * Unmask masked text, return promise with result
 *
 * @param reactNode {number}
 * @param options {MaskOptions}
 */
export function unmask(text: string, options: MaskOptions): Promise<string> {
  return ReactNativeMoneyInput.unmask(text, options);
}

export interface MoneyTextInputProps extends TextInputProps, MaskOptions {
  /**
   * Callback with entered value
   *
   * @param formatted {string} formatted text
   * @param extracted {string} extracted text
   */
  onChangeText: (formatted: string, extracted?: string) => void;
}

export const MoneyTextInput = forwardRef<TextInput, MoneyTextInputProps>(
  (
    {
      groupingSeparator = ' ',
      fractionSeparator,
      suffix,
      prefix,
      maximumFractionalDigits = 2,
      maximumIntegerDigits,
      onChangeText,
      value,
      ...props
    },
    ref
  ) => {
    const inputRef = useRef<TextInput>(null);
    const [internalValue, setInternalValue] = useState<string>('');

    useImperativeHandle(ref, () => inputRef.current!);

    const maskOptions = useMemo(
      () => ({
        groupingSeparator,
        fractionSeparator,
        suffix,
        prefix,
        maximumIntegerDigits,
        maximumFractionalDigits,
      }),
      [
        fractionSeparator,
        groupingSeparator,
        maximumFractionalDigits,
        maximumIntegerDigits,
        suffix,
        prefix,
      ]
    );

    useEffect(() => {
      const reactNode = findNodeHandle(inputRef.current);
      if (!reactNode) {
        return;
      }
      applyMask(reactNode, maskOptions);
    }, [maskOptions]);

    useEffect(() => {
      const reactNode = findNodeHandle(inputRef.current);
      if (!reactNode) {
        return;
      }
      return () => {
        unmount(reactNode);
      };
    }, []);

    useEffect(() => {
      mask(value ?? '', maskOptions).then(setInternalValue);
    }, [value, maskOptions]);

    const changeValueHandler = useCallback(
      (text: string) => {
        setInternalValue(text);
        unmask(text, maskOptions).then((unmasked) => {
          onChangeText?.(text, unmasked);
        });
      },
      [maskOptions, onChangeText]
    );

    return (
      <TextInput
        ref={inputRef}
        keyboardType="numeric"
        {...props}
        onChangeText={changeValueHandler}
        value={internalValue}
      />
    );
  }
);
