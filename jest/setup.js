const mockComponent = jest.requireActual(
  '../node_modules/react-native/jest/mockComponent.js'
);

const MockNativeMethods = jest.requireActual(
  '../node_modules/react-native/jest/MockNativeMethods'
);

jest.mock('@alexzunik/react-native-money-input', () => {
  return mockComponent('../Libraries/Components/TextInput/TextInput', {
    ...MockNativeMethods,
    isFocused: jest.fn(),
    clear: jest.fn(),
    getNativeRef: jest.fn(),
  });
});
