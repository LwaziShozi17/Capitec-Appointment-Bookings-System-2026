// Re-export from the real implementation. This file exists because TypeScript's
// module resolver picks .ts before .tsx on case-insensitive filesystems.
export * from './AuthContext.tsx';
