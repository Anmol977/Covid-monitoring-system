import { extendTheme, NativeBaseProvider } from 'native-base';

const config = {
     useSystemColorMode: false,
     initialColorMode: 'dark',
};

const colorModeValues = {
     dark: "#202023",
     light: "#f0e7db"
}

const font = {
     fontConfig: {
          Roboto: {
               100: {
                    normal: 'Roboto-Light',
                    italic: 'Roboto-LightItalic',
               },
               200: {
                    normal: 'Roboto-Light',
                    italic: 'Roboto-LightItalic',
               },
               300: {
                    normal: 'Roboto-Light',
                    italic: 'Roboto-LightItalic',
               },
               400: {
                    normal: 'Roboto-Regular',
                    italic: 'Roboto-Italic',
               },
               500: {
                    normal: 'Roboto-Medium',
               },
               600: {
                    normal: 'Roboto-Medium',
                    italic: 'Roboto-MediumItalic',
               },

          },
     },

     fonts: {
          heading: 'Roboto',
          body: 'Roboto',
          mono: 'Roboto',
     },
}

const theme = extendTheme({ config, colorModeValues, font });

export default theme;