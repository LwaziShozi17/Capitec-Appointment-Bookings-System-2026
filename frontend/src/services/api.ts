import axios from 'axios';
import { tokenStore } from './tokenStore';

const api = axios.create({
  baseURL: '/api/v1',
});

function isTokenExpired(token: string): boolean {
  try {
    const payload = JSON.parse(atob(token.split('.')[1]));
    return typeof payload.exp === 'number' && payload.exp * 1000 < Date.now();
  } catch {
    return false;
  }
}

api.interceptors.request.use((config) => {
  const token = tokenStore.get();
  if (token) {
    if (isTokenExpired(token)) {
      tokenStore.set(null);
      localStorage.removeItem('user_profile');
      window.location.href = '/login?reason=expired';
      return Promise.reject(new Error('Session expired'));
    }
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (!error.response) {
      return Promise.reject(new Error('Network error — please check your connection'));
    }
    if (error.response.status === 401) {
      tokenStore.set(null);
      localStorage.removeItem('user_profile');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

export default api;