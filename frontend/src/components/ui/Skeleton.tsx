interface SkeletonProps {
  className?: string;
}

export function Skeleton({ className = '' }: SkeletonProps) {
  return (
    <div className={`animate-pulse bg-surface-dim rounded-lg ${className}`} />
  );
}

export function SkeletonCard() {
  return (
    <div className="bg-surface rounded-2xl border border-outline p-6 space-y-3">
      <div className="flex items-center justify-between">
        <Skeleton className="h-4 w-1/3" />
        <Skeleton className="h-5 w-16 rounded-full" />
      </div>
      <Skeleton className="h-3 w-1/2" />
      <Skeleton className="h-3 w-2/5" />
      <div className="pt-3 border-t border-outline flex justify-between">
        <Skeleton className="h-3 w-1/4" />
        <Skeleton className="h-3 w-16" />
      </div>
    </div>
  );
}

export function SkeletonSlotGrid() {
  return (
    <div className="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-5 gap-2">
      {Array.from({ length: 20 }).map((_, i) => (
        <Skeleton key={i} className="h-12" />
      ))}
    </div>
  );
}

export function SkeletonRow() {
  return (
    <div className="bg-surface rounded-xl border border-outline p-5 space-y-2">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <Skeleton className="h-5 w-20 rounded-full" />
          <Skeleton className="h-4 w-32" />
        </div>
        <div className="flex gap-2">
          <Skeleton className="h-7 w-16 rounded-lg" />
          <Skeleton className="h-7 w-16 rounded-lg" />
        </div>
      </div>
      <Skeleton className="h-3 w-2/3" />
    </div>
  );
}
