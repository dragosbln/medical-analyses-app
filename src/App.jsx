import React from 'react';
import { View, Text } from 'react-native';

const App = () => {
  return (
    <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
      <Text style={{ fontSize: 30, fontWeight: 'bold' }}>
        Welcome to our app!
      </Text>
      <Text>Not much to do here, yet :D</Text>
    </View>
  );
};

export default App;
