import React from 'react' ;
import {
  Link,
  Text,
  HStack,
  Center,
  Heading,
  Switch,
  useColorMode,
  NativeBaseProvider,
  VStack,
  Code,
} from 'native-base';
import Login from './screens/login';
// import theme from './theme/theme';

function ToggleDarkMode() {
  const { colorMode, toggleColorMode } = useColorMode();
  return (
    <HStack space={2} alignItems="center">
      <Text>Dark</Text>
      <Switch
        isChecked={colorMode === 'light' ? true : false}
        onToggle={toggleColorMode}
        aria-label={
          colorMode === 'light' ? 'switch to dark mode' : 'switch to light mode'
        }
      />
      <Text>Light</Text>
    </HStack>
  );
}
const App = () => {
  return (
    <NativeBaseProvider >
      <Center
        _dark={{ bg: '#202023' }}
        _light={{ bg: '#f0e7db' }}
        px={4}
        flex={1}
        w="100%">
        <Login />
        <ToggleDarkMode />
        {/* <VStack space={5} alignItems="center"> */}
        {/* </VStack> */}
      </Center>
    </NativeBaseProvider>
  );
};
export default App;
