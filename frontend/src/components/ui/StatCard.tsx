interface StatCardProps {
  label: string;
  value: number;
  icon: React.ReactNode;
  color: 'red' | 'amber' | 'blue' | 'green' | 'purple' | 'gray';
}

const COLOR_MAP: Record<StatCardProps['color'], { bg: string; icon: string; text: string }> = {
  red:    { bg: 'bg-primary/10',             icon: 'bg-primary/20 text-primary',              text: 'text-primary' },
  amber:  { bg: 'bg-warning/10',             icon: 'bg-warning/20 text-warning',               text: 'text-warning' },
  blue:   { bg: 'bg-info/10',                icon: 'bg-info/20 text-info',                     text: 'text-info' },
  green:  { bg: 'bg-success/10',             icon: 'bg-success/20 text-success',               text: 'text-success' },
  purple: { bg: 'bg-primary-container/30',   icon: 'bg-primary-container text-primary-dark',   text: 'text-primary-dark' },
  gray:   { bg: 'bg-surface-background',     icon: 'bg-surface-dim text-text-medium',          text: 'text-text-medium' },
};

export default function StatCard({ label, value, icon, color }: StatCardProps) {
  const c = COLOR_MAP[color];
  return (
    <div className={`rounded-2xl border border-outline p-5 flex items-center gap-4 ${c.bg}`}>
      <div className={`w-11 h-11 rounded-xl flex items-center justify-center shrink-0 ${c.icon}`}>
        {icon}
      </div>
      <div>
        <p className="text-xs text-text-medium font-medium uppercase tracking-wide">{label}</p>
        <p className={`text-2xl font-bold mt-0.5 ${c.text}`}>{value}</p>
      </div>
    </div>
  );
}
