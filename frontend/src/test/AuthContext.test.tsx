import { render, screen, waitFor, act } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { AuthProvider, useAuth } from '../context/AuthContext';
import api from '../services/api';

vi.mock('../services/api');

function TestComponent() {
  const { user, login, register, logout, isAdmin } = useAuth();
  return (
    <div>
      <span data-testid="user">{user ? user.name : 'none'}</span>
      <span data-testid="admin">{isAdmin ? 'yes' : 'no'}</span>
      <button onClick={() => login('test@test.com', 'pass')}>Login</button>
      <button onClick={() => register({ firstName: 'A', lastName: 'B', email: 'a@b.com', password: 'Pass@123' })}>Register</button>
      <button onClick={logout}>Logout</button>
    </div>
  );
}

describe('AuthContext', () => {
  beforeEach(() => {
    localStorage.clear();
    vi.clearAllMocks();
  });

  it('starts with no user', () => {
    render(<AuthProvider><TestComponent /></AuthProvider>);
    expect(screen.getByTestId('user')).toHaveTextContent('none');
    expect(screen.getByTestId('admin')).toHaveTextContent('no');
  });

  it('logs in and stores user', async () => {
    vi.mocked(api.post).mockResolvedValueOnce({
      data: { token: 'jwt', email: 'test@test.com', name: 'Test User', role: 'USER' },
    });

    render(<AuthProvider><TestComponent /></AuthProvider>);
    await act(async () => {
      await userEvent.click(screen.getByText('Login'));
    });

    await waitFor(() => {
      expect(screen.getByTestId('user')).toHaveTextContent('Test User');
    });
    // Only non-sensitive profile is persisted; token is NOT in localStorage
    const profile = JSON.parse(localStorage.getItem('user_profile') || 'null');
    expect(profile).toBeTruthy();
    expect(profile.token).toBeUndefined();
  });

  it('registers and stores user', async () => {
    vi.mocked(api.post).mockResolvedValueOnce({
      data: { token: 'jwt', email: 'a@b.com', name: 'A B', role: 'USER' },
    });

    render(<AuthProvider><TestComponent /></AuthProvider>);
    await act(async () => {
      await userEvent.click(screen.getByText('Register'));
    });

    await waitFor(() => {
      expect(screen.getByTestId('user')).toHaveTextContent('A B');
    });
  });

  it('logs out and clears storage', async () => {
    localStorage.setItem('user_profile', JSON.stringify({ email: 'x', name: 'X', role: 'USER' }));

    render(<AuthProvider><TestComponent /></AuthProvider>);
    expect(screen.getByTestId('user')).toHaveTextContent('X');

    await act(async () => {
      await userEvent.click(screen.getByText('Logout'));
    });

    expect(screen.getByTestId('user')).toHaveTextContent('none');
    expect(localStorage.getItem('user_profile')).toBeNull();
  });

  it('identifies admin user', () => {
    localStorage.setItem('user_profile', JSON.stringify({ email: 'a', name: 'Admin', role: 'ADMIN' }));

    render(<AuthProvider><TestComponent /></AuthProvider>);
    expect(screen.getByTestId('admin')).toHaveTextContent('yes');
  });

  it('throws if useAuth used outside provider', () => {
    expect(() => render(<TestComponent />)).toThrow('useAuth must be used within AuthProvider');
  });
});