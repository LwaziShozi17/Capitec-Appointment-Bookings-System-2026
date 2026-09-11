import { render, screen, act } from '@testing-library/react';
import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest';
import { ToastProvider, useToast } from '../context/ToastContext';

function ToastConsumer({ action }: { action: (t: ReturnType<typeof useToast>) => void }) {
  const toast = useToast();
  return <button onClick={() => action(toast)}>trigger</button>;
}

function renderWithToast(action: (t: ReturnType<typeof useToast>) => void) {
  return render(
    <ToastProvider>
      <ToastConsumer action={action} />
    </ToastProvider>
  );
}

describe('ToastContext', () => {
  beforeEach(() => {
    vi.useFakeTimers();
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it('shows a success toast', async () => {
    const { getByRole } = renderWithToast((t) => t.success('Saved!'));
    await act(async () => { getByRole('button').click(); });
    expect(screen.getByText('Saved!')).toBeInTheDocument();
  });

  it('shows an error toast', async () => {
    const { getByRole } = renderWithToast((t) => t.error('Something went wrong'));
    await act(async () => { getByRole('button').click(); });
    expect(screen.getByText('Something went wrong')).toBeInTheDocument();
  });

  it('shows an info toast', async () => {
    const { getByRole } = renderWithToast((t) => t.info('FYI'));
    await act(async () => { getByRole('button').click(); });
    expect(screen.getByText('FYI')).toBeInTheDocument();
  });

  it('removes toast after 5 seconds', async () => {
    const { getByRole } = renderWithToast((t) => t.success('Temporary'));
    await act(async () => { getByRole('button').click(); });
    expect(screen.getByText('Temporary')).toBeInTheDocument();
    await act(async () => { vi.advanceTimersByTime(4999); });
    expect(screen.getByText('Temporary')).toBeInTheDocument();
    await act(async () => { vi.advanceTimersByTime(2); });
    expect(screen.queryByText('Temporary')).not.toBeInTheDocument();
  });

  it('throws when useToast used outside provider', () => {
    const Broken = () => { useToast(); return null; };
    expect(() => render(<Broken />)).toThrow('useToast must be used within ToastProvider');
  });
});