import React from "react"
import { Image } from 'react-native'
import { Input, Stack, Box, Text, Button } from "native-base"
// import Doctor from '../resources/Doctor.png'
export const Example = () => {
     return (
          <Box bg="muted.700" rounded="3xl" width="sm" height="full" alignItems="center" pt={10} >
               <Stack
                    space={4}
                    w={{
                         base: "75%",
                         md: "30%",
                    }}

               >
                    <Text fontFamily="body" mb="5" fontWeight="bold" fontSize={32} color="white" >
                         Log-in
                    </Text>
                    <Input variant="underlined" borderBottomColor="#8fa7df" placeholder="Full Name" />
                    <Input variant="underlined" borderBottomColor="#8fa7df" placeholder="Password" />
                    <Button backgroundColor="#8fa7df" mt={5}>Log-in</Button>
               </Stack>
          </Box >
     )
}

export default () => {
     return (
          <Stack flex={1} px="3">
               <Image source={require('../resources/Doctor.png')} style={{ height: 200, width: 120, top: 30, marginLeft: 25, zIndex: 2 }}></Image>
               <Example />
          </Stack >
     )
}
