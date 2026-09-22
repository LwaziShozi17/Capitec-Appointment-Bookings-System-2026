import { createContext, useContext, useState, useEffect, type ReactNode } from 'react';
import type { User, AuthResponse } from '../types';
import api from '../services/api';
import { tokenStore } from '../services/tokenStore';

interface AuthContextType {
  user: User | null;
  login: (email: string, password: string) => Promise<void>;
  register: (data: RegisterData) => Promise<void>;
  logout: () => void;
  isAdmin: boolean;
}

interface RegisterData {
  firstName: string;
  lastName: string;
  email: string;
  password: string;
  phoneNumber?: string;
}

// Only non-sensitive fields are persisted to localStorage
interface StoredProfile {
  email: string;
  name: string;
  role: string;
}

const PROFILE_KEY = 'user_profile';

// eslint-disable-next-line react-refresh/only-export-components
export const AuthContext = createContext<AuthContextType | null>(null);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);

  // The JWT is kept in memory only and is never persisted, so it cannot
  // survive a page reload. A stored profile without a matching token would
  // make the UI look logged in while every API call (including booking and
  // "My Appointments") is actually sent unauthenticated, silently breaking
  // both flows. Clear any stale profile on load and require a real re-login.
  useEffect(() => {
    localStorage.removeItem(PROFILE_KEY);
  }, []);

  useEffect(() => {
    if (user && user.token) {
      tokenStore.set(user.token);
      const profile: StoredProfile = { email: user.email, name: user.name, role: user.role };
      localStorage.setItem(PROFILE_KEY, JSON.stringify(profile));
    } else if (!user) {
      tokenStore.set(null);
      localStorage.removeItem(PROFILE_KEY);
    }
  }, [user]);

  const login = async (email: string, password: string) => {
    const { data } = await api.post<AuthResponse>('/auth/login', { email, password });
    setUser({ email: data.email, name: data.name, role: data.role, token: data.token });
  };

  const register = async (registerData: RegisterData) => {
    const { data } = await api.post<AuthResponse>('/auth/register', registerData);
    setUser({ email: data.email, name: data.name, role: data.role, token: data.token });
  };

  const logout = () => {
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, login, register, logout, isAdmin: user?.role === 'ADMIN' }}>
      {children}
    </AuthContext.Provider>
  );
}

// eslint-disable-next-line react-refresh/only-export-components
export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) throw new Error('useAuth must be used within AuthProvider');
  return context;
}