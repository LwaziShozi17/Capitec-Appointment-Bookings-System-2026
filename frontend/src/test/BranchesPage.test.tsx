import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { MemoryRouter } from 'react-router-dom';
import { AuthProvider } from '../context/AuthContext';
import BranchesPage from '../pages/BranchesPage';
import api from '../services/api';

vi.mock('../services/api');

const mockNavigate = vi.fn();
vi.mock('react-router-dom', async () => {
  const actual = await vi.importActual('react-router-dom');
  return { ...actual, useNavigate: () => mockNavigate };
});

const mockBranches = [
  { id: 1, name: 'Capitec Sandton', code: 'CAP-GP-SDN', address: '163 5th St', province: 'Gauteng', latitude: -26, longitude: 28, operatingHours: [] },
  { id: 2, name: 'Capitec Canal Walk', code: 'CAP-WC-CNW', address: 'Century City', province: 'Western Cape', latitude: -33, longitude: 18, operatingHours: [] },
  { id: 3, name: 'Capitec Gateway', code: 'CAP-KZN-GTW', address: 'Umhlanga', province: 'KwaZulu-Natal', latitude: -29, longitude: 31, operatingHours: [] },
];

function renderBranches() {
  localStorage.setItem('user_profile', JSON.stringify({ email: 'u', name: 'U', role: 'USER' }));
  return render(
    <MemoryRouter>
      <AuthProvider>
        <BranchesPage />
      </AuthProvider>
    </MemoryRouter>
  );
}

describe('BranchesPage', () => {
  beforeEach(() => {
    localStorage.clear();
    vi.clearAllMocks();
    vi.mocked(api.get).mockResolvedValue({ data: mockBranches });
  });

  it('shows loading then branches', async () => {
    vi.mocked(api.get).mockImplementation(() => new Promise(() => {}));
    renderBranches();
    // Skeleton cards shown during load; no branch names yet
    expect(screen.queryByText('Capitec Sandton')).not.toBeInTheDocument();
  });

  it('shows province filter buttons', async () => {
    renderBranches();
    await waitFor(() => {
      expect(screen.getByText('Capitec Sandton')).toBeInTheDocument();
    });
    const buttons = screen.getAllByRole('button');
    const filterTexts = buttons.map(b => b.textContent ?? '');
    expect(filterTexts.some(t => t.includes('Gauteng'))).toBe(true);
    expect(filterTexts.some(t => t.includes('Western Cape'))).toBe(true);
    expect(filterTexts.some(t => t.includes('KwaZulu-Natal'))).toBe(true);
  });

  it('filters by province', async () => {
    renderBranches();
    await waitFor(() => {
      expect(screen.getByText('Capitec Sandton')).toBeInTheDocument();
    });

    const gautengButton = screen.getAllByRole('button').find(b => b.textContent?.includes('Gauteng'))!;
    await userEvent.click(gautengButton);

    expect(screen.getByText('Capitec Sandton')).toBeInTheDocument();
    expect(screen.queryByText('Capitec Canal Walk')).not.toBeInTheDocument();
    expect(screen.queryByText('Capitec Gateway')).not.toBeInTheDocument();
  });

  it('navigates to booking on branch click', async () => {
    renderBranches();
    await waitFor(() => {
      expect(screen.getByText('Capitec Sandton')).toBeInTheDocument();
    });

    await userEvent.click(screen.getByText('Capitec Sandton'));
    expect(mockNavigate).toHaveBeenCalledWith('/book/1');
  });
});