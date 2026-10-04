import { useState } from 'react';
import type { AxiosError } from 'axios';
import { Link } from 'react-router-dom';
import api from '../services/api';

export default function ForgotPasswordPage() {
  const [email, setEmail] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [submitted, setSubmitted] = useState(false);
  const [devResetLink, setDevResetLink] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    try {
      const res = await api.post<{ message: string; resetToken?: string }>('/auth/forgot-password', { email });
      setSubmitted(true);
      // Dev mode: the backend logs the token; surface a direct link here for convenience
      if (res.data.resetToken) {
        setDevResetLink(`/reset-password?token=${res.data.resetToken}`);
      }
    } catch (err) {
      const message = (err as AxiosError<{ message?: string }>).response?.data?.message;
      setError(message || 'Something went wrong. Please try again.');
    } finally {
      setLoading(false);
    }
  };

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
          <h1 className="text-2xl font-bold text-text-high">Forgot password</h1>
          <p className="text-sm text-text-medium mt-1">
            Enter your email and we'll send you a reset link
          </p>
        </div>

        <div className="bg-surface rounded-2xl shadow-sm border border-outline p-8">
          {submitted ? (
            <div className="text-center space-y-4">
              <div className="w-12 h-12 bg-success/10 rounded-full flex items-center justify-center mx-auto">
                <svg className="w-6 h-6 text-success" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                </svg>
              </div>
              <p className="text-sm text-text-medium">
                If <span className="font-medium text-text-high">{email}</span> is registered, a password
                reset link has been sent.
              </p>
              {devResetLink && (
                <div className="mt-3 p-3 bg-warning/10 border border-warning/30 rounded-lg text-left">
                  <p className="text-xs font-medium text-warning mb-1">Dev mode — use this link directly:</p>
                  <Link to={devResetLink} className="text-xs text-primary hover:underline break-all">
                    {window.location.origin}{devResetLink}
                  </Link>
                </div>
              )}
              <Link
                to="/login"
                className="inline-block mt-2 text-sm text-primary hover:text-primary-dark font-medium"
              >
                Back to sign in
              </Link>
            </div>
          ) : (
            <>
              {error && (
                <div role="alert" className="mb-4 p-3 bg-error/10 border border-error/30 rounded-lg text-sm text-error">
                  {error}
                </div>
              )}

              <form onSubmit={handleSubmit} className="space-y-4" noValidate>
                <div>
                  <label htmlFor="forgot-email" className="block text-sm font-medium text-text-medium mb-1">
                    Email
                  </label>
                  <input
                    id="forgot-email"
                    type="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    required
                    aria-required="true"
                    className="w-full px-3 py-2 border border-outline rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none"
                    placeholder="you@example.com"
                  />
                </div>
                <button
                  type="submit"
                  disabled={loading}
                  className="w-full py-2.5 bg-primary text-white rounded-lg font-medium hover:bg-primary-dark disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
                >
                  {loading ? 'Sending...' : 'Send reset link'}
                </button>
              </form>

              <p className="text-center text-sm text-text-medium mt-6">
                Remember your password?{' '}
                <Link to="/login" className="text-primary hover:text-primary-dark font-medium">
                  Sign in
                </Link>
              </p>
            </>
          )}
        </div>
      </div>
    </div>
  );
}
