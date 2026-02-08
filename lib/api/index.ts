import axios from "axios";
import { fetchAuthSession } from "aws-amplify/auth";

const api = axios.create({
  baseURL: process.env.EXPO_PUBLIC_API_ENDPOINT,
});

const getAuthHeader = async () => {
  const session = await fetchAuthSession();
  const token = session.tokens?.idToken?.toString();

  if (!token) {
    throw new Error("No auth token");
  }

  return {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  };
}

export async function getMe() {
  const header = await getAuthHeader();

  const res = await api.get("/me", { ...header });

  return res.data;
}
