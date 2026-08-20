import { useState } from 'react';
import { Outlet, Link, useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

function NavLink({ to, children }: { to: string; children: React.ReactNode }) {
  const { pathname } = useLocation();
  const active = pathname === to || (to !== '/' && pathname.startsWith(to));
  return (
    <Link
      to={to}
      className={`text-sm font-medium transition-colors px-1 pb-0.5 border-b-2 ${
        active
          ? 'text-primary border-primary'
          : 'text-text-medium border-transparent hover:text-text-high hover:border-outline'
      }`}
    >
      {children}
    </Link>
  );
}

function Avatar({ name }: { name: string }) {
  const initials = name
    .split(' ')
    .slice(0, 2)
    .map((n) => n[0])
    .join('')
    .toUpperCase();
  return (
    <div className="w-8 h-8 rounded-full bg-primary flex items-center justify-center shrink-0">
      <span className="text-white text-xs font-bold">{initials}</span>
    </div>
  );
}

export default function Layout() {
  const { user, logout, isAdmin } = useAuth();
  const navigate = useNavigate();
  const [mobileOpen, setMobileOpen] = useState(false);

  const handleLogout = () => {
    logout();
    navigate('/login');
    setMobileOpen(false);
  };

  return (
    <div className="min-h-screen bg-surface-background">
      <a
        href="#main-content"
        className="sr-only focus:not-sr-only focus:absolute focus:top-2 focus:left-2 focus:z-50 focus:px-4 focus:py-2 focus:bg-primary focus:text-white focus:rounded"
      >
        Skip to main content
      </a>

      <nav className="bg-surface border-b border-outline shadow-sm sticky top-0 z-40" aria-label="Main navigation">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16 items-center">
            {/* Logo */}
            <div className="flex items-center gap-8">
              <Link to="/" className="flex items-center gap-2.5" onClick={() => setMobileOpen(false)}>
                <div className="w-8 h-8 bg-primary rounded-full flex items-center justify-center shadow-sm">
                  <span className="text-white font-bold text-sm">C</span>
                </div>
                <span className="font-bold text-text-high tracking-tight">Capitec Booking</span>
              </Link>

              {/* Desktop nav links */}
              {user && (
                <div className="hidden sm:flex items-center gap-6">
                  <NavLink to="/branches">Branches</NavLink>
                  <NavLink to="/appointments">My Appointments</NavLink>
                  {isAdmin && <NavLink to="/admin">Admin</NavLink>}
                </div>
              )}
            </div>

            {/* Right side */}
            <div className="flex items-center gap-3">
              {user ? (
                <>
                  <div className="hidden sm:flex items-center gap-2.5">
                    <Avatar name={user.name} />
                    <span className="text-sm text-text-medium font-medium">{user.name}</span>
                  </div>
                  <button
                    onClick={handleLogout}
                    className="hidden sm:block text-sm text-text-low hover:text-text-medium transition-colors"
                  >
                    Sign out
                  </button>
                </>
              ) : (
                <Link
                  to="/login"
                  className="hidden sm:block px-4 py-2 bg-primary text-white text-sm font-medium rounded-lg hover:bg-primary-dark transition-colors"
                >
                  Sign in
                </Link>
              )}

              {/* Hamburger (mobile) */}
              <button
                onClick={() => setMobileOpen((v) => !v)}
                className="sm:hidden p-2 rounded-lg hover:bg-surface-dim transition-colors"
                aria-label={mobileOpen ? 'Close menu' : 'Open menu'}
                aria-expanded={mobileOpen}
              >
                {mobileOpen ? (
                  <svg className="w-5 h-5 text-text-medium" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                  </svg>
                ) : (
                  <svg className="w-5 h-5 text-text-medium" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
                  </svg>
                )}
              </button>
            </div>
          </div>
        </div>

        {/* Mobile drawer */}
        {mobileOpen && (
          <div className="sm:hidden border-t border-outline bg-surface px-4 py-4 space-y-1">
            {user ? (
              <>
                <div className="flex items-center gap-2.5 pb-3 mb-2 border-b border-outline">
                  <Avatar name={user.name} />
                  <div>
                    <p className="text-sm font-medium text-text-high">{user.name}</p>
                    <p className="text-xs text-text-low">{user.email}</p>
                  </div>
                </div>
                <MobileNavLink to="/branches" onClick={() => setMobileOpen(false)}>Branches</MobileNavLink>
                <MobileNavLink to="/appointments" onClick={() => setMobileOpen(false)}>My Appointments</MobileNavLink>
                {isAdmin && (
                  <MobileNavLink to="/admin" onClick={() => setMobileOpen(false)}>Admin Dashboard</MobileNavLink>
                )}
                <button
                  onClick={handleLogout}
                  className="w-full text-left px-3 py-2.5 text-sm text-primary font-medium rounded-lg hover:bg-primary/10 transition-colors mt-2"
                >
                  Sign out
                </button>
              </>
            ) : (
              <>
                <MobileNavLink to="/login" onClick={() => setMobileOpen(false)}>Sign in</MobileNavLink>
                <MobileNavLink to="/register" onClick={() => setMobileOpen(false)}>Create account</MobileNavLink>
              </>
            )}
          </div>
        )}
      </nav>

      <main id="main-content" className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <Outlet />
      </main>
    </div>
  );
}

function MobileNavLink({
  to,
  children,
  onClick,
}: {
  to: string;
  children: React.ReactNode;
  onClick: () => void;
}) {
  const { pathname } = useLocation();
  const active = pathname === to || (to !== '/' && pathname.startsWith(to));
  return (
    <Link
      to={to}
      onClick={onClick}
      className={`block px-3 py-2.5 text-sm font-medium rounded-lg transition-colors ${
        active ? 'bg-primary/10 text-primary' : 'text-text-medium hover:bg-surface-background'
      }`}
    >
      {children}
    </Link>
  );
}
