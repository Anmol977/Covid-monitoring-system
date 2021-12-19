import React from "react"
import { Image } from 'react-native'
import { Input, Stack, Center, Heading } from "native-base"
// import Doctor from '../resources/Doctor.png'
export const Example = () => {
     return (
          <Stack
               space={4}
               w={{
                    base: "75%",
                    md: "25%",
               }}
          >
               <Center>
                    <Heading textAlign="center" mb="10">
                         To continue, please fill your details
                    </Heading>
               </Center>
               <Input variant="outline" placeholder="Full Name" />
               <Input variant="outline" placeholder="Password" />
          </Stack>
     )
}

export default () => {
     return (
          // <NativeBaseProvider>
          <Center flex={1} px="3">
               <Image source={require('../resources/Doctor.png')} style={{ height: 200, width: 70, margin: 20 }}></Image>
               <Example />
          </Center>
          //  </NativeBaseProvider> 
     )
}
