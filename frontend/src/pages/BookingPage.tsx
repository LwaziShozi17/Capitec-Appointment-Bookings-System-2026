import { useState, useEffect } from 'react';
import type { AxiosError } from 'axios';
import { useParams, useNavigate } from 'react-router-dom';
import api from '../services/api';
import { useAuth } from '../context/AuthContext';
import { SkeletonSlotGrid } from '../components/ui/Skeleton';
import type { Branch, ServiceType, AppointmentSlot } from '../types';

const STEPS = ['Select Service', 'Date & Time', 'Your Details'];

function StepIndicator({ current }: { current: number }) {
  return (
    <div className="flex items-center gap-0 mb-8">
      {STEPS.map((label, i) => (
        <div key={i} className="flex items-center flex-1 last:flex-none">
          <div className="flex flex-col items-center gap-1">
            <div
              className={`w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold transition-colors ${
                i < current
                  ? 'bg-primary text-white'
                  : i === current
                  ? 'bg-primary text-white ring-4 ring-primary/20'
                  : 'bg-surface-dim text-text-low'
              }`}
            >
              {i < current ? (
                <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M5 13l4 4L19 7" />
                </svg>
              ) : (
                i + 1
              )}
            </div>
            <span className={`text-xs font-medium whitespace-nowrap hidden sm:block ${i === current ? 'text-primary' : 'text-text-low'}`}>
              {label}
            </span>
          </div>
          {i < STEPS.length - 1 && (
            <div className={`flex-1 h-0.5 mx-2 transition-colors ${i < current ? 'bg-primary' : 'bg-surface-dim'}`} />
          )}
        </div>
      ))}
    </div>
  );
}

export default function BookingPage() {
  const { branchId } = useParams<{ branchId: string }>();
  const { user } = useAuth();
  const navigate = useNavigate();

  const [branch, setBranch] = useState<Branch | null>(null);
  const [services, setServices] = useState<ServiceType[]>([]);
  const [slots, setSlots] = useState<AppointmentSlot[]>([]);
  const [selectedService, setSelectedService] = useState<ServiceType | null>(null);
  const [selectedSlot, setSelectedSlot] = useState<number | null>(null);
  const [selectedDate, setSelectedDate] = useState('');
  const [customerName, setCustomerName] = useState('');
  const [customerEmail, setCustomerEmail] = useState(user?.email || '');
  const [customerPhone, setCustomerPhone] = useState('');
  const [loading, setLoading] = useState(true);
  const [slotsLoading, setSlotsLoading] = useState(false);
  const [slotsError, setSlotsError] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    Promise.all([
      api.get<Branch>(`/branches/${branchId}`),
      api.get<ServiceType[]>('/services'),
    ]).then(([branchRes, servicesRes]) => {
      setBranch(branchRes.data);
      setServices(servicesRes.data);
      setLoading(false);
    });
  }, [branchId]);

  useEffect(() => {
    if (!selectedDate || !branchId) return;
    let cancelled = false;
    setSlotsLoading(true);
    setSlotsError('');
    api
      .get<AppointmentSlot[]>('/slots', { params: { branchId, date: selectedDate } })
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
          setSlotsError('Could not load slots. Please try again.');
        }
      });
    return () => { cancelled = true; };
  }, [selectedDate, branchId]);

  const isSlotInPast = (slot: AppointmentSlot) => {
    const now = new Date();
    const slotDateTime = new Date(`${slot.date}T${slot.startTime}`);
    return slotDateTime <= now;
  };

  const isSlotAvailable = (slot: AppointmentSlot) =>
    slot.status === 'AVAILABLE' && !isSlotInPast(slot);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedSlot || !selectedService) return;
    setError('');
    setSubmitting(true);
    try {
      await api.post('/appointments', {
        slotId: selectedSlot,
        serviceTypeId: selectedService.id,
        customerName,
        customerEmail,
        customerPhone,
      });
      navigate('/appointments', { state: { message: 'Appointment booked successfully!' } });
    } catch (err) {
      const message = (err as AxiosError<{ message?: string }>).response?.data?.message;
      setError(message || 'Booking failed. Please try again.');
    } finally {
      setSubmitting(false);
    }
  };

  const getMinDate = () => new Date().toISOString().split('T')[0];

  const currentStep = !selectedService ? 0 : !selectedSlot ? 1 : 2;

  if (loading) {
    return (
      <div className="max-w-3xl mx-auto">
        <div className="h-8 w-48 bg-surface-dim rounded animate-pulse mb-2" />
        <div className="h-4 w-64 bg-surface-dim rounded animate-pulse" />
      </div>
    );
  }

  const documents = selectedService?.requiredDocuments?.split(';').filter(Boolean) || [];

  return (
    <div className="max-w-3xl mx-auto">
      {/* Header */}
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-text-high">Book Appointment</h1>
        <div className="flex items-center gap-2 mt-1">
          <p className="text-text-medium text-sm">{branch?.name}</p>
          <span className="text-outline">·</span>
          <p className="text-text-medium text-sm">{branch?.address}</p>
          <span className="text-xs text-primary font-semibold bg-primary/10 px-2 py-0.5 rounded-full">
            {branch?.province}
          </span>
        </div>
      </div>

      <StepIndicator current={currentStep} />

      {error && (
        <div className="mb-6 p-4 bg-error/10 border border-error/30 rounded-xl text-sm text-error flex items-start gap-2">
          <svg className="w-4 h-4 mt-0.5 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          {error}
        </div>
      )}

      <form onSubmit={handleSubmit} className="space-y-5">
        {/* Step 1: Service Selection */}
        <div className="bg-surface rounded-2xl border border-outline p-6 space-y-4 shadow-sm">
          <div className="flex items-center gap-2">
            <span className="w-6 h-6 bg-primary text-white rounded-full flex items-center justify-center text-xs font-bold">1</span>
            <h2 className="font-semibold text-text-high">Select Service</h2>
          </div>
          <div className="grid gap-2">
            {services.map((service) => (
              <label
                key={service.id}
                className={`flex items-center justify-between p-4 rounded-xl border-2 cursor-pointer transition-all ${
                  selectedService?.id === service.id
                    ? 'border-primary bg-primary/10'
                    : 'border-outline hover:border-outline bg-surface-background/50'
                }`}
              >
                <div className="flex items-center gap-3">
                  <input
                    type="radio"
                    name="service"
                    value={service.id}
                    checked={selectedService?.id === service.id}
                    onChange={() => setSelectedService(service)}
                    className="accent-primary"
                  />
                  <div>
                    <span className="text-sm font-semibold text-text-high">{service.name}</span>
                    <p className="text-xs text-text-medium mt-0.5">{service.description}</p>
                  </div>
                </div>
                <div className="text-right ml-4 shrink-0">
                  <span className="text-sm font-bold text-text-high">{service.durationMinutes} min</span>
                  <p className="text-xs text-text-low">session</p>
                </div>
              </label>
            ))}
          </div>
        </div>

        {/* Required Documents */}
        {selectedService && documents.length > 0 && (
          <div className="bg-warning/10 rounded-2xl border border-warning/30 p-5">
            <h3 className="font-semibold text-warning flex items-center gap-2 text-sm">
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
              Required Documents — {selectedService.name}
            </h3>
            <ul className="mt-3 space-y-1.5">
              {documents.map((doc, i) => (
                <li key={i} className="flex items-start gap-2 text-sm text-text-medium">
                  <svg className="w-4 h-4 mt-0.5 text-warning shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                  </svg>
                  {doc}
                </li>
              ))}
            </ul>
          </div>
        )}

        {/* Step 2: Date & Time */}
        <div className="bg-surface rounded-2xl border border-outline p-6 space-y-4 shadow-sm">
          <div className="flex items-center gap-2">
            <span className="w-6 h-6 bg-primary text-white rounded-full flex items-center justify-center text-xs font-bold">2</span>
            <h2 className="font-semibold text-text-high">Choose Date & Time</h2>
          </div>

          <div>
            <label className="block text-xs font-medium text-text-medium uppercase tracking-wide mb-1.5">Select date</label>
            <input
              type="date"
              value={selectedDate}
              onChange={(e) => { setSelectedDate(e.target.value); setSelectedSlot(null); }}
              min={getMinDate()}
              className="w-full px-3 py-2.5 border border-outline rounded-xl focus:ring-2 focus:ring-primary focus:border-transparent outline-none text-sm bg-surface-background"
            />
          </div>

          {selectedDate && (
            <div>
              <div className="flex items-center justify-between mb-3">
                <label className="text-xs font-medium text-text-medium uppercase tracking-wide">Time slots</label>
                <div className="flex items-center gap-4 text-xs">
                  <span className="flex items-center gap-1.5">
                    <span className="w-2.5 h-2.5 rounded bg-success"></span>
                    <span className="text-text-medium">Available</span>
                  </span>
                  <span className="flex items-center gap-1.5">
                    <span className="w-2.5 h-2.5 rounded bg-error/60"></span>
                    <span className="text-text-medium">Booked</span>
                  </span>
                  <span className="flex items-center gap-1.5">
                    <span className="w-2.5 h-2.5 rounded bg-outline"></span>
                    <span className="text-text-medium">Blocked</span>
                  </span>
                </div>
              </div>

              {slotsLoading ? (
                <SkeletonSlotGrid />
              ) : slotsError ? (
                <div className="text-center py-8 bg-surface-background rounded-xl border border-dashed border-error/40">
                  <p className="text-sm text-error font-medium">{slotsError}</p>
                </div>
              ) : slots.length > 0 ? (
                <div className="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-5 gap-2">
                  {slots.map((slot) => {
                    const available = isSlotAvailable(slot);
                    const blocked = slot.status === 'BLOCKED';
                    const selected = selectedSlot === slot.id;
                    const past = isSlotInPast(slot);

                    return (
                      <button
                        key={slot.id}
                        type="button"
                        disabled={!available}
                        onClick={() => setSelectedSlot(slot.id)}
                        className={`px-2 py-3 text-xs rounded-xl border-2 font-semibold transition-all ${
                          selected
                            ? 'border-primary bg-primary text-white shadow-md scale-105'
                            : available
                            ? 'border-success/40 bg-success/10 text-success hover:bg-success/20 hover:border-success hover:scale-105'
                            : blocked
                            ? 'border-outline bg-surface-background text-text-low cursor-not-allowed line-through'
                            : 'border-error/20 bg-error/10 text-error/50 cursor-not-allowed'
                        }`}
                        title={
                          blocked
                            ? 'This slot is blocked'
                            : past
                            ? 'This time has passed'
                            : slot.status === 'BOOKED'
                            ? 'Already booked'
                            : `${slot.startTime} – ${slot.endTime}`
                        }
                      >
                        {slot.startTime}
                        {!available && !blocked && (
                          <span className="block text-[9px] mt-0.5 font-normal">
                            {past ? 'Passed' : 'Booked'}
                          </span>
                        )}
                      </button>
                    );
                  })}
                </div>
              ) : (
                <div className="text-center py-8 bg-surface-background rounded-xl border border-dashed border-outline">
                  <svg className="w-8 h-8 text-text-low mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                  </svg>
                  <p className="text-sm text-text-medium font-medium">No slots for this date</p>
                  <p className="text-xs text-text-low mt-0.5">Try another date or contact admin to generate slots</p>
                </div>
              )}
            </div>
          )}
        </div>

        {/* Step 3: Customer Details */}
        <div className="bg-surface rounded-2xl border border-outline p-6 space-y-4 shadow-sm">
          <div className="flex items-center gap-2">
            <span className="w-6 h-6 bg-primary text-white rounded-full flex items-center justify-center text-xs font-bold">3</span>
            <h2 className="font-semibold text-text-high">Your Details</h2>
          </div>
          <div className="grid sm:grid-cols-2 gap-4">
            <div>
              <label className="block text-xs font-medium text-text-medium uppercase tracking-wide mb-1.5">Full name</label>
              <input
                type="text"
                value={customerName}
                onChange={(e) => setCustomerName(e.target.value)}
                required
                placeholder="John Smith"
                className="w-full px-3 py-2.5 border border-outline rounded-xl focus:ring-2 focus:ring-primary focus:border-transparent outline-none text-sm bg-surface-background"
              />
            </div>
            <div>
              <label className="block text-xs font-medium text-text-medium uppercase tracking-wide mb-1.5">Email</label>
              <input
                type="email"
                value={customerEmail}
                onChange={(e) => setCustomerEmail(e.target.value)}
                required
                placeholder="you@example.com"
                className="w-full px-3 py-2.5 border border-outline rounded-xl focus:ring-2 focus:ring-primary focus:border-transparent outline-none text-sm bg-surface-background"
              />
            </div>
            <div className="sm:col-span-2">
              <label className="block text-xs font-medium text-text-medium uppercase tracking-wide mb-1.5">Phone number</label>
              <input
                type="tel"
                value={customerPhone}
                onChange={(e) => setCustomerPhone(e.target.value)}
                placeholder="082 123 4567"
                className="w-full px-3 py-2.5 border border-outline rounded-xl focus:ring-2 focus:ring-primary focus:border-transparent outline-none text-sm bg-surface-background"
              />
            </div>
          </div>
        </div>

        {/* Booking Summary */}
        {selectedService && selectedSlot && (
          <div className="bg-surface rounded-2xl border-l-4 border-l-primary border border-outline p-6 shadow-sm">
            <h3 className="font-semibold text-text-high mb-4 flex items-center gap-2">
              <svg className="w-4 h-4 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
              </svg>
              Booking Summary
            </h3>
            <dl className="grid grid-cols-2 gap-3 text-sm">
              <div>
                <dt className="text-text-low text-xs uppercase tracking-wide">Branch</dt>
                <dd className="font-semibold text-text-high mt-0.5">{branch?.name}</dd>
              </div>
              <div>
                <dt className="text-text-low text-xs uppercase tracking-wide">Service</dt>
                <dd className="font-semibold text-text-high mt-0.5">{selectedService.name}</dd>
              </div>
              <div>
                <dt className="text-text-low text-xs uppercase tracking-wide">Duration</dt>
                <dd className="font-semibold text-text-high mt-0.5">{selectedService.durationMinutes} minutes</dd>
              </div>
              <div>
                <dt className="text-text-low text-xs uppercase tracking-wide">Date & Time</dt>
                <dd className="font-semibold text-text-high mt-0.5">
                  {selectedDate} at {slots.find((s) => s.id === selectedSlot)?.startTime}
                </dd>
              </div>
            </dl>
          </div>
        )}

        <button
          type="submit"
          disabled={submitting || !selectedSlot || !selectedService || !customerName}
          className="w-full py-3.5 bg-primary text-white rounded-xl font-semibold hover:bg-primary-dark disabled:opacity-40 disabled:cursor-not-allowed transition-all shadow-sm hover:shadow-md"
        >
          {submitting ? (
            <span className="flex items-center justify-center gap-2">
              <svg className="w-4 h-4 animate-spin" fill="none" viewBox="0 0 24 24">
                <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
              </svg>
              Booking…
            </span>
          ) : (
            'Confirm Booking'
          )}
        </button>
      </form>
    </div>
  );
}
