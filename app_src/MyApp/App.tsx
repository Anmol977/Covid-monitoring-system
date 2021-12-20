import React from 'react';
import {
  Text,
  HStack,
  Center,
  Switch,
  useColorMode,
  NativeBaseProvider,
  StorageManager,
  ColorMode
} from 'native-base';
import Login from './screens/login';
import SplashScreen from "react-native-splash-screen";
import AsyncStorage from '@react-native-async-storage/async-storage';
import theme from './theme/theme';

const colorModeManager: StorageManager = {
  get: async () => {
    try {
      let val = await AsyncStorage.getItem('@color-mode');
      return val === 'light' ? 'light' : 'dark';
    } catch (e) {
      return 'light';
    }
  },
  set: async (value: any) => {
    try {
      await AsyncStorage.setItem('@color-mode', value);
    } catch (e) {
      console.log(e);
    }
  },
};

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

  React.useEffect(() => {
    SplashScreen.hide();
  });

  return (
    <NativeBaseProvider theme={theme} colorModeManager={colorModeManager}>
      <Center
        _dark={{ bg: theme.colorModeValues.dark }}
        _light={{ bg: theme.colorModeValues.light }}
        px={4}
        flex={1}
        w="100%">
        <Login />
        <ToggleDarkMode />
      </Center>
    </NativeBaseProvider>
  );
};
export default App;
