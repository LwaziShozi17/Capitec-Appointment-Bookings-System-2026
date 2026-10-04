import { useState } from 'react';
import type { AxiosError } from 'axios';
import { Link, useNavigate, useSearchParams } from 'react-router-dom';
import api from '../services/api';

export default function ResetPasswordPage() {
  const [searchParams] = useSearchParams();
  const token = searchParams.get('token') ?? '';
  const navigate = useNavigate();

  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');

    if (newPassword !== confirmPassword) {
      setError('Passwords do not match.');
      return;
    }
    if (newPassword.length < 8) {
      setError('Password must be at least 8 characters.');
      return;
    }

    setLoading(true);
    try {
      await api.post('/auth/reset-password', { token, newPassword });
      setSuccess(true);
      setTimeout(() => navigate('/login'), 3000);
    } catch (err) {
      const message = (err as AxiosError<{ message?: string }>).response?.data?.message;
      setError(message || 'Failed to reset password. The link may have expired.');
    } finally {
      setLoading(false);
    }
  };

  if (!token) {
    return (
      <div className="min-h-[80vh] flex items-center justify-center">
        <div className="w-full max-w-md text-center">
          <div className="bg-surface rounded-2xl shadow-sm border border-outline p-8 space-y-4">
            <p className="text-sm text-error">Invalid reset link. Please request a new one.</p>
            <Link to="/forgot-password" className="text-sm text-primary hover:text-primary-dark font-medium">
              Request password reset
            </Link>
          </div>
        </div>
      </div>
    );
  }

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
          <h1 className="text-2xl font-bold text-text-high">Reset password</h1>
          <p className="text-sm text-text-medium mt-1">Enter your new password below</p>
        </div>

        <div className="bg-surface rounded-2xl shadow-sm border border-outline p-8">
          {success ? (
            <div className="text-center space-y-4">
              <div className="w-12 h-12 bg-success/10 rounded-full flex items-center justify-center mx-auto">
                <svg className="w-6 h-6 text-success" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
                </svg>
              </div>
              <p className="text-sm text-text-medium">
                Your password has been reset. Redirecting to sign in...
              </p>
              <Link to="/login" className="inline-block text-sm text-primary hover:text-primary-dark font-medium">
                Sign in now
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
                  <label htmlFor="new-password" className="block text-sm font-medium text-text-medium mb-1">
                    New password
                  </label>
                  <input
                    id="new-password"
                    type="password"
                    value={newPassword}
                    onChange={(e) => setNewPassword(e.target.value)}
                    required
                    aria-required="true"
                    minLength={8}
                    className="w-full px-3 py-2 border border-outline rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none"
                    placeholder="Min. 8 characters"
                  />
                </div>
                <div>
                  <label htmlFor="confirm-password" className="block text-sm font-medium text-text-medium mb-1">
                    Confirm password
                  </label>
                  <input
                    id="confirm-password"
                    type="password"
                    value={confirmPassword}
                    onChange={(e) => setConfirmPassword(e.target.value)}
                    required
                    aria-required="true"
                    className="w-full px-3 py-2 border border-outline rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none"
                    placeholder="Repeat your new password"
                  />
                </div>
                <button
                  type="submit"
                  disabled={loading}
                  className="w-full py-2.5 bg-primary text-white rounded-lg font-medium hover:bg-primary-dark disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
                >
                  {loading ? 'Resetting...' : 'Reset password'}
                </button>
              </form>

              <p className="text-center text-sm text-text-medium mt-6">
                <Link to="/login" className="text-primary hover:text-primary-dark font-medium">
                  Back to sign in
                </Link>
              </p>
            </>
          )}
        </div>
      </div>
    </div>
  );
}
