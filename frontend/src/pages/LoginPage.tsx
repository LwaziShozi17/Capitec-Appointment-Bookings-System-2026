import { useState } from 'react';
import type { AxiosError } from 'axios';
import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';


export default function LoginPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const { login } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    try {
      await login(email, password);
      navigate('/');
    } catch (err) {
      const message = (err as AxiosError<{ message?: string }>).response?.data?.message;
      setError(message || 'Login failed. Please try again.');
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
          <h1 className="text-2xl font-bold text-text-high">Welcome back</h1>
          <p className="text-sm text-text-medium mt-1">Sign in to your account</p>
        </div>

        <div className="bg-surface rounded-2xl shadow-sm border border-outline p-8">
          {error && (
            <div role="alert" className="mb-4 p-3 bg-error/10 border border-error/30 rounded-lg text-sm text-error">
              {error}
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-4" noValidate>
            <div>
              <label htmlFor="login-email" className="block text-sm font-medium text-text-medium mb-1">Email</label>
              <input
                id="login-email"
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                aria-required="true"
                className="w-full px-3 py-2 border border-outline rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none"
                placeholder="you@example.com"
              />
            </div>
            <div>
              <label htmlFor="login-password" className="block text-sm font-medium text-text-medium mb-1">Password</label>
              <input
                id="login-password"
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
                aria-required="true"
                className="w-full px-3 py-2 border border-outline rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none"
                placeholder="Enter your password"
              />
            </div>
            <button
              type="submit"
              disabled={loading}
              className="w-full py-2.5 bg-primary text-white rounded-lg font-medium hover:bg-primary-dark disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
            >
              {loading ? 'Signing in...' : 'Sign in'}
            </button>
          </form>

          <p className="text-center text-sm text-text-medium mt-6">
            Don't have an account?{' '}
            <Link to="/register" className="text-primary hover:text-primary-dark font-medium">
              Register
            </Link>
          </p>
        </div>
      </div>
    </div>
  );
}
