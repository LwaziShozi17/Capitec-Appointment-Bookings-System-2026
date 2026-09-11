import { useState, useEffect } from 'react';
import type { AxiosError } from 'axios';
import api from '../services/api';
import { useToast } from '../context/ToastContext';
import { SkeletonSlotGrid } from './ui/Skeleton';
import type { Appointment, AppointmentSlot, Branch } from '../types';

interface EditBookingModalProps {
  open: boolean;
  appointment: Appointment | null;
  onClose: () => void;
  onSuccess: () => void;
}

export default function EditBookingModal({
  open,
  appointment,
  onClose,
  onSuccess,
}: EditBookingModalProps) {
  const toast = useToast();
  const [resolvedBranchId, setResolvedBranchId] = useState<number | null>(null);
  const [selectedDate, setSelectedDate] = useState('');
  const [selectedSlot, setSelectedSlot] = useState<number | null>(null);
  const [customerName, setCustomerName] = useState('');
  const [customerEmail, setCustomerEmail] = useState('');
  const [customerPhone, setCustomerPhone] = useState('');
  const [slots, setSlots] = useState<AppointmentSlot[]>([]);
  const [slotsLoading, setSlotsLoading] = useState(false);
  const [slotsError, setSlotsError] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState('');

  const getMinDate = () => new Date().toISOString().split('T')[0];

  useEffect(() => {
    if (!open || !appointment) return;

    setSelectedDate(appointment.date || getMinDate());
    setSelectedSlot(appointment.slotId || null);
    setCustomerName(appointment.customerName || '');
    setCustomerEmail(appointment.customerEmail || '');
    setCustomerPhone(appointment.customerPhone || '');
    setError('');
    setSlots([]);

    if (appointment.branchId) {
      setResolvedBranchId(appointment.branchId);
    } else {
      // Find branch by name if branchId is not available
      api.get<Branch[]>('/branches')
        .then(({ data }) => {
          const match = data.find((b) => b.name === appointment.branchName);
          if (match) setResolvedBranchId(match.id);
        })
        .catch(() => {});
    }
  }, [open, appointment]);

  useEffect(() => {
    if (!open || !selectedDate || !resolvedBranchId) return;

    let cancelled = false;
    setSlots([]);
    setSlotsLoading(true);
    setSlotsError('');

    api
      .get<AppointmentSlot[]>('/slots', {
        params: { branchId: resolvedBranchId, date: selectedDate },
      })
      .then(({ data }) => {
        if (!cancelled) {
          setSlots(data);
          setSlotsLoading(false);
        }
      })
      .catch(() => {
        if (!cancelled) {
          setSlots([]);
          setSlotsLoading(false);
          setSlotsError('Could not load time slots. Please try another date.');
        }
      });

    return () => {
      cancelled = true;
    };
  }, [open, selectedDate, resolvedBranchId]);

  if (!open || !appointment) return null;

  const isSlotInPast = (slot: AppointmentSlot) => {
    const now = new Date();
    const slotDateTime = new Date(`${slot.date}T${slot.startTime}`);
    return slotDateTime <= now;
  };

  const isSlotSelectable = (slot: AppointmentSlot) => {
    if (appointment.slotId && slot.id === appointment.slotId) return true;
    return slot.status === 'AVAILABLE' && !isSlotInPast(slot);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedSlot) {
      setError('Please select a time slot.');
      return;
    }

    setError('');
    setSubmitting(true);

    try {
      await api.put(`/appointments/${appointment.id}`, {
        slotId: selectedSlot,
        customerName,
        customerEmail,
        customerPhone,
      });
      toast.success('Appointment updated successfully!');
      onSuccess();
    } catch (err) {
      const message = (err as AxiosError<{ message?: string }>).response?.data?.message;
      setError(message || 'Failed to update appointment. Please try again.');
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center p-4"
      role="dialog"
      aria-modal="true"
      aria-labelledby="edit-modal-title"
    >
      <div className="absolute inset-0 bg-black/50 backdrop-blur-sm" onClick={onClose} />
      <div className="relative bg-surface rounded-2xl shadow-2xl w-full max-w-xl max-h-[90vh] overflow-y-auto p-6 sm:p-8 space-y-6 border border-outline">
        <div className="flex items-start justify-between">
          <div>
            <h2 id="edit-modal-title" className="text-xl font-bold text-text-high">
              Edit / Reschedule Booking
            </h2>
            <p className="text-sm text-text-medium mt-0.5">
              {appointment.serviceName} · {appointment.branchName}
            </p>
          </div>
          <button
            onClick={onClose}
            className="text-text-low hover:text-text-high p-1 rounded-lg hover:bg-surface-dim transition-colors"
            aria-label="Close modal"
          >
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        {error && (
          <div className="p-3.5 bg-error/10 border border-error/30 rounded-xl text-sm text-error flex items-start gap-2">
            <svg className="w-4 h-4 mt-0.5 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <span>{error}</span>
          </div>
        )}

        <form onSubmit={handleSubmit} className="space-y-5">
          {/* Date Picker */}
          <div>
            <label className="block text-xs font-semibold text-text-medium uppercase tracking-wide mb-1.5">
              Select New Date
            </label>
            <input
              type="date"
              value={selectedDate}
              min={getMinDate()}
              onChange={(e) => {
                setSelectedDate(e.target.value);
                setSelectedSlot(null);
              }}
              required
              className="w-full px-3.5 py-2.5 border border-outline rounded-xl focus:ring-2 focus:ring-primary focus:border-transparent outline-none text-sm bg-surface-background"
            />
          </div>

          {/* Time Slots */}
          <div>
            <div className="flex items-center justify-between mb-2">
              <label className="text-xs font-semibold text-text-medium uppercase tracking-wide">
                Select Time Slot
              </label>
              <div className="flex items-center gap-3 text-xs">
                <span className="flex items-center gap-1">
                  <span className="w-2 h-2 rounded bg-success"></span>
                  <span className="text-text-medium">Available</span>
                </span>
                <span className="flex items-center gap-1">
                  <span className="w-2 h-2 rounded bg-error/60"></span>
                  <span className="text-text-medium">Booked</span>
                </span>
              </div>
            </div>

            {slotsLoading ? (
              <SkeletonSlotGrid />
            ) : slotsError ? (
              <div className="text-center py-6 bg-surface-background rounded-xl border border-dashed border-error/40 text-sm text-error">
                {slotsError}
              </div>
            ) : slots.length > 0 ? (
              <div className="grid grid-cols-3 sm:grid-cols-4 gap-2">
                {slots.map((slot) => {
                  const selectable = isSlotSelectable(slot);
                  const isCurrent = appointment.slotId === slot.id;
                  const selected = selectedSlot === slot.id;
                  const blocked = slot.status === 'BLOCKED';
                  const past = isSlotInPast(slot) && !isCurrent;

                  return (
                    <button
                      key={slot.id}
                      type="button"
                      disabled={!selectable}
                      onClick={() => setSelectedSlot(slot.id)}
                      className={`px-2 py-2.5 text-xs rounded-xl border-2 font-semibold transition-all ${
                        selected
                          ? 'border-primary bg-primary text-white shadow-md scale-105'
                          : isCurrent
                          ? 'border-primary/50 bg-primary/10 text-primary hover:bg-primary/20'
                          : selectable
                          ? 'border-success/40 bg-success/10 text-success hover:bg-success/20 hover:border-success hover:scale-105'
                          : blocked
                          ? 'border-outline bg-surface-background text-text-low cursor-not-allowed line-through'
                          : 'border-error/20 bg-error/10 text-error/50 cursor-not-allowed'
                      }`}
                      title={
                        isCurrent
                          ? 'Current booking time'
                          : blocked
                          ? 'Slot blocked'
                          : past
                          ? 'Time passed'
                          : slot.status === 'BOOKED'
                          ? 'Booked'
                          : `${slot.startTime.slice(0, 5)} - ${slot.endTime.slice(0, 5)}`
                      }
                    >
                      {slot.startTime.slice(0, 5)}
                      {isCurrent && !selected && (
                        <span className="block text-[8px] font-normal text-primary">Current</span>
                      )}
                    </button>
                  );
                })}
              </div>
            ) : (
              <div className="text-center py-6 bg-surface-background rounded-xl border border-dashed border-outline text-xs text-text-medium">
                No slots found for this date.
              </div>
            )}
          </div>

          {/* Customer Details */}
          <div className="border-t border-outline pt-4 space-y-3">
            <h3 className="text-xs font-semibold text-text-medium uppercase tracking-wide">
              Contact Details
            </h3>
            <div className="grid sm:grid-cols-2 gap-3">
              <div>
                <label className="block text-xs font-medium text-text-medium mb-1">Full Name</label>
                <input
                  type="text"
                  value={customerName}
                  onChange={(e) => setCustomerName(e.target.value)}
                  required
                  className="w-full px-3 py-2 border border-outline rounded-xl focus:ring-2 focus:ring-primary focus:border-transparent outline-none text-sm bg-surface-background"
                />
              </div>
              <div>
                <label className="block text-xs font-medium text-text-medium mb-1">Email</label>
                <input
                  type="email"
                  value={customerEmail}
                  onChange={(e) => setCustomerEmail(e.target.value)}
                  required
                  className="w-full px-3 py-2 border border-outline rounded-xl focus:ring-2 focus:ring-primary focus:border-transparent outline-none text-sm bg-surface-background"
                />
              </div>
              <div className="sm:col-span-2">
                <label className="block text-xs font-medium text-text-medium mb-1">Phone Number</label>
                <input
                  type="tel"
                  value={customerPhone}
                  onChange={(e) => setCustomerPhone(e.target.value)}
                  placeholder="082 123 4567"
                  className="w-full px-3 py-2 border border-outline rounded-xl focus:ring-2 focus:ring-primary focus:border-transparent outline-none text-sm bg-surface-background"
                />
              </div>
            </div>
          </div>

          {/* Action Buttons */}
          <div className="flex gap-3 pt-3 border-t border-outline">
            <button
              type="button"
              onClick={onClose}
              disabled={submitting}
              className="flex-1 px-4 py-2.5 border border-outline rounded-xl text-sm font-medium text-text-medium hover:bg-surface-background transition-colors"
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={submitting || !selectedSlot}
              className="flex-1 px-4 py-2.5 bg-primary text-white rounded-xl text-sm font-semibold hover:bg-primary-dark disabled:opacity-40 disabled:cursor-not-allowed transition-all shadow-sm"
            >
              {submitting ? 'Saving…' : 'Save Changes'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
