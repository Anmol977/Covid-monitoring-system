import {extendTheme, NativeBaseProvider} from 'native-base';

const styles = {
           global: {
                body: {
                     bg: mode('#f0e7db', '#202023')
                }
           }
}

const theme = extendTheme({ colors: newColorTheme });

export default theme;