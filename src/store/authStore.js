import { create } from "zustand";
import { authenticateUser } from "../api/userService";

export const useAuthStore = create((set) => ({
  user: null,
  isAuthenticated: false,
  isLoading: false,
  error: null,

  login: async (email, password) => {
    set({ isLoading: true, error: null });
    try {
      const user = await authenticateUser(email, password);
      if (user) {
        set({ user, isAuthenticated: true, isLoading: false });
        return true;
      } else {
        set({ error: "Email ou mot de passe incorrect", isLoading: false });
        return false;
      }
    } catch (error) {
      set({ error: "Erreur de connexion", isLoading: false });
      return false;
    }
  },

  logout: () => {
    set({ user: null, isAuthenticated: false, error: null });
  },

  clearError: () => {
    set({ error: null });
  },
}));
