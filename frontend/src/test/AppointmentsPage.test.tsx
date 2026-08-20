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
    serviceName: 'Account Opening', date: '2026-06-15', startTime: '09:00', endTime: '09:30',
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

function renderPage() {
  localStorage.setItem('user_profile', JSON.stringify({ email: 'user@test.com', name: 'John', role: 'USER' }));
  return render(
    <MemoryRouter>
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
});
