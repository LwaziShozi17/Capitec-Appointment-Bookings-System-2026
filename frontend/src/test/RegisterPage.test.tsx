import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { MemoryRouter } from 'react-router-dom';
import { AuthProvider } from '../context/AuthContext';
import RegisterPage from '../pages/RegisterPage';
import api from '../services/api';

vi.mock('../services/api');

const mockNavigate = vi.fn();
vi.mock('react-router-dom', async () => {
  const actual = await vi.importActual('react-router-dom');
  return { ...actual, useNavigate: () => mockNavigate };
});

function renderRegister() {
  return render(
    <MemoryRouter>
      <AuthProvider>
        <RegisterPage />
      </AuthProvider>
    </MemoryRouter>
  );
}

describe('RegisterPage', () => {
  beforeEach(() => {
    localStorage.clear();
    vi.clearAllMocks();
  });

  it('renders all form fields', () => {
    renderRegister();
    expect(screen.getByRole('heading', { name: 'Create account' })).toBeInTheDocument();
    expect(screen.getByText('First name')).toBeInTheDocument();
    expect(screen.getByText('Last name')).toBeInTheDocument();
    expect(screen.getByText('Email')).toBeInTheDocument();
    expect(screen.getByText('Password')).toBeInTheDocument();
    expect(screen.getByText('Phone (optional)')).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /create account/i })).toBeInTheDocument();
  });

  it('shows link to login page', () => {
    renderRegister();
    expect(screen.getByText('Sign in')).toBeInTheDocument();
    expect(screen.getByText('Already have an account?')).toBeInTheDocument();
  });

  it('submits registration and navigates on success', async () => {
    vi.mocked(api.post).mockResolvedValueOnce({
      data: { token: 'jwt', email: 'new@test.com', name: 'New User', role: 'USER' },
    });

    renderRegister();
    const textInputs = screen.getAllByRole('textbox');
    const passwordInput = document.querySelector('input[type="password"]') as HTMLElement;

    await userEvent.type(textInputs[0], 'New');
    await userEvent.type(textInputs[1], 'User');
    await userEvent.type(textInputs[2], 'new@test.com');
    await userEvent.type(passwordInput, 'Password1!');

    await userEvent.click(screen.getByRole('button', { name: /create account/i }));

    await waitFor(() => {
      expect(mockNavigate).toHaveBeenCalledWith('/');
    });
  });

  it('shows error on registration failure', async () => {
    vi.mocked(api.post).mockRejectedValueOnce({
      response: { data: { message: 'Email already registered' } },
    });

    renderRegister();
    const textInputs = screen.getAllByRole('textbox');
    const passwordInput = document.querySelector('input[type="password"]') as HTMLElement;

    await userEvent.type(textInputs[0], 'Existing');
    await userEvent.type(textInputs[1], 'User');
    await userEvent.type(textInputs[2], 'existing@test.com');
    await userEvent.type(passwordInput, 'Password1!');

    await userEvent.click(screen.getByRole('button', { name: /create account/i }));

    await waitFor(() => {
      expect(screen.getByText('Email already registered')).toBeInTheDocument();
    });
  });

  it('shows client-side error for weak password without API call', async () => {
    renderRegister();
    const textInputs = screen.getAllByRole('textbox');
    const passwordInput = document.querySelector('input[type="password"]') as HTMLElement;

    await userEvent.type(textInputs[0], 'Test');
    await userEvent.type(textInputs[1], 'User');
    await userEvent.type(textInputs[2], 'test@t.com');
    await userEvent.type(passwordInput, 'password'); // weak — no uppercase, digit, or special char

    await userEvent.click(screen.getByRole('button', { name: /create account/i }));

    expect(screen.getByRole('alert')).toBeInTheDocument();
    expect(api.post).not.toHaveBeenCalled();
  });

  it('shows client-side error for missing first name', async () => {
    renderRegister();
    await userEvent.click(screen.getByRole('button', { name: /create account/i }));

    expect(screen.getByRole('alert')).toHaveTextContent('First name is required');
    expect(api.post).not.toHaveBeenCalled();
  });

  it('shows loading state during submission', async () => {
    let resolvePost: (value: unknown) => void;
    vi.mocked(api.post).mockImplementationOnce(() => new Promise(r => { resolvePost = r; }));

    renderRegister();
    const textInputs = screen.getAllByRole('textbox');
    const passwordInput = document.querySelector('input[type="password"]') as HTMLElement;

    await userEvent.type(textInputs[0], 'Test');
    await userEvent.type(textInputs[1], 'User');
    await userEvent.type(textInputs[2], 'test@t.com');
    await userEvent.type(passwordInput, 'Password1!');
    await userEvent.click(screen.getByRole('button', { name: /create account/i }));

    expect(screen.getByText('Creating account...')).toBeInTheDocument();

    resolvePost!({ data: { token: 't', email: 'e', name: 'N', role: 'USER' } });
    await waitFor(() => {
      expect(screen.queryByText('Creating account...')).not.toBeInTheDocument();
    });
  });
});
