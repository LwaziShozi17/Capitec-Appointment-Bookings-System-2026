import { useState } from 'react';
import type { AxiosError } from 'axios';
import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';


export default function RegisterPage() {
  const [form, setForm] = useState({
    firstName: '',
    lastName: '',
    email: '',
    password: '',
    phoneNumber: '',
  });
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const { register } = useAuth();
  const navigate = useNavigate();

  const validate = (): string => {
    if (!form.firstName.trim()) return 'First name is required';
    if (!form.lastName.trim()) return 'Last name is required';
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(form.email.trim())) return 'Please enter a valid email address';
    const strongPassword = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$/;
    if (!strongPassword.test(form.password)) {
      return 'Password must be at least 8 characters with uppercase, lowercase, digit, and special character';
    }
    return '';
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const validationError = validate();
    if (validationError) {
      setError(validationError);
      return;
    }
    setError('');
    setLoading(true);
    try {
      await register({
        firstName: form.firstName.trim(),
        lastName: form.lastName.trim(),
        email: form.email.trim().toLowerCase(),
        password: form.password,
        phoneNumber: form.phoneNumber.trim() || undefined,
      });
      navigate('/');
    } catch (err) {
      const data = (err as AxiosError<{ message?: string; error?: string; details?: Record<string, string> }>).response?.data;
      let message = data?.message;
      if (!message && data?.details) {
        message = Object.values(data.details).join(', ');
      }
      if (!message && data?.error) {
        message = data.error;
      }
      if (!message && err instanceof Error) {
        message = err.message;
      }
      setError(message || 'Registration failed. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  const update = (field: string) => (e: React.ChangeEvent<HTMLInputElement>) =>
    setForm((prev) => ({ ...prev, [field]: e.target.value }));

  return (
    <div className="min-h-[80vh] flex items-center justify-center">
      <div className="w-full max-w-md">
        <div className="text-center mb-7">
          <Link to="/" className="inline-flex items-center gap-2 mb-5">
            <div className="w-6 h-6 bg-primary-dark rounded-md flex items-center justify-center">
              <span className="text-white font-black text-[10px]">C</span>
            </div>
            <span className="text-sm font-bold text-text-high">
              Capitec <span className="text-primary font-medium">Bookings</span>
            </span>
          </Link>
          <h1 className="text-2xl font-bold text-text-high">Create account</h1>
          <p className="text-sm text-text-medium mt-1">Book your branch appointment online</p>
        </div>

        <div className="bg-surface rounded-2xl shadow-sm border border-outline p-8">
          {error && (
            <div role="alert" className="mb-4 p-3 bg-error/10 border border-error/30 rounded-lg text-sm text-error">
              {error}
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-4" noValidate>
            <div className="grid grid-cols-2 gap-3">
              <div>
                <label htmlFor="reg-firstname" className="block text-sm font-medium text-text-medium mb-1">First name</label>
                <input
                  id="reg-firstname"
                  type="text"
                  value={form.firstName}
                  onChange={update('firstName')}
                  required
                  aria-required="true"
                  className="w-full px-3 py-2 border border-outline rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none"
                />
              </div>
              <div>
                <label htmlFor="reg-lastname" className="block text-sm font-medium text-text-medium mb-1">Last name</label>
                <input
                  id="reg-lastname"
                  type="text"
                  value={form.lastName}
                  onChange={update('lastName')}
                  required
                  aria-required="true"
                  className="w-full px-3 py-2 border border-outline rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none"
                />
              </div>
            </div>
            <div>
              <label htmlFor="reg-email" className="block text-sm font-medium text-text-medium mb-1">Email</label>
              <input
                id="reg-email"
                type="email"
                value={form.email}
                onChange={update('email')}
                required
                aria-required="true"
                className="w-full px-3 py-2 border border-outline rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none"
              />
            </div>
            <div>
              <label htmlFor="reg-password" className="block text-sm font-medium text-text-medium mb-1">Password</label>
              <input
                id="reg-password"
                type="password"
                value={form.password}
                onChange={update('password')}
                required
                aria-required="true"
                aria-describedby="password-hint"
                minLength={8}
                className="w-full px-3 py-2 border border-outline rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none"
              />
              <p id="password-hint" className="text-xs text-text-low mt-1">
                Min 8 chars, 1 uppercase, 1 digit, 1 special character
              </p>
            </div>
            <div>
              <label htmlFor="reg-phone" className="block text-sm font-medium text-text-medium mb-1">Phone (optional)</label>
              <input
                id="reg-phone"
                type="tel"
                value={form.phoneNumber}
                onChange={update('phoneNumber')}
                className="w-full px-3 py-2 border border-outline rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none"
                placeholder="082 123 4567"
              />
            </div>
            <button
              type="submit"
              disabled={loading}
              className="w-full py-2.5 bg-primary text-white rounded-lg font-medium hover:bg-primary-dark disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
            >
              {loading ? 'Creating account...' : 'Create account'}
            </button>
          </form>

          <p className="text-center text-sm text-text-medium mt-6">
            Already have an account?{' '}
            <Link to="/login" className="text-primary hover:text-primary-dark font-medium">
              Sign in
            </Link>
          </p>
        </div>
      </div>
    </div>
  );
}
