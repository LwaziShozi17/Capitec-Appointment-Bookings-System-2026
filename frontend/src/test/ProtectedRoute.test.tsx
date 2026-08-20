import { render, screen } from '@testing-library/react';
import { describe, it, expect, beforeEach } from 'vitest';
import { MemoryRouter, Routes, Route } from 'react-router-dom';
import { AuthProvider } from '../context/AuthContext';
import ProtectedRoute from '../components/ProtectedRoute';

function renderWithRoute(adminOnly = false) {
  return render(
    <MemoryRouter initialEntries={['/protected']}>
      <AuthProvider>
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
      </AuthProvider>
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
    localStorage.setItem('user_profile', JSON.stringify({ email: 'u', name: 'U', role: 'USER' }));
    renderWithRoute();
    expect(screen.getByText('Protected Content')).toBeInTheDocument();
  });

  it('redirects non-admin from admin route', () => {
    localStorage.setItem('user_profile', JSON.stringify({ email: 'u', name: 'U', role: 'USER' }));
    renderWithRoute(true);
    expect(screen.getByText('Home')).toBeInTheDocument();
    expect(screen.queryByText('Protected Content')).not.toBeInTheDocument();
  });

  it('allows admin to access admin route', () => {
    localStorage.setItem('user_profile', JSON.stringify({ email: 'a', name: 'A', role: 'ADMIN' }));
    renderWithRoute(true);
    expect(screen.getByText('Protected Content')).toBeInTheDocument();
  });
});