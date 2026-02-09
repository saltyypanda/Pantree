import { useState } from "react";
import { View, Text, TextInput, Button } from "react-native";
import { useAuth } from "@/lib/auth/AuthProvider";

export default function SignUpPage() {
  const { signUp } = useAuth();

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  async function handleSubmit() {
    await signUp(email, password);
  }

  return (
    <View style={{ gap: 12, padding: 24 }}>
      <Text>Email</Text>
      <TextInput
        value={email}
        onChangeText={setEmail}
        autoCapitalize="none"
        keyboardType="email-address"
        style={{ borderWidth: 1, padding: 8 }}
      />

      <Text>Password</Text>
      <TextInput
        value={password}
        onChangeText={setPassword}
        secureTextEntry
        style={{ borderWidth: 1, padding: 8 }}
      />

      <Button title="Sign Up" onPress={handleSubmit} />
    </View>
  );
}
