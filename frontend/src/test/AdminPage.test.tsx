import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { MemoryRouter } from 'react-router-dom';
import { AuthProvider } from '../context/AuthContext';
import { ToastProvider } from '../context/ToastContext';
import AdminPage from '../pages/AdminPage';
import api from '../services/api';

vi.mock('../services/api');

const mockAppointments = [
  {
    id: 1, referenceNumber: 'REF001', userId: 'user1',
    customerName: 'John Doe', customerEmail: 'john@test.com', customerPhone: '082123',
    status: 'PENDING' as const, branchName: 'Capitec Sandton', branchAddress: '163 5th St',
    serviceName: 'Card Collection', date: '2099-12-01', startTime: '08:00', endTime: '08:30', createdAt: '2099-11-01',
  },
  {
    id: 2, referenceNumber: 'REF002', userId: 'user2',
    customerName: 'Jane Smith', customerEmail: 'jane@test.com', customerPhone: '083456',
    status: 'CONFIRMED' as const, branchName: 'Capitec Canal Walk', branchAddress: 'Century City',
    serviceName: 'New Account', date: '2099-12-02', startTime: '09:00', endTime: '09:45', createdAt: '2099-11-02',
  },
  {
    id: 3, referenceNumber: 'REF003', userId: 'user3',
    customerName: 'Bob Wilson', customerEmail: 'bob@test.com', customerPhone: '084789',
    status: 'COMPLETED' as const, branchName: 'Capitec Gateway', branchAddress: 'Umhlanga',
    serviceName: 'Loan Application', date: '2099-11-01', startTime: '10:00', endTime: '11:00', createdAt: '2099-10-15',
  },
];

function renderAdmin() {
  localStorage.setItem('user_profile', JSON.stringify({ email: 'admin@test.com', name: 'Admin', role: 'ADMIN' }));
  return render(
    <MemoryRouter>
      <AuthProvider>
        <ToastProvider>
          <AdminPage />
        </ToastProvider>
      </AuthProvider>
    </MemoryRouter>
  );
}

describe('AdminPage', () => {
  beforeEach(() => {
    localStorage.clear();
    vi.clearAllMocks();
    vi.mocked(api.get).mockResolvedValue({ data: mockAppointments });
  });

  it('shows loading state', () => {
    vi.mocked(api.get).mockImplementation(() => new Promise(() => {}));
    renderAdmin();
    // Skeleton is shown; appointments not yet loaded
    expect(screen.queryByText('John Doe')).not.toBeInTheDocument();
  });

  it('renders admin dashboard title', async () => {
    renderAdmin();
    await waitFor(() => {
      expect(screen.getByText('Admin Dashboard')).toBeInTheDocument();
    });
    expect(screen.getByText('Oversee all appointments and manage slots')).toBeInTheDocument();
  });

  it('displays appointments after loading', async () => {
    renderAdmin();
    await waitFor(() => {
      expect(screen.getByText('John Doe')).toBeInTheDocument();
    });
    expect(screen.getByText('Jane Smith')).toBeInTheDocument();
    expect(screen.getByText('Bob Wilson')).toBeInTheDocument();
  });

  it('shows status badges on appointment cards', async () => {
    renderAdmin();
    await waitFor(() => {
      expect(screen.getByText('John Doe')).toBeInTheDocument();
    });
    expect(screen.getAllByText('Pending').length).toBeGreaterThan(0);
    expect(screen.getAllByText('Confirmed').length).toBeGreaterThan(0);
    expect(screen.getAllByText('Completed').length).toBeGreaterThan(0);
  });

  it('shows filter buttons', async () => {
    renderAdmin();
    await waitFor(() => {
      expect(screen.getByText('John Doe')).toBeInTheDocument();
    });
    expect(screen.getByRole('button', { name: 'All' })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'Pending' })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'Confirmed' })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'Cancelled' })).toBeInTheDocument();
  });

  it('shows action buttons for PENDING appointment', async () => {
    renderAdmin();
    await waitFor(() => {
      expect(screen.getByText('John Doe')).toBeInTheDocument();
    });
    expect(screen.getByRole('button', { name: 'Confirm' })).toBeInTheDocument();
  });

  it('shows Start button for CONFIRMED appointment', async () => {
    renderAdmin();
    await waitFor(() => {
      expect(screen.getByText('Jane Smith')).toBeInTheDocument();
    });
    expect(screen.getByRole('button', { name: 'Start' })).toBeInTheDocument();
  });

  it('does not show Cancel for completed appointments', async () => {
    vi.mocked(api.get).mockResolvedValue({ data: [mockAppointments[2]] });
    renderAdmin();
    await waitFor(() => {
      expect(screen.getByText('Bob Wilson')).toBeInTheDocument();
    });
    expect(screen.queryByRole('button', { name: 'Cancel' })).not.toBeInTheDocument();
  });

  it('calls confirm endpoint on Confirm click', async () => {
    vi.mocked(api.patch).mockResolvedValue({ data: {} });
    renderAdmin();
    await waitFor(() => {
      expect(screen.getByText('John Doe')).toBeInTheDocument();
    });

    await userEvent.click(screen.getByRole('button', { name: 'Confirm' }));

    expect(api.patch).toHaveBeenCalledWith('/admin/appointments/1/confirm');
  });

  it('shows empty state when no appointments', async () => {
    vi.mocked(api.get).mockResolvedValue({ data: [] });
    renderAdmin();
    await waitFor(() => {
      expect(screen.getByText('No appointments found')).toBeInTheDocument();
    });
  });

  it('shows slot generation form', async () => {
    renderAdmin();
    await waitFor(() => {
      expect(screen.getByText('Generate Appointment Slots')).toBeInTheDocument();
    });
    // Open the collapsible panel first
    await userEvent.click(screen.getByText('Generate Appointment Slots'));
    expect(screen.getByRole('button', { name: /generate slots/i })).toBeInTheDocument();
  });

  it('calls slot generation endpoint', async () => {
    vi.mocked(api.post).mockResolvedValueOnce({ data: 'Generated 40 slots' });
    renderAdmin();
    await waitFor(() => {
      expect(screen.getByText('Generate Appointment Slots')).toBeInTheDocument();
    });

    // Open collapsible first
    await userEvent.click(screen.getByText('Generate Appointment Slots'));

    const startInput = screen.getAllByDisplayValue('')[0];
    const endInput = screen.getAllByDisplayValue('')[1];
    await userEvent.type(startInput, '2099-12-01');
    await userEvent.type(endInput, '2099-12-05');

    await userEvent.click(screen.getByRole('button', { name: /generate slots/i }));

    await waitFor(() => {
      expect(api.post).toHaveBeenCalled();
    });
  });
});
