import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import type { AxiosInstance } from 'axios';
import api from '../services/api';
import { tokenStore } from '../services/tokenStore';

type InterceptorHandlers = { handlers: Array<{ fulfilled: (v: unknown) => unknown; rejected: (e: unknown) => unknown }> };
const requestHandlers = (api as unknown as AxiosInstance & { interceptors: { request: InterceptorHandlers; response: InterceptorHandlers } }).interceptors.request.handlers;
const responseHandlers = (api as unknown as AxiosInstance & { interceptors: { request: InterceptorHandlers; response: InterceptorHandlers } }).interceptors.response.handlers;

describe('api service', () => {
  beforeEach(() => {
    localStorage.clear();
    tokenStore.set(null);
  });

  afterEach(() => {
    tokenStore.set(null);
  });

  it('has baseURL set to /api/v1', () => {
    expect(api.defaults.baseURL).toBe('/api/v1');
  });

  it('adds auth header when token is in tokenStore', async () => {
    tokenStore.set('test-token');

    const config = { headers: {} as Record<string, string> };
    const result = await requestHandlers[0].fulfilled(config) as typeof config;

    expect(result.headers.Authorization).toBe('Bearer test-token');
  });

  it('does not add auth header when no token', async () => {
    const config = { headers: {} as Record<string, string> };
    const result = await requestHandlers[0].fulfilled(config) as typeof config;

    expect(result.headers.Authorization).toBeUndefined();
  });

  it('rejects with network error message when no response', async () => {
    const networkError = new Error('Network Error');
    await expect(responseHandlers[0].rejected(networkError)).rejects.toThrow('Network error — please check your connection');
  });

  it('redirects to login on 401', async () => {
    Object.defineProperty(window, 'location', { value: { href: '' }, writable: true });
    window.location.href = '';

    const error = { response: { status: 401 } };
    try { await responseHandlers[0].rejected(error); } catch { /* expected */ }

    expect(window.location.href).toBe('/login');
  });
});