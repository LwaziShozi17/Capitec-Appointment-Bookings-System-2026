import { useState, useEffect, useCallback } from 'react';
import type { AxiosError } from 'axios';
import api from '../services/api';
import { useToast } from '../context/ToastContext';
import ConfirmModal from '../components/ui/ConfirmModal';
import StatCard from '../components/ui/StatCard';
import { SkeletonRow } from '../components/ui/Skeleton';
import type { Appointment, AppointmentStatus } from '../types';

const STATUS_CONFIG: Record<AppointmentStatus, { label: string; classes: string }> = {
  PENDING:     { label: 'Pending',     classes: 'bg-warning/10 text-warning' },
  CONFIRMED:   { label: 'Confirmed',   classes: 'bg-info/10 text-info' },
  IN_PROGRESS: { label: 'In Progress', classes: 'bg-primary-container text-primary-dark' },
  COMPLETED:   { label: 'Completed',   classes: 'bg-success/10 text-success' },
  CANCELLED:   { label: 'Cancelled',   classes: 'bg-surface-dim text-text-medium' },
};

const NEXT_ACTION: Partial<Record<AppointmentStatus, { label: string; endpoint: string }>> = {
  PENDING:     { label: 'Confirm',  endpoint: 'confirm' },
  CONFIRMED:   { label: 'Start',    endpoint: 'start' },
  IN_PROGRESS: { label: 'Complete', endpoint: 'complete' },
};

const ALL_FILTERS = ['', 'PENDING', 'CONFIRMED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED'] as const;
type FilterValue = typeof ALL_FILTERS[number];

export default function AdminPage() {
  const [appointments, setAppointments] = useState<Appointment[]>([]);
  const [filter, setFilter] = useState<FilterValue>('');
  const [loading, setLoading] = useState(true);
  const [generating, setGenerating] = useState(false);
  const [slotsOpen, setSlotsOpen] = useState(false);
  const [genForm, setGenForm] = useState({ branchId: '1', startDate: '', endDate: '' });
  const [cancelId, setCancelId] = useState<number | null>(null);
  const toast = useToast();

  const loadAppointments = useCallback(() => {
    const params = filter ? { status: filter } : {};
    api.get<Appointment[]>('/admin/appointments', { params }).then(({ data }) => {
      setAppointments(data);
      setLoading(false);
    });
  }, [filter]);

  useEffect(() => {
    loadAppointments();
  }, [loadAppointments]);

  const handleAction = async (id: number, endpoint: string, label: string) => {
    try {
      await api.patch(`/admin/appointments/${id}/${endpoint}`);
      toast.success(`Appointment ${label.toLowerCase()}ed successfully.`);
      loadAppointments();
    } catch (err) {
      const message = (err as AxiosError<{ message?: string }>).response?.data?.message;
      toast.error(message || 'Action failed');
    }
  };

  const handleConfirmCancel = async () => {
    if (cancelId === null) return;
    try {
      await api.patch(`/admin/appointments/${cancelId}/cancel`);
      toast.success('Appointment cancelled.');
      loadAppointments();
    } catch (err) {
      const message = (err as AxiosError<{ message?: string }>).response?.data?.message;
      toast.error(message || 'Cancel failed');
    } finally {
      setCancelId(null);
    }
  };

  const handleGenerateSlots = async (e: React.FormEvent) => {
    e.preventDefault();
    setGenerating(true);
    try {
      const { data } = await api.post('/admin/slots/generate', null, { params: genForm });
      toast.success(typeof data === 'string' ? data : 'Slots generated successfully.');
      setSlotsOpen(false);
    } catch (err) {
      const message = (err as AxiosError<{ message?: string }>).response?.data?.message;
      toast.error(message || 'Slot generation failed');
    } finally {
      setGenerating(false);
    }
  };

  const total = appointments.length;
  const pending = appointments.filter((a) => a.status === 'PENDING').length;
  const confirmed = appointments.filter((a) => a.status === 'CONFIRMED').length;
  const completed = appointments.filter((a) => a.status === 'COMPLETED').length;

  const FILTER_LABELS: Record<FilterValue, string> = {
    '': 'All',
    PENDING: 'Pending',
    CONFIRMED: 'Confirmed',
    IN_PROGRESS: 'In Progress',
    COMPLETED: 'Completed',
    CANCELLED: 'Cancelled',
  };

  return (
    <div>
      {/* Header */}
      <div className="mb-8 flex items-start justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-text-high">Admin Dashboard</h1>
          <p className="text-text-medium mt-1">Oversee all appointments and manage slots</p>
        </div>
        <button className="hidden sm:inline-flex items-center gap-2 px-4 py-2 border border-outline text-sm font-medium text-text-medium rounded-xl hover:bg-surface-background transition-colors">
          <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
          </svg>
          Export
        </button>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
        <StatCard
          label="Total"
          value={total}
          color="red"
          icon={
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
            </svg>
          }
        />
        <StatCard
          label="Pending"
          value={pending}
          color="amber"
          icon={
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          }
        />
        <StatCard
          label="Confirmed"
          value={confirmed}
          color="blue"
          icon={
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          }
        />
        <StatCard
          label="Completed"
          value={completed}
          color="green"
          icon={
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
            </svg>
          }
        />
      </div>

      {/* Slot Generation (collapsible) */}
      <div className="bg-surface rounded-2xl border border-outline shadow-sm mb-6">
        <button
          type="button"
          onClick={() => setSlotsOpen((v) => !v)}
          className="w-full flex items-center justify-between px-6 py-4 text-left"
        >
          <div className="flex items-center gap-2">
            <svg className="w-4 h-4 text-text-medium" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
            </svg>
            <span className="font-semibold text-text-high text-sm">Generate Appointment Slots</span>
          </div>
          <svg
            className={`w-4 h-4 text-text-low transition-transform ${slotsOpen ? 'rotate-180' : ''}`}
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
          </svg>
        </button>
        {slotsOpen && (
          <div className="px-6 pb-6 border-t border-outline pt-5">
            <form onSubmit={handleGenerateSlots} className="flex flex-wrap items-end gap-4">
              <div>
                <label className="block text-xs font-medium text-text-medium uppercase tracking-wide mb-1.5">Branch ID</label>
                <input
                  type="number"
                  value={genForm.branchId}
                  onChange={(e) => setGenForm((p) => ({ ...p, branchId: e.target.value }))}
                  className="px-3 py-2.5 border border-outline rounded-xl text-sm w-24 bg-surface-background focus:ring-2 focus:ring-primary outline-none"
                  min="1"
                  required
                />
              </div>
              <div>
                <label className="block text-xs font-medium text-text-medium uppercase tracking-wide mb-1.5">Start date</label>
                <input
                  type="date"
                  value={genForm.startDate}
                  onChange={(e) => setGenForm((p) => ({ ...p, startDate: e.target.value }))}
                  className="px-3 py-2.5 border border-outline rounded-xl text-sm bg-surface-background focus:ring-2 focus:ring-primary outline-none"
                  required
                />
              </div>
              <div>
                <label className="block text-xs font-medium text-text-medium uppercase tracking-wide mb-1.5">End date</label>
                <input
                  type="date"
                  value={genForm.endDate}
                  onChange={(e) => setGenForm((p) => ({ ...p, endDate: e.target.value }))}
                  className="px-3 py-2.5 border border-outline rounded-xl text-sm bg-surface-background focus:ring-2 focus:ring-primary outline-none"
                  required
                />
              </div>
              <button
                type="submit"
                disabled={generating}
                className="px-5 py-2.5 bg-primary text-white rounded-xl text-sm font-semibold hover:bg-primary-dark disabled:opacity-50 transition-colors"
              >
                {generating ? 'Generating…' : 'Generate Slots'}
              </button>
            </form>
          </div>
        )}
      </div>

      {/* Filter (segmented control) */}
      <div className="flex items-center mb-6 overflow-x-auto">
        <div className="flex rounded-xl border border-outline bg-surface overflow-hidden shadow-sm">
          {ALL_FILTERS.map((status, i) => (
            <button
              key={status}
              onClick={() => setFilter(status)}
              className={`px-4 py-2 text-sm font-medium whitespace-nowrap transition-colors ${
                i > 0 ? 'border-l border-outline' : ''
              } ${
                filter === status
                  ? 'bg-primary text-white'
                  : 'text-text-medium hover:bg-surface-background'
              }`}
            >
              {FILTER_LABELS[status]}
            </button>
          ))}
        </div>
      </div>

      {/* Appointments list */}
      {loading ? (
        <div className="space-y-3">
          {Array.from({ length: 5 }).map((_, i) => <SkeletonRow key={i} />)}
        </div>
      ) : appointments.length === 0 ? (
        <div className="text-center py-16 bg-surface rounded-2xl border border-outline shadow-sm">
          <div className="w-12 h-12 bg-surface-dim rounded-full flex items-center justify-center mx-auto mb-3">
            <svg className="w-6 h-6 text-text-low" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2" />
            </svg>
          </div>
          <p className="text-text-medium font-medium">No appointments found</p>
          <p className="text-xs text-text-low mt-1">Try a different filter</p>
        </div>
      ) : (
        <div className="space-y-3">
          {appointments.map((apt) => {
            const cfg = STATUS_CONFIG[apt.status];
            const next = NEXT_ACTION[apt.status];
            return (
              <div key={apt.id} className="bg-surface rounded-xl border border-outline p-5 shadow-sm hover:shadow-md transition-shadow">
                <div className="flex items-center justify-between gap-4 flex-wrap">
                  <div className="flex items-center gap-3 flex-wrap">
                    <span className={`text-xs px-2.5 py-0.5 rounded-full font-semibold ${cfg.classes}`}>
                      {cfg.label}
                    </span>
                    <span className="font-semibold text-text-high text-sm">{apt.customerName}</span>
                    <span className="text-xs text-text-low font-mono bg-surface-background px-2 py-0.5 rounded-lg">
                      {apt.referenceNumber}
                    </span>
                  </div>
                  <div className="flex items-center gap-2">
                    {next && (
                      <button
                        onClick={() => handleAction(apt.id, next.endpoint, next.label)}
                        className="px-3 py-1.5 bg-success text-white text-xs rounded-lg font-semibold hover:bg-success-dark transition-colors"
                      >
                        {next.label}
                      </button>
                    )}
                    {apt.status !== 'CANCELLED' && apt.status !== 'COMPLETED' && (
                      <button
                        onClick={() => setCancelId(apt.id)}
                        className="px-3 py-1.5 border border-error/30 text-error text-xs rounded-lg font-semibold hover:bg-error/10 transition-colors"
                      >
                        Cancel
                      </button>
                    )}
                  </div>
                </div>
                <div className="mt-2 text-xs text-text-medium flex items-center gap-1.5 flex-wrap">
                  <span>{apt.serviceName}</span>
                  <span className="text-outline">·</span>
                  <span>{apt.branchName}</span>
                  <span className="text-outline">·</span>
                  <span className="font-medium text-text-medium">{apt.date}</span>
                  <span>{apt.startTime}–{apt.endTime}</span>
                  <span className="text-outline">·</span>
                  <span className="text-text-low">{apt.customerEmail}</span>
                </div>
              </div>
            );
          })}
        </div>
      )}

      <ConfirmModal
        open={cancelId !== null}
        title="Cancel Appointment"
        message="Are you sure you want to cancel this appointment?"
        confirmLabel="Yes, Cancel"
        cancelLabel="Keep It"
        variant="danger"
        onConfirm={handleConfirmCancel}
        onCancel={() => setCancelId(null)}
      />
    </div>
  );
}
