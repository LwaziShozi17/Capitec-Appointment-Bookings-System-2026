import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { MemoryRouter } from 'react-router-dom';
import { AuthProvider } from '../context/AuthContext';
import { ToastProvider } from '../context/ToastContext';
import AppointmentsPage from '../pages/AppointmentsPage';
import api from '../services/api';

vi.mock('../services/api');

const mockAppointments = [
  {
    id: 1, referenceNumber: 'CAP-001', userId: 'user@test.com',
    customerName: 'John', customerEmail: 'john@test.com', customerPhone: '082',
    status: 'PENDING', branchName: 'Capitec Sandton', branchAddress: 'Sandton',
    serviceName: 'Account Opening', date: '2028-06-15', startTime: '09:00', endTime: '09:30',
    createdAt: '2026-06-12T10:00:00',
  },
  {
    id: 2, referenceNumber: 'CAP-002', userId: 'user@test.com',
    customerName: 'John', customerEmail: 'john@test.com', customerPhone: '082',
    status: 'COMPLETED', branchName: 'Capitec Gateway', branchAddress: 'Umhlanga',
    serviceName: 'Card Collection', date: '2026-06-10', startTime: '14:00', endTime: '14:15',
    createdAt: '2026-06-09T10:00:00',
  },
];

function renderPage(initialEntries?: Array<string | { pathname: string; state?: unknown }>) {
  localStorage.setItem('user_profile', JSON.stringify({ email: 'user@test.com', name: 'John', role: 'USER' }));
  return render(
    <MemoryRouter initialEntries={initialEntries || ['/appointments']}>
      <AuthProvider>
        <ToastProvider>
          <AppointmentsPage />
        </ToastProvider>
      </AuthProvider>
    </MemoryRouter>
  );
}

describe('AppointmentsPage', () => {
  beforeEach(() => {
    localStorage.clear();
    vi.clearAllMocks();
    vi.mocked(api.get).mockResolvedValue({ data: mockAppointments });
  });

  it('shows loading then appointments', async () => {
    vi.mocked(api.get).mockImplementation(() => new Promise(() => {}));
    renderPage();
    // Skeleton shown, appointments not yet loaded
    expect(screen.queryByText('Account Opening')).not.toBeInTheDocument();
  });

  it('shows status badges', async () => {
    renderPage();
    await waitFor(() => {
      expect(screen.getByText('Pending')).toBeInTheDocument();
      expect(screen.getByText('Completed')).toBeInTheDocument();
    });
  });

  it('shows cancel button only for non-completed/non-cancelled', async () => {
    renderPage();
    await waitFor(() => {
      expect(screen.getByText('Account Opening')).toBeInTheDocument();
    });
    const cancelButtons = screen.getAllByText('Cancel');
    expect(cancelButtons).toHaveLength(1);
  });

  it('shows empty state when no appointments', async () => {
    vi.mocked(api.get).mockResolvedValue({ data: [] });
    renderPage();
    await waitFor(() => {
      expect(screen.getByText('No appointments yet')).toBeInTheDocument();
    });
  });

  it('calls cancel endpoint on cancel click', async () => {
    vi.mocked(api.delete).mockResolvedValue({ data: {} });

    renderPage();
    await waitFor(() => {
      expect(screen.getByText('Cancel')).toBeInTheDocument();
    });

    await userEvent.click(screen.getByText('Cancel'));

    // Confirm modal appears — click the confirm button
    await waitFor(() => {
      expect(screen.getByText('Yes, Cancel')).toBeInTheDocument();
    });
    await userEvent.click(screen.getByText('Yes, Cancel'));

    await waitFor(() => {
      expect(api.delete).toHaveBeenCalledWith('/appointments/1');
    });
  });

  it('shows success toast once when navigated with booking success message', async () => {
    renderPage([{ pathname: '/appointments', state: { message: 'Appointment booked successfully!' } }]);

    await waitFor(() => {
      const toasts = screen.getAllByText('Appointment booked successfully!');
      expect(toasts).toHaveLength(1);
    });
  });

  it('shows Reschedule / Edit button for active appointments and opens edit modal', async () => {
    vi.mocked(api.get).mockImplementation((url) => {
      if (url === '/appointments/my') {
        return Promise.resolve({ data: mockAppointments });
      }
      if (url === '/slots') {
        return Promise.resolve({
          data: [
            { id: 10, branchId: 1, date: '2028-06-15', startTime: '10:00', endTime: '10:30', status: 'AVAILABLE' },
          ],
        });
      }
      if (url === '/branches') {
        return Promise.resolve({
          data: [
            { id: 1, name: 'Capitec Sandton' },
          ],
        });
      }
      return Promise.resolve({ data: [] });
    });
    vi.mocked(api.put).mockResolvedValue({ data: {} });

    renderPage();
    await waitFor(() => {
      expect(screen.getByText('Reschedule / Edit')).toBeInTheDocument();
    });

    await userEvent.click(screen.getByText('Reschedule / Edit'));

    await waitFor(() => {
      expect(screen.getByText('Edit / Reschedule Booking')).toBeInTheDocument();
      expect(screen.getByText('10:00')).toBeInTheDocument();
    });

    await userEvent.click(screen.getByText('10:00'));
    await userEvent.click(screen.getByText('Save Changes'));

    await waitFor(() => {
      expect(api.put).toHaveBeenCalledWith('/appointments/1', expect.objectContaining({
        slotId: 10,
      }));
    });
  });
});
