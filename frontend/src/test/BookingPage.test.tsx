import { render, screen, waitFor, fireEvent } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { MemoryRouter, Route, Routes } from 'react-router-dom';
import { AuthProvider } from '../context/AuthContext';
import BookingPage from '../pages/BookingPage';
import api from '../services/api';

vi.mock('../services/api');

const mockNavigate = vi.fn();
vi.mock('react-router-dom', async () => {
  const actual = await vi.importActual('react-router-dom');
  return { ...actual, useNavigate: () => mockNavigate };
});

const mockBranch = {
  id: 1, name: 'Capitec Sandton', code: 'CAP-GP-SDN',
  address: '163 5th St, Sandton', province: 'Gauteng',
  latitude: -26, longitude: 28, operatingHours: [],
};

const mockServices = [
  { id: 1, name: 'Card Collection', description: 'Collect your card', durationMinutes: 20, requiredDocuments: 'SA ID;Proof of Address' },
  { id: 2, name: 'New Account', description: 'Open an account', durationMinutes: 45, requiredDocuments: 'SA ID;Proof of Address;Proof of Income' },
];

const mockSlots = [
  { id: 1, branchId: 1, date: '2099-12-01', startTime: '08:00', endTime: '08:30', status: 'AVAILABLE' },
  { id: 2, branchId: 1, date: '2099-12-01', startTime: '08:30', endTime: '09:00', status: 'BOOKED' },
  { id: 3, branchId: 1, date: '2099-12-01', startTime: '09:00', endTime: '09:30', status: 'AVAILABLE' },
];

function renderBooking() {
  localStorage.setItem('user_profile', JSON.stringify({ email: 'user@test.com', name: 'User', role: 'USER' }));
  return render(
    <MemoryRouter initialEntries={['/book/1']}>
      <AuthProvider>
        <Routes>
          <Route path="/book/:branchId" element={<BookingPage />} />
          <Route path="/appointments" element={<div>Appointments Page</div>} />
        </Routes>
      </AuthProvider>
    </MemoryRouter>
  );
}

describe('BookingPage', () => {
  beforeEach(() => {
    localStorage.clear();
    vi.clearAllMocks();
    vi.mocked(api.get).mockImplementation((url: string) => {
      if (url === '/branches/1') return Promise.resolve({ data: mockBranch });
      if (url === '/services') return Promise.resolve({ data: mockServices });
      if (url === '/slots') return Promise.resolve({ data: mockSlots });
      return Promise.resolve({ data: [] });
    });
  });

  it('shows loading state initially', () => {
    vi.mocked(api.get).mockImplementation(() => new Promise(() => {}));
    localStorage.setItem('user_profile', JSON.stringify({ email: 'u', name: 'U', role: 'USER' }));
    render(
      <MemoryRouter initialEntries={['/book/1']}>
        <AuthProvider>
          <Routes>
            <Route path="/book/:branchId" element={<BookingPage />} />
          </Routes>
        </AuthProvider>
      </MemoryRouter>
    );
    // Skeleton shown; page content not yet loaded
    expect(screen.queryByText('Book Appointment')).not.toBeInTheDocument();
  });

  it('renders branch info and services after loading', async () => {
    renderBooking();
    await waitFor(() => {
      expect(screen.getByText('Book Appointment')).toBeInTheDocument();
    });
    expect(screen.getByText(/Capitec Sandton/)).toBeInTheDocument();
    expect(screen.getByText('Gauteng')).toBeInTheDocument();
    expect(screen.getByText('Card Collection')).toBeInTheDocument();
    expect(screen.getByText('New Account')).toBeInTheDocument();
  });

  it('shows service duration', async () => {
    renderBooking();
    await waitFor(() => {
      expect(screen.getByText('Card Collection')).toBeInTheDocument();
    });
    expect(screen.getByText('20 min')).toBeInTheDocument();
    expect(screen.getByText('45 min')).toBeInTheDocument();
  });

  it('shows required documents when service selected', async () => {
    renderBooking();
    await waitFor(() => {
      expect(screen.getByText('Card Collection')).toBeInTheDocument();
    });

    await userEvent.click(screen.getByText('Card Collection'));

    expect(screen.getByText(/Required Documents/)).toBeInTheDocument();
    expect(screen.getByText('SA ID')).toBeInTheDocument();
    expect(screen.getByText('Proof of Address')).toBeInTheDocument();
  });

  it('shows time slots when date selected', async () => {
    renderBooking();
    await waitFor(() => {
      expect(screen.getByText('Card Collection')).toBeInTheDocument();
    });

    const dateInput = document.querySelector('input[type="date"]') as HTMLInputElement;
    fireEvent.change(dateInput, { target: { value: '2099-12-01' } });

    await waitFor(() => {
      expect(screen.getByText('08:00')).toBeInTheDocument();
    });
    expect(screen.getByText('08:30')).toBeInTheDocument();
    expect(screen.getByText('09:00')).toBeInTheDocument();
  });

  it('disables booked slots', async () => {
    renderBooking();
    await waitFor(() => {
      expect(screen.getByText('Card Collection')).toBeInTheDocument();
    });

    const dateInput = document.querySelector('input[type="date"]') as HTMLInputElement;
    fireEvent.change(dateInput, { target: { value: '2099-12-01' } });

    await waitFor(() => {
      expect(screen.getByText('08:30')).toBeInTheDocument();
    });

    const bookedSlot = screen.getByText('08:30').closest('button')!;
    expect(bookedSlot).toBeDisabled();
  });

  it('submits booking and navigates on success', async () => {
    vi.mocked(api.post).mockResolvedValueOnce({ data: {} });
    renderBooking();

    await waitFor(() => {
      expect(screen.getByText('Card Collection')).toBeInTheDocument();
    });

    await userEvent.click(screen.getByText('Card Collection'));

    const dateInput = document.querySelector('input[type="date"]') as HTMLInputElement;
    fireEvent.change(dateInput, { target: { value: '2099-12-01' } });

    await waitFor(() => {
      expect(screen.getByText('08:00')).toBeInTheDocument();
    });

    await userEvent.click(screen.getByText('08:00'));

    const nameInput = screen.getAllByRole('textbox')[0];
    await userEvent.type(nameInput, 'Test User');

    await userEvent.click(screen.getByRole('button', { name: /confirm booking/i }));

    await waitFor(() => {
      expect(mockNavigate).toHaveBeenCalled();
    });
  });

  it('shows error on booking failure', async () => {
    vi.mocked(api.post).mockRejectedValueOnce({
      response: { data: { message: 'Slot no longer available' } },
    });
    renderBooking();

    await waitFor(() => {
      expect(screen.getByText('Card Collection')).toBeInTheDocument();
    });

    await userEvent.click(screen.getByText('Card Collection'));

    const dateInput = document.querySelector('input[type="date"]') as HTMLInputElement;
    fireEvent.change(dateInput, { target: { value: '2099-12-01' } });

    await waitFor(() => {
      expect(screen.getByText('08:00')).toBeInTheDocument();
    });

    await userEvent.click(screen.getByText('08:00'));

    const nameInput = screen.getAllByRole('textbox')[0];
    await userEvent.type(nameInput, 'Test User');

    await userEvent.click(screen.getByRole('button', { name: /confirm booking/i }));

    await waitFor(() => {
      expect(screen.getByText('Slot no longer available')).toBeInTheDocument();
    });
  });

  it('shows error details when backend returns validation details map', async () => {
    vi.mocked(api.post).mockRejectedValueOnce({
      response: { data: { details: { customerName: 'Customer name is required' } } },
    });
    renderBooking();

    await waitFor(() => {
      expect(screen.getByText('Card Collection')).toBeInTheDocument();
    });

    await userEvent.click(screen.getByText('Card Collection'));

    const dateInput = document.querySelector('input[type="date"]') as HTMLInputElement;
    fireEvent.change(dateInput, { target: { value: '2099-12-01' } });

    await waitFor(() => {
      expect(screen.getByText('08:00')).toBeInTheDocument();
    });

    await userEvent.click(screen.getByText('08:00'));

    const nameInput = screen.getAllByRole('textbox')[0];
    await userEvent.type(nameInput, 'Test User');

    await userEvent.click(screen.getByRole('button', { name: /confirm booking/i }));

    await waitFor(() => {
      expect(screen.getByText('Customer name is required')).toBeInTheDocument();
    });
  });

  it('shows no slots message when date has no availability', async () => {
    vi.mocked(api.get).mockImplementation((url: string) => {
      if (url === '/branches/1') return Promise.resolve({ data: mockBranch });
      if (url === '/services') return Promise.resolve({ data: mockServices });
      if (url === '/slots') return Promise.resolve({ data: [] });
      return Promise.resolve({ data: [] });
    });

    renderBooking();
    await waitFor(() => {
      expect(screen.getByText('Card Collection')).toBeInTheDocument();
    });

    const dateInput = document.querySelector('input[type="date"]') as HTMLInputElement;
    fireEvent.change(dateInput, { target: { value: '2099-12-01' } });

    await waitFor(() => {
      expect(screen.getByText(/No slots for this date/)).toBeInTheDocument();
    });
  });
});
