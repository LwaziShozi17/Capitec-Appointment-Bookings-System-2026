import { useState, useEffect, useCallback } from 'react';
import type { AxiosError } from 'axios';
import { Link, useLocation } from 'react-router-dom';
import api from '../services/api';
import { useToast } from '../context/ToastContext';
import ConfirmModal from '../components/ui/ConfirmModal';
import { SkeletonCard } from '../components/ui/Skeleton';
import type { Appointment, AppointmentStatus } from '../types';

const STATUS_CONFIG: Record<AppointmentStatus, { label: string; classes: string; border: string }> = {
  PENDING:     { label: 'Pending',     classes: 'bg-warning/10 text-warning',             border: 'border-l-warning' },
  CONFIRMED:   { label: 'Confirmed',   classes: 'bg-info/10 text-info',                   border: 'border-l-info' },
  IN_PROGRESS: { label: 'In Progress', classes: 'bg-primary-container text-primary-dark', border: 'border-l-primary' },
  COMPLETED:   { label: 'Completed',   classes: 'bg-success/10 text-success',             border: 'border-l-success' },
  CANCELLED:   { label: 'Cancelled',   classes: 'bg-surface-dim text-text-medium',        border: 'border-l-outline' },
};

export default function AppointmentsPage() {
  const [appointments, setAppointments] = useState<Appointment[]>([]);
  const [loading, setLoading] = useState(true);
  const [cancelId, setCancelId] = useState<number | null>(null);
  const location = useLocation();
  const toast = useToast();
  const successMessage = (location.state as { message?: string } | null)?.message;

  const loadAppointments = useCallback(() => {
    api.get<Appointment[]>('/appointments/my').then(({ data }) => {
      setAppointments(data);
      setLoading(false);
    });
  }, []);

  useEffect(() => {
    if (successMessage) toast.success(successMessage);
  }, [successMessage, toast]);

  useEffect(() => {
    loadAppointments();
  }, [loadAppointments]);

  const handleConfirmCancel = async () => {
    if (cancelId === null) return;
    try {
      await api.delete(`/appointments/${cancelId}`);
      toast.success('Appointment cancelled successfully.');
      loadAppointments();
    } catch (err) {
      const message = (err as AxiosError<{ message?: string }>).response?.data?.message;
      toast.error(message || 'Failed to cancel appointment');
    } finally {
      setCancelId(null);
    }
  };

  if (loading) {
    return (
      <div>
        <div className="mb-8">
          <h1 className="text-2xl font-bold text-text-high">My Appointments</h1>
          <p className="text-text-medium mt-1">View and manage your branch appointments</p>
        </div>
        <div className="space-y-4">
          {Array.from({ length: 3 }).map((_, i) => <SkeletonCard key={i} />)}
        </div>
      </div>
    );
  }

  return (
    <div>
      <div className="mb-8 flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-text-high">My Appointments</h1>
          <p className="text-text-medium mt-1">View and manage your branch appointments</p>
        </div>
        {appointments.length > 0 && (
          <Link
            to="/branches"
            className="hidden sm:inline-flex px-4 py-2 bg-primary text-white text-sm font-semibold rounded-xl hover:bg-primary-dark transition-colors"
          >
            + Book New
          </Link>
        )}
      </div>

      {appointments.length === 0 ? (
        <div className="text-center py-20 bg-surface rounded-2xl border border-outline shadow-sm">
          <div className="w-16 h-16 bg-surface-dim rounded-full flex items-center justify-center mx-auto mb-4">
            <svg className="w-8 h-8 text-text-low" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
            </svg>
          </div>
          <h3 className="font-semibold text-text-high mb-1">No appointments yet</h3>
          <p className="text-sm text-text-medium mb-6">Book your first appointment at a Capitec branch</p>
          <Link
            to="/branches"
            className="inline-flex px-6 py-3 bg-primary text-white text-sm font-semibold rounded-xl hover:bg-primary-dark transition-colors"
          >
            Book Appointment
          </Link>
        </div>
      ) : (
        <div className="space-y-4">
          {appointments.map((apt) => {
            const cfg = STATUS_CONFIG[apt.status];
            return (
              <div
                key={apt.id}
                className={`bg-surface rounded-2xl border border-outline border-l-4 ${cfg.border} p-6 shadow-sm hover:shadow-md transition-shadow`}
              >
                <div className="flex items-start justify-between gap-4">
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2.5 flex-wrap">
                      <h3 className="font-bold text-text-high">{apt.serviceName}</h3>
                      <span className={`text-xs px-2.5 py-0.5 rounded-full font-semibold ${cfg.classes}`}>
                        {cfg.label}
                      </span>
                    </div>
                    <p className="text-sm text-text-medium mt-1 font-medium">{apt.branchName}</p>
                    <p className="text-xs text-text-low">{apt.branchAddress}</p>
                  </div>
                  <span className="text-xs text-text-low font-mono shrink-0 bg-surface-background px-2 py-1 rounded-lg">
                    {apt.referenceNumber}
                  </span>
                </div>

                <div className="mt-4 pt-4 border-t border-outline flex items-center justify-between gap-4">
                  <div className="flex items-center gap-2 text-sm text-text-medium">
                    <svg className="w-4 h-4 text-text-low" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                    <span className="font-semibold">{apt.date}</span>
                    <span className="text-text-low">·</span>
                    <span>{apt.startTime} – {apt.endTime}</span>
                  </div>
                  {apt.status !== 'CANCELLED' && apt.status !== 'COMPLETED' && (
                    <button
                      onClick={() => setCancelId(apt.id)}
                      className="text-sm text-error hover:text-error-dark font-semibold transition-colors"
                    >
                      Cancel
                    </button>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      )}

      <ConfirmModal
        open={cancelId !== null}
        title="Cancel Appointment"
        message="Are you sure you want to cancel this appointment? This action cannot be undone."
        confirmLabel="Yes, Cancel"
        cancelLabel="Keep It"
        variant="danger"
        onConfirm={handleConfirmCancel}
        onCancel={() => setCancelId(null)}
      />
    </div>
  );
}
