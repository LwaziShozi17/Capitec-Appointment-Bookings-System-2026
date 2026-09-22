import { render, screen } from '@testing-library/react';
import { describe, it, expect, beforeEach } from 'vitest';
import { MemoryRouter, Routes, Route } from 'react-router-dom';
import { AuthProvider, AuthContext } from '../context/AuthContext';
import ProtectedRoute from '../components/ProtectedRoute';
import type { User } from '../types';

// The JWT lives in memory only, so an authenticated session cannot be faked
// by seeding localStorage before render. Pre-authenticated cases instead
// supply an AuthContext value directly, as they would after a real login.
function renderWithRoute(adminOnly = false, user: User | null = null) {
  const Wrapper = user
    ? ({ children }: { children: React.ReactNode }) => (
        <AuthContext.Provider value={{ user, login: async () => {}, register: async () => {}, logout: () => {}, isAdmin: user.role === 'ADMIN' }}>
          {children}
        </AuthContext.Provider>
      )
    : AuthProvider;

  return render(
    <MemoryRouter initialEntries={['/protected']}>
      <Wrapper>
        <Routes>
          <Route path="/login" element={<div>Login Page</div>} />
          <Route path="/" element={<div>Home</div>} />
          <Route
            path="/protected"
            element={
              <ProtectedRoute adminOnly={adminOnly}>
                <div>Protected Content</div>
              </ProtectedRoute>
            }
          />
        </Routes>
      </Wrapper>
    </MemoryRouter>
  );
}

describe('ProtectedRoute', () => {
  beforeEach(() => {
    localStorage.clear();
  });

  it('redirects to login when not authenticated', () => {
    renderWithRoute();
    expect(screen.getByText('Login Page')).toBeInTheDocument();
    expect(screen.queryByText('Protected Content')).not.toBeInTheDocument();
  });

  it('shows content when authenticated', () => {
    renderWithRoute(false, { email: 'u', name: 'U', role: 'USER', token: 't' });
    expect(screen.getByText('Protected Content')).toBeInTheDocument();
  });

  it('redirects non-admin from admin route', () => {
    renderWithRoute(true, { email: 'u', name: 'U', role: 'USER', token: 't' });
    expect(screen.getByText('Home')).toBeInTheDocument();
    expect(screen.queryByText('Protected Content')).not.toBeInTheDocument();
  });

  it('allows admin to access admin route', () => {
    renderWithRoute(true, { email: 'a', name: 'A', role: 'ADMIN', token: 't' });
    expect(screen.getByText('Protected Content')).toBeInTheDocument();
  });
});