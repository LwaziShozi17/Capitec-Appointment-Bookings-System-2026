import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { MemoryRouter } from 'react-router-dom';
import { AuthProvider } from '../context/AuthContext';
import Layout from '../components/Layout';

const mockNavigate = vi.fn();
vi.mock('react-router-dom', async () => {
  const actual = await vi.importActual('react-router-dom');
  return { ...actual, useNavigate: () => mockNavigate };
});

function renderLayout(userState?: object) {
  if (userState) {
    localStorage.setItem('user_profile', JSON.stringify(userState));
  }
  return render(
    <MemoryRouter>
      <AuthProvider>
        <Layout />
      </AuthProvider>
    </MemoryRouter>
  );
}

describe('Layout', () => {
  beforeEach(() => {
    localStorage.clear();
    vi.clearAllMocks();
  });

  it('shows sign in link when not logged in', () => {
    renderLayout();
    expect(screen.getByText('Sign in')).toBeInTheDocument();
    expect(screen.queryByText('Branches')).not.toBeInTheDocument();
    expect(screen.queryByText('My Appointments')).not.toBeInTheDocument();
  });

  it('shows navigation links when logged in', () => {
    renderLayout({ email: 'u@t.com', name: 'User', role: 'USER', token: 't' });
    expect(screen.getByText('Branches')).toBeInTheDocument();
    expect(screen.getByText('My Appointments')).toBeInTheDocument();
    expect(screen.queryByText('Sign in')).not.toBeInTheDocument();
  });

  it('shows user name when logged in', () => {
    renderLayout({ email: 'u@t.com', name: 'Test User', role: 'USER', token: 't' });
    expect(screen.getByText('Test User')).toBeInTheDocument();
  });

  it('shows Admin link only for admin users', () => {
    renderLayout({ email: 'a@t.com', name: 'Admin User', role: 'ADMIN', token: 't' });
    expect(screen.getByRole('link', { name: 'Admin' })).toBeInTheDocument();
  });

  it('does not show Admin link for regular users', () => {
    renderLayout({ email: 'u@t.com', name: 'User', role: 'USER', token: 't' });
    expect(screen.queryByText('Admin')).not.toBeInTheDocument();
  });

  it('logs out and navigates on sign out click', async () => {
    renderLayout({ email: 'u@t.com', name: 'User', role: 'USER', token: 't' });

    await userEvent.click(screen.getByText('Sign out'));

    expect(mockNavigate).toHaveBeenCalledWith('/login');
    expect(localStorage.getItem('user_profile')).toBeNull();
  });

  it('shows the Capitec Booking brand', () => {
    renderLayout();
    expect(screen.getByRole('link', { name: /Capitec/i })).toBeInTheDocument();
  });
});
