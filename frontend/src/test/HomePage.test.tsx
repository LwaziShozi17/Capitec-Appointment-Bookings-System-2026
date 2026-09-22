import { render, screen } from '@testing-library/react';
import { describe, it, expect, beforeEach } from 'vitest';
import { MemoryRouter } from 'react-router-dom';
import { AuthProvider, AuthContext } from '../context/AuthContext';
import HomePage from '../pages/HomePage';

function renderHome(loggedIn = false) {
  const Wrapper = loggedIn
    ? ({ children }: { children: React.ReactNode }) => (
        <AuthContext.Provider
          value={{
            user: { email: 'u', name: 'U', role: 'USER', token: 't' },
            login: async () => {},
            register: async () => {},
            logout: () => {},
            isAdmin: false,
          }}
        >
          {children}
        </AuthContext.Provider>
      )
    : AuthProvider;

  return render(
    <MemoryRouter>
      <Wrapper>
        <HomePage />
      </Wrapper>
    </MemoryRouter>
  );
}

describe('HomePage', () => {
  beforeEach(() => {
    localStorage.clear();
  });

  it('shows sign in and create account buttons when not logged in', () => {
    renderHome();
    expect(screen.getByText('Sign In')).toBeInTheDocument();
    expect(screen.getByText('Create Account')).toBeInTheDocument();
  });

  it('shows book and my appointments buttons when logged in', () => {
    renderHome(true);
    expect(screen.getByText('Book Appointment')).toBeInTheDocument();
    expect(screen.getByText('My Appointments')).toBeInTheDocument();
  });

  it('shows the 3-step flow', () => {
    renderHome();
    expect(screen.getByText('Choose a Branch')).toBeInTheDocument();
    expect(screen.getByText('Pick a Time')).toBeInTheDocument();
    expect(screen.getByText('Get Confirmed')).toBeInTheDocument();
  });
});