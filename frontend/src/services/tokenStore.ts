// Token stored in memory only — never written to localStorage or sessionStorage
let _token: string | null = null;

export const tokenStore = {
  set: (token: string | null) => { _token = token; },
  get: () => _token,
};
