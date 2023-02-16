const mockComponent = jest.requireActual(
  '../../../react-native/jest/mockComponent.js'
);

const MockNativeMethods = jest.requireActual(
  '../../../react-native/jest/MockNativeMethods'
);

jest.mock('@alexzunik/react-native-money-input', () => {
  return {
    MoneyTextInput: mockComponent(
      '../Libraries/Components/TextInput/TextInput',
      {
        ...MockNativeMethods,
        isFocused: jest.fn(),
        clear: jest.fn(),
        getNativeRef: jest.fn(),
      }
    ),
  };
});
