import { useState } from "react";
import { View, Text, TextInput, Button } from "react-native";
import { useAuth } from "@/lib/auth/AuthProvider";
import { router } from "expo-router";

export default function SignInPage() {
  const { signIn } = useAuth();

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  async function handleSubmit() {
    await signIn(email, password);
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

      <Button title="Sign In" onPress={handleSubmit} />
      <Button title="Sign Up" onPress={ () => router.push("/(auth)/signup")} />
    </View>
  );
}
