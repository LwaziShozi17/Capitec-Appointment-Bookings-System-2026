import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../services/api';
import { SkeletonCard } from '../components/ui/Skeleton';
import type { Branch } from '../types';

function isOpenNow(branch: Branch): boolean {
  if (!branch.operatingHours?.length) return false;
  const now = new Date();
  const dayNames = ['SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY'];
  const today = dayNames[now.getDay()];
  const hours = branch.operatingHours.find((h) => h.dayOfWeek === today);
  if (!hours || hours.closed || !hours.openTime || !hours.closeTime) return false;
  const [oh, om] = hours.openTime.split(':').map(Number);
  const [ch, cm] = hours.closeTime.split(':').map(Number);
  const nowMins = now.getHours() * 60 + now.getMinutes();
  return nowMins >= oh * 60 + om && nowMins < ch * 60 + cm;
}

export default function BranchesPage() {
  const [branches, setBranches] = useState<Branch[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedProvince, setSelectedProvince] = useState<string>('');
  const navigate = useNavigate();

  useEffect(() => {
    api.get<Branch[]>('/branches').then(({ data }) => {
      setBranches(data);
      setLoading(false);
    });
  }, []);

  if (loading) {
    return (
      <div>
        <div className="mb-8">
          <h1 className="text-2xl font-bold text-text-high">Select a Branch</h1>
          <p className="text-text-medium mt-1">Choose a Capitec branch for your appointment</p>
        </div>
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
          {Array.from({ length: 6 }).map((_, i) => <SkeletonCard key={i} />)}
        </div>
      </div>
    );
  }

  const provinces = [...new Set(branches.map((b) => b.province))].sort();
  const filtered = selectedProvince
    ? branches.filter((b) => b.province === selectedProvince)
    : branches;

  const countByProvince = (p: string) => branches.filter((b) => b.province === p).length;

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-2xl font-bold text-text-high">Select a Branch</h1>
        <p className="text-text-medium mt-1">Choose a Capitec branch for your appointment</p>
      </div>

      {/* Province filter */}
      <div className="flex gap-2 mb-6 flex-wrap">
        <button
          onClick={() => setSelectedProvince('')}
          className={`px-3 py-1.5 text-sm rounded-full border transition-colors font-medium ${
            !selectedProvince
              ? 'border-primary bg-primary text-white'
              : 'border-outline text-text-medium hover:border-outline bg-surface'
          }`}
        >
          All ({branches.length})
        </button>
        {provinces.map((province) => (
          <button
            key={province}
            onClick={() => setSelectedProvince(province)}
            className={`px-3 py-1.5 text-sm rounded-full border transition-colors font-medium ${
              selectedProvince === province
                ? 'border-primary bg-primary text-white'
                : 'border-outline text-text-medium hover:border-outline bg-surface'
            }`}
          >
            {province} ({countByProvince(province)})
          </button>
        ))}
      </div>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
        {filtered.map((branch) => {
          const open = isOpenNow(branch);
          return (
            <div
              key={branch.id}
              onClick={() => navigate(`/book/${branch.id}`)}
              className="group bg-surface rounded-2xl border border-outline p-6 hover:border-primary/50 hover:shadow-lg transition-all cursor-pointer shadow-sm"
            >
              <div className="flex items-start justify-between mb-4">
                <div className="flex-1 min-w-0">
                  <h3 className="font-bold text-text-high group-hover:text-primary transition-colors truncate">
                    {branch.name}
                  </h3>
                  <div className="flex items-start gap-1 mt-1">
                    <svg className="w-3.5 h-3.5 text-text-low mt-0.5 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                    </svg>
                    <p className="text-sm text-text-medium">{branch.address}</p>
                  </div>
                </div>
                <span className="text-xs bg-surface-dim text-text-medium px-2 py-1 rounded-lg font-mono ml-2 shrink-0">
                  {branch.code}
                </span>
              </div>

              <div className="flex items-center justify-between pt-4 border-t border-outline">
                <span className="text-xs text-primary font-semibold bg-primary/10 px-2.5 py-1 rounded-full">
                  {branch.province}
                </span>
                <div className="flex items-center gap-3">
                  <div className="flex items-center gap-1.5">
                    <span className={`w-2 h-2 rounded-full ${open ? 'bg-success' : 'bg-outline'}`} />
                    <span className={`text-xs font-medium ${open ? 'text-success' : 'text-text-low'}`}>
                      {open ? 'Open now' : 'Closed'}
                    </span>
                  </div>
                  <span className="text-xs text-primary font-semibold opacity-0 group-hover:opacity-100 transition-opacity">
                    Book now →
                  </span>
                </div>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}
