export interface Branch {
  id: number;
  name: string;
  code: string;
  address: string;
  province: string;
  latitude: number;
  longitude: number;
  operatingHours: OperatingHours[];
}

export interface OperatingHours {
  dayOfWeek: string;
  openTime: string | null;
  closeTime: string | null;
  closed: boolean;
}

export interface ServiceType {
  id: number;
  name: string;
  description: string;
  durationMinutes: number;
  requiredDocuments: string;
}

export interface AppointmentSlot {
  id: number;
  branchId: number;
  date: string;
  startTime: string;
  endTime: string;
  status: 'AVAILABLE' | 'BOOKED' | 'BLOCKED';
}

export interface Appointment {
  id: number;
  referenceNumber: string;
  userId: string;
  customerName: string;
  customerEmail: string;
  customerPhone: string;
  status: AppointmentStatus;
  branchName: string;
  branchAddress: string;
  serviceName: string;
  date: string;
  startTime: string;
  endTime: string;
  createdAt: string;
}

export type AppointmentStatus =
  | 'PENDING'
  | 'CONFIRMED'
  | 'IN_PROGRESS'
  | 'COMPLETED'
  | 'CANCELLED';

export interface AuthResponse {
  token: string;
  email: string;
  name: string;
  role: string;
}

export interface User {
  email: string;
  name: string;
  role: string;
  token: string;
}