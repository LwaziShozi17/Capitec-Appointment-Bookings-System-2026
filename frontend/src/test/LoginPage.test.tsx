import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { MemoryRouter } from 'react-router-dom';
import { AuthProvider } from '../context/AuthContext';
import LoginPage from '../pages/LoginPage';
import api from '../services/api';

vi.mock('../services/api');

const mockNavigate = vi.fn();
vi.mock('react-router-dom', async () => {
  const actual = await vi.importActual('react-router-dom');
  return { ...actual, useNavigate: () => mockNavigate };
});

function renderLogin() {
  return render(
    <MemoryRouter>
      <AuthProvider>
        <LoginPage />
      </AuthProvider>
    </MemoryRouter>
  );
}

describe('LoginPage', () => {
  beforeEach(() => {
    localStorage.clear();
    vi.clearAllMocks();
  });

  it('renders login form', () => {
    renderLogin();
    expect(screen.getByText('Welcome back')).toBeInTheDocument();
    expect(screen.getByPlaceholderText('you@example.com')).toBeInTheDocument();
    expect(screen.getByPlaceholderText('Enter your password')).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /sign in/i })).toBeInTheDocument();
  });

  it('shows link to register', () => {
    renderLogin();
    expect(screen.getByText('Register')).toBeInTheDocument();
  });

  it('submits login and navigates on success', async () => {
    vi.mocked(api.post).mockResolvedValueOnce({
      data: { token: 'jwt', email: 'user@test.com', name: 'User', role: 'USER' },
    });

    renderLogin();
    await userEvent.type(screen.getByPlaceholderText('you@example.com'), 'user@test.com');
    await userEvent.type(screen.getByPlaceholderText('Enter your password'), 'password');
    await userEvent.click(screen.getByRole('button', { name: /sign in/i }));

    await waitFor(() => {
      expect(mockNavigate).toHaveBeenCalledWith('/');
    });
  });

  it('shows error on login failure', async () => {
    vi.mocked(api.post).mockRejectedValueOnce({
      response: { data: { message: 'Invalid email or password' } },
    });

    renderLogin();
    await userEvent.type(screen.getByPlaceholderText('you@example.com'), 'bad@test.com');
    await userEvent.type(screen.getByPlaceholderText('Enter your password'), 'wrong');
    await userEvent.click(screen.getByRole('button', { name: /sign in/i }));

    await waitFor(() => {
      expect(screen.getByText('Invalid email or password')).toBeInTheDocument();
    });
  });
});