import { Link } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

const STEPS = [
  {
    icon: (
      <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
      </svg>
    ),
    title: 'Choose a Branch',
    desc: 'Pick from Capitec branches across South Africa',
  },
  {
    icon: (
      <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
      </svg>
    ),
    title: 'Pick a Time',
    desc: 'Select your date and an available time slot',
  },
  {
    icon: (
      <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
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
      <section className="relative rounded-3xl overflow-hidden bg-gradient-to-br from-primary-dark via-primary to-primary-light px-8 py-16 text-white mb-12 shadow-lg">
        <div className="absolute inset-0 opacity-10">
          <div className="absolute top-0 right-0 w-96 h-96 rounded-full bg-surface translate-x-1/3 -translate-y-1/3" />
          <div className="absolute bottom-0 left-0 w-64 h-64 rounded-full bg-surface -translate-x-1/3 translate-y-1/3" />
        </div>
        <div className="relative max-w-2xl">
          <div className="inline-flex items-center gap-2 bg-surface/20 backdrop-blur-sm rounded-full px-3 py-1 text-xs font-medium mb-4">
            <span className="w-1.5 h-1.5 rounded-full bg-success"></span>
            Online booking available
          </div>
          <h1 className="text-4xl sm:text-5xl font-bold leading-tight">
            Book your Capitec<br />branch visit
          </h1>
          <p className="mt-4 text-primary-container text-lg max-w-md">
            Skip the queue. Schedule your branch appointment online and arrive at your confirmed time.
          </p>
          {user ? (
            <div className="mt-8 flex flex-wrap gap-3">
              <Link
                to="/branches"
                className="px-6 py-3 bg-surface text-primary rounded-xl font-semibold hover:bg-primary-container/30 transition-colors shadow-sm"
              >
                Book Appointment
              </Link>
              <Link
                to="/appointments"
                className="px-6 py-3 bg-surface/20 backdrop-blur-sm text-white rounded-xl font-semibold hover:bg-surface/30 transition-colors border border-white/30"
              >
                My Appointments
              </Link>
            </div>
          ) : (
            <div className="mt-8 flex flex-wrap gap-3">
              <Link
                to="/login"
                className="px-6 py-3 bg-surface text-primary rounded-xl font-semibold hover:bg-primary-container/30 transition-colors shadow-sm"
              >
                Sign In
              </Link>
              <Link
                to="/register"
                className="px-6 py-3 bg-surface/20 backdrop-blur-sm text-white rounded-xl font-semibold hover:bg-surface/30 transition-colors border border-white/30"
              >
                Create Account
              </Link>
            </div>
          )}
        </div>
      </section>

      {/* How it works */}
      <section className="mb-12">
        <h2 className="text-lg font-semibold text-text-high mb-5">How it works</h2>
        <div className="grid sm:grid-cols-3 gap-4">
          {STEPS.map((step, i) => (
            <div key={i} className="bg-surface rounded-2xl border border-outline p-6 flex items-start gap-4 shadow-sm">
              <div className="w-11 h-11 bg-primary/10 rounded-xl flex items-center justify-center text-primary shrink-0">
                {step.icon}
              </div>
              <div>
                <p className="text-xs font-semibold text-primary uppercase tracking-wide mb-1">Step {i + 1}</p>
                <h3 className="font-semibold text-text-high">{step.title}</h3>
                <p className="text-sm text-text-medium mt-1">{step.desc}</p>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* Available services */}
      <section>
        <h2 className="text-lg font-semibold text-text-high mb-5">Services available</h2>
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
          {SERVICES.map((service, i) => (
            <div
              key={i}
              className="bg-surface rounded-2xl border border-outline p-5 text-center hover:border-primary/30 hover:shadow-md transition-all cursor-default shadow-sm"
            >
              <div className="text-3xl mb-2">{service.icon}</div>
              <p className="text-sm font-medium text-text-medium">{service.label}</p>
            </div>
          ))}
        </div>
      </section>
    </div>
  );
}
