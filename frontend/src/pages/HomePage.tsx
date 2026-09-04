import { Link } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

const STEPS = [
  {
    icon: (
      <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
      </svg>
    ),
    title: 'Choose a Branch',
    desc: 'Pick from Capitec branches across South Africa',
  },
  {
    icon: (
      <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
      </svg>
    ),
    title: 'Pick a Time',
    desc: 'Select your date and an available time slot',
  },
  {
    icon: (
      <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
      </svg>
    ),
    title: 'Get Confirmed',
    desc: 'Receive confirmation and track your appointment',
  },
];

const SERVICES = [
  { icon: '🏦', label: 'Account Opening' },
  { icon: '💳', label: 'Card Services' },
  { icon: '💰', label: 'Loan Consultation' },
  { icon: '📱', label: 'Digital Banking' },
];

export default function HomePage() {
  const { user } = useAuth();

  return (
    <div>
      {/* Hero */}
      <section className="relative rounded-2xl overflow-hidden bg-primary-dark text-white mb-12">
        {/* Subtle ambient light from the right — intentional, not filler */}
        <div className="absolute inset-y-0 right-0 w-2/3 bg-gradient-to-l from-primary/20 to-transparent pointer-events-none" />
        <div className="absolute bottom-0 inset-x-0 h-px bg-white/5" />

        <div className="relative px-8 sm:px-12 py-14 sm:py-20">
          <p className="text-[10px] font-bold tracking-[0.25em] text-white/30 uppercase mb-6">
            Capitec Branch Booking
          </p>
          <h1 className="text-4xl sm:text-5xl font-black leading-[1.06] tracking-tight max-w-lg">
            Skip the queue.{' '}
            <span className="text-primary-light">Book your slot online.</span>
          </h1>
          <p className="mt-5 text-white/50 text-sm leading-relaxed max-w-sm">
            Choose a branch, pick a time that works, and arrive at your confirmed appointment.
          </p>

          {user ? (
            <div className="mt-8 flex gap-3 flex-wrap">
              <Link
                to="/branches"
                className="px-5 py-2.5 bg-primary text-white rounded-lg text-sm font-semibold hover:bg-primary-light transition-colors"
              >
                Book Appointment
              </Link>
              <Link
                to="/appointments"
                className="px-5 py-2.5 border border-white/15 text-white/75 rounded-lg text-sm font-medium hover:bg-white/5 hover:text-white transition-colors"
              >
                My Appointments
              </Link>
            </div>
          ) : (
            <div className="mt-8 flex gap-3 flex-wrap">
              <Link
                to="/login"
                className="px-5 py-2.5 bg-primary text-white rounded-lg text-sm font-semibold hover:bg-primary-light transition-colors"
              >
                Sign In
              </Link>
              <Link
                to="/register"
                className="px-5 py-2.5 border border-white/15 text-white/75 rounded-lg text-sm font-medium hover:bg-white/5 hover:text-white transition-colors"
              >
                Create Account
              </Link>
            </div>
          )}
        </div>
      </section>

      {/* How it works */}
      <section className="mb-12">
        <p className="text-[10px] font-bold tracking-[0.2em] uppercase text-text-low mb-5">How it works</p>
        <div className="grid sm:grid-cols-3 gap-4">
          {STEPS.map((step, i) => (
            <div key={i} className="bg-surface rounded-xl border border-outline p-5 flex items-start gap-4 shadow-sm hover:shadow-md transition-shadow">
              <div className="shrink-0 flex flex-col items-center gap-1.5">
                <div className="w-9 h-9 bg-primary/10 rounded-lg flex items-center justify-center text-primary">
                  {step.icon}
                </div>
                <span className="text-[9px] font-black text-text-low tracking-widest">{String(i + 1).padStart(2, '0')}</span>
              </div>
              <div>
                <h3 className="font-semibold text-text-high text-sm">{step.title}</h3>
                <p className="text-xs text-text-medium mt-1 leading-relaxed">{step.desc}</p>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* Available services */}
      <section>
        <p className="text-[10px] font-bold tracking-[0.2em] uppercase text-text-low mb-5">Services available</p>
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
          {SERVICES.map((service, i) => (
            <div
              key={i}
              className="bg-surface rounded-xl border border-outline p-5 text-center hover:border-primary/40 hover:shadow-md transition-all cursor-default shadow-sm"
            >
              <div className="text-2xl mb-2">{service.icon}</div>
              <p className="text-xs font-semibold text-text-medium">{service.label}</p>
            </div>
          ))}
        </div>
      </section>
    </div>
  );
}
