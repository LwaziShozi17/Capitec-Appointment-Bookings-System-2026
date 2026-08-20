-- Capitec Branches: 5 per province (9 provinces = 45 branches)

-- GAUTENG
INSERT INTO branches (id, name, code, address, province, latitude, longitude) VALUES
(1, 'Capitec Sandton City', 'CAP-GP-SDN', '163 5th Street, Sandton, 2196', 'Gauteng', -26.1076, 28.0567),
(2, 'Capitec Rosebank', 'CAP-GP-RSB', 'The Zone, 177 Oxford Road, Rosebank, 2196', 'Gauteng', -26.1452, 28.0445),
(3, 'Capitec Menlyn Park', 'CAP-GP-MNL', 'Atterbury Road, Menlyn, Pretoria, 0181', 'Gauteng', -25.7825, 28.2770),
(4, 'Capitec Mall of Africa', 'CAP-GP-MOA', 'Lone Creek Crescent, Waterfall City, Midrand, 1685', 'Gauteng', -26.0173, 28.1075),
(5, 'Capitec Eastgate', 'CAP-GP-EGT', '43 Bradford Road, Bedfordview, 2007', 'Gauteng', -26.1817, 28.1183);

-- WESTERN CAPE
INSERT INTO branches (id, name, code, address, province, latitude, longitude) VALUES
(6, 'Capitec V&A Waterfront', 'CAP-WC-VNA', 'Shop 148, Victoria Wharf, V&A Waterfront, Cape Town, 8001', 'Western Cape', -33.9030, 18.4207),
(7, 'Capitec Canal Walk', 'CAP-WC-CNW', 'Century Boulevard, Century City, Cape Town, 7441', 'Western Cape', -33.8934, 18.5124),
(8, 'Capitec Tyger Valley', 'CAP-WC-TGV', 'Willie van Schoor Drive, Bellville, 7530', 'Western Cape', -33.8714, 18.6343),
(9, 'Capitec Stellenbosch', 'CAP-WC-STB', 'Eikestad Mall, Andringa Street, Stellenbosch, 7600', 'Western Cape', -33.9346, 18.8603),
(10, 'Capitec George', 'CAP-WC-GRG', 'Garden Route Mall, Knysna Road, George, 6529', 'Western Cape', -33.9858, 22.4128);

-- KWAZULU-NATAL
INSERT INTO branches (id, name, code, address, province, latitude, longitude) VALUES
(11, 'Capitec Gateway', 'CAP-KZN-GTW', 'Gateway Theatre of Shopping, 1 Palm Boulevard, Umhlanga, 4319', 'KwaZulu-Natal', -29.7283, 31.0694),
(12, 'Capitec Pavilion', 'CAP-KZN-PAV', 'Jack Martens Drive, Westville, 3629', 'KwaZulu-Natal', -29.8490, 30.9278),
(13, 'Capitec Ballito', 'CAP-KZN-BLT', 'Ballito Lifestyle Centre, Ballito, 4420', 'KwaZulu-Natal', -29.5390, 31.2140),
(14, 'Capitec Pietermaritzburg', 'CAP-KZN-PMB', 'Liberty Midlands Mall, Sanctuary Road, PMB, 3201', 'KwaZulu-Natal', -29.5876, 30.3878),
(15, 'Capitec Richards Bay', 'CAP-KZN-RCB', 'Boardwalk Inkwazi Mall, Richards Bay, 3900', 'KwaZulu-Natal', -28.7653, 32.0587);

-- EASTERN CAPE
INSERT INTO branches (id, name, code, address, province, latitude, longitude) VALUES
(16, 'Capitec Baywest Mall', 'CAP-EC-BWM', 'Baywest Mall, Walker Drive, Gqeberha, 6001', 'Eastern Cape', -33.8688, 25.7328),
(17, 'Capitec Hemingways', 'CAP-EC-HMW', 'Hemingways Mall, Western Avenue, East London, 5247', 'Eastern Cape', -32.9752, 27.8931),
(18, 'Capitec Mthatha', 'CAP-EC-MTH', 'BT Ngebs City Mall, Mthatha, 5099', 'Eastern Cape', -31.5889, 28.7842),
(19, 'Capitec Grahamstown', 'CAP-EC-GHT', 'Peppergrove Mall, African Street, Makhanda, 6139', 'Eastern Cape', -33.3115, 26.5231),
(20, 'Capitec Queenstown', 'CAP-EC-QTN', 'Queenstown Mall, Cathcart Road, Queenstown, 5319', 'Eastern Cape', -31.8975, 26.8756);

-- FREE STATE
INSERT INTO branches (id, name, code, address, province, latitude, longitude) VALUES
(21, 'Capitec Mimosa Mall', 'CAP-FS-MIM', 'Mimosa Mall, Kellner Street, Bloemfontein, 9301', 'Free State', -29.1050, 26.1849),
(22, 'Capitec Loch Logan', 'CAP-FS-LLW', 'Loch Logan Waterfront, Henry Street, Bloemfontein, 9301', 'Free State', -29.1152, 26.2216),
(23, 'Capitec Welkom', 'CAP-FS-WLK', 'Goldfields Mall, Stateway, Welkom, 9459', 'Free State', -27.9800, 26.7206),
(24, 'Capitec Bethlehem', 'CAP-FS-BTH', 'Dihlabeng Mall, Muller Street, Bethlehem, 9700', 'Free State', -28.2292, 28.3075),
(25, 'Capitec Kroonstad', 'CAP-FS-KRN', 'Crossing Mall, Brand Street, Kroonstad, 9499', 'Free State', -27.6503, 27.2318);

-- MPUMALANGA
INSERT INTO branches (id, name, code, address, province, latitude, longitude) VALUES
(26, 'Capitec Riverside Mall', 'CAP-MP-RVM', 'Riverside Mall, Nelspruit, Mbombela, 1200', 'Mpumalanga', -25.4753, 30.9694),
(27, 'Capitec Highveld Mall', 'CAP-MP-HVM', 'Highveld Mall, Mandela Street, Witbank, 1035', 'Mpumalanga', -25.8767, 29.2330),
(28, 'Capitec Secunda', 'CAP-MP-SEC', 'Secunda Mall, PDP Kruger Street, Secunda, 2302', 'Mpumalanga', -26.5147, 29.1746),
(29, 'Capitec Middelburg', 'CAP-MP-MDB', 'Middelburg Mall, Walter Sisulu Street, Middelburg, 1050', 'Mpumalanga', -25.7748, 29.4643),
(30, 'Capitec White River', 'CAP-MP-WTR', 'White River Crossing, White River, 1240', 'Mpumalanga', -25.3340, 31.0086);

-- LIMPOPO
INSERT INTO branches (id, name, code, address, province, latitude, longitude) VALUES
(31, 'Capitec Mall of the North', 'CAP-LP-MON', 'Mall of the North, R81, Polokwane, 0699', 'Limpopo', -23.8793, 29.4639),
(32, 'Capitec Savannah Mall', 'CAP-LP-SAV', 'Savannah Mall, Nelson Mandela Drive, Polokwane, 0699', 'Limpopo', -23.9147, 29.4322),
(33, 'Capitec Thohoyandou', 'CAP-LP-THY', 'Thavhani Mall, Thohoyandou, 0950', 'Limpopo', -22.9506, 30.4833),
(34, 'Capitec Tzaneen', 'CAP-LP-TZN', 'Tzaneen Lifestyle Centre, Danie Joubert Street, Tzaneen, 0850', 'Limpopo', -23.8328, 30.1631),
(35, 'Capitec Mokopane', 'CAP-LP-MKP', 'Mokopane Mall, Nelson Mandela Drive, Mokopane, 0600', 'Limpopo', -24.1875, 29.0092);

-- NORTH WEST
INSERT INTO branches (id, name, code, address, province, latitude, longitude) VALUES
(36, 'Capitec Rustenburg', 'CAP-NW-RST', 'Waterfall Mall, Augrabies Avenue, Rustenburg, 0299', 'North West', -25.6585, 27.2374),
(37, 'Capitec Klerksdorp', 'CAP-NW-KLK', 'City Mall, OR Tambo Drive, Klerksdorp, 2571', 'North West', -26.8520, 26.6598),
(38, 'Capitec Potchefstroom', 'CAP-NW-POT', 'MooiRivier Mall, Govan Mbeki Drive, Potchefstroom, 2520', 'North West', -26.7172, 27.0918),
(39, 'Capitec Mahikeng', 'CAP-NW-MHK', 'Riverwalk Shopping Centre, Nelson Mandela Drive, Mahikeng, 2735', 'North West', -25.8543, 25.6465),
(40, 'Capitec Brits', 'CAP-NW-BRT', 'Hartbeespoort Mall, Brits, 0250', 'North West', -25.6322, 27.7738);

-- NORTHERN CAPE
INSERT INTO branches (id, name, code, address, province, latitude, longitude) VALUES
(41, 'Capitec Kimberley', 'CAP-NC-KMB', 'Diamond Pavilion Mall, Memorial Road, Kimberley, 8301', 'Northern Cape', -28.7282, 24.7499),
(42, 'Capitec Upington', 'CAP-NC-UPT', 'Kalahari Mall, Scott Street, Upington, 8800', 'Northern Cape', -28.4517, 21.2568),
(43, 'Capitec Kathu', 'CAP-NC-KTH', 'Kathu Mall, Hendrik van Eck Street, Kathu, 8446', 'Northern Cape', -27.6947, 23.0447),
(44, 'Capitec De Aar', 'CAP-NC-DAR', 'Emthanjeni Mall, Church Street, De Aar, 7000', 'Northern Cape', -30.6494, 24.0125),
(45, 'Capitec Springbok', 'CAP-NC-SPB', 'Springbok Mall, Voortrekker Street, Springbok, 8240', 'Northern Cape', -29.6681, 17.8834);

-- Operating Hours (Mon-Fri: 08:00-17:00, Sat: 08:00-13:00, Sun: Closed) for all 45 branches
INSERT INTO operating_hours (branch_id, day_of_week, open_time, close_time, closed)
SELECT b.id, 'MONDAY', '08:00', '17:00', false FROM branches b;
INSERT INTO operating_hours (branch_id, day_of_week, open_time, close_time, closed)
SELECT b.id, 'TUESDAY', '08:00', '17:00', false FROM branches b;
INSERT INTO operating_hours (branch_id, day_of_week, open_time, close_time, closed)
SELECT b.id, 'WEDNESDAY', '08:00', '17:00', false FROM branches b;
INSERT INTO operating_hours (branch_id, day_of_week, open_time, close_time, closed)
SELECT b.id, 'THURSDAY', '08:00', '17:00', false FROM branches b;
INSERT INTO operating_hours (branch_id, day_of_week, open_time, close_time, closed)
SELECT b.id, 'FRIDAY', '08:00', '17:00', false FROM branches b;
INSERT INTO operating_hours (branch_id, day_of_week, open_time, close_time, closed)
SELECT b.id, 'SATURDAY', '08:00', '13:00', false FROM branches b;
INSERT INTO operating_hours (branch_id, day_of_week, open_time, close_time, closed)
SELECT b.id, 'SUNDAY', NULL, NULL, true FROM branches b;

-- Service Types with required documents
INSERT INTO service_types (id, name, description, duration_minutes, required_documents) VALUES
(1, 'Account Opening', 'Open a new Capitec savings or transaction account', 30,
 'Valid South African ID or passport;Proof of residence (not older than 3 months);Proof of income (payslip or bank statement)'),
(2, 'Loan Consultation', 'Discuss personal loan or home loan options', 45,
 'Valid South African ID;Latest 3 months payslips;Latest 3 months bank statements;Proof of residence'),
(3, 'Card Collection', 'Collect a new or replacement bank card', 15,
 'Valid South African ID or passport;SMS or email notification of card availability'),
(4, 'Account Query', 'General account enquiries and statement requests', 20,
 'Valid South African ID;Account number or registered cellphone number'),
(5, 'Investment Consultation', 'Discuss fixed deposit or investment options', 45,
 'Valid South African ID;Proof of source of funds;Tax number (for investments over R50,000)'),
(6, 'Insurance Consultation', 'Funeral cover, credit life, or device insurance', 30,
 'Valid South African ID;Details of beneficiaries (names, ID numbers);Device IMEI number (for device insurance)'),
(7, 'Foreign Exchange', 'Buy or sell foreign currency for travel', 30,
 'Valid South African passport;Flight itinerary or booking confirmation;Proof of residence'),
(8, 'Business Account Opening', 'Open a Capitec Business account', 45,
 'Valid South African ID of all directors;Company registration documents (CIPC);Proof of business address;Business bank statements (if existing)');

-- South African Public Holidays 2026
INSERT INTO holidays (id, date, name, open, special_open_time, special_close_time) VALUES
(1, '2026-01-01', 'New Year''s Day', false, NULL, NULL),
(2, '2026-03-21', 'Human Rights Day', false, NULL, NULL),
(3, '2026-04-03', 'Good Friday', false, NULL, NULL),
(4, '2026-04-06', 'Family Day', false, NULL, NULL),
(5, '2026-04-27', 'Freedom Day', false, NULL, NULL),
(6, '2026-05-01', 'Workers'' Day', false, NULL, NULL),
(7, '2026-06-16', 'Youth Day', false, NULL, NULL),
(8, '2026-08-09', 'National Women''s Day', false, NULL, NULL),
(9, '2026-09-24', 'Heritage Day', false, NULL, NULL),
(10, '2026-12-16', 'Day of Reconciliation', false, NULL, NULL),
(11, '2026-12-25', 'Christmas Day', false, NULL, NULL),
(12, '2026-12-26', 'Day of Goodwill', false, NULL, NULL);

-- =============================================================
-- DEMO DATA: Appointment Slots + Appointments
-- 3 branches × 4 days × 8 time slots = 96 upcoming slots
-- Plus 4 past slots for appointment history
-- Demo user: user@capitec.co.za / User@123
-- Admin user: admin@capitec.co.za / Admin@123
-- =============================================================

-- Branch 1 – Sandton City (upcoming: Aug 5–7, Aug 10)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(1,  1, '2026-08-05', '08:00', '08:30', 'AVAILABLE', 0),
(2,  1, '2026-08-05', '09:00', '09:30', 'BOOKED',    0),
(3,  1, '2026-08-05', '10:00', '10:30', 'AVAILABLE', 0),
(4,  1, '2026-08-05', '11:00', '11:30', 'AVAILABLE', 0),
(5,  1, '2026-08-05', '13:00', '13:30', 'BOOKED',    0),
(6,  1, '2026-08-05', '14:00', '14:30', 'AVAILABLE', 0),
(7,  1, '2026-08-05', '15:00', '15:30', 'AVAILABLE', 0),
(8,  1, '2026-08-05', '16:00', '16:30', 'AVAILABLE', 0),
(9,  1, '2026-08-06', '08:00', '08:30', 'AVAILABLE', 0),
(10, 1, '2026-08-06', '09:00', '09:30', 'BOOKED',    0),
(11, 1, '2026-08-06', '10:00', '10:30', 'AVAILABLE', 0),
(12, 1, '2026-08-06', '11:00', '11:30', 'AVAILABLE', 0),
(13, 1, '2026-08-06', '13:00', '13:30', 'AVAILABLE', 0),
(14, 1, '2026-08-06', '14:00', '14:30', 'AVAILABLE', 0),
(15, 1, '2026-08-06', '15:00', '15:30', 'BOOKED',    0),
(16, 1, '2026-08-06', '16:00', '16:30', 'AVAILABLE', 0),
(17, 1, '2026-08-07', '08:00', '08:30', 'AVAILABLE', 0),
(18, 1, '2026-08-07', '09:00', '09:30', 'AVAILABLE', 0),
(19, 1, '2026-08-07', '10:00', '10:30', 'BOOKED',    0),
(20, 1, '2026-08-07', '11:00', '11:30', 'AVAILABLE', 0),
(21, 1, '2026-08-07', '13:00', '13:30', 'AVAILABLE', 0),
(22, 1, '2026-08-07', '14:00', '14:30', 'AVAILABLE', 0),
(23, 1, '2026-08-07', '15:00', '15:30', 'AVAILABLE', 0),
(24, 1, '2026-08-07', '16:00', '16:30', 'AVAILABLE', 0),
(25, 1, '2026-08-10', '08:00', '08:30', 'AVAILABLE', 0),
(26, 1, '2026-08-10', '09:00', '09:30', 'AVAILABLE', 0),
(27, 1, '2026-08-10', '10:00', '10:30', 'AVAILABLE', 0),
(28, 1, '2026-08-10', '11:00', '11:30', 'AVAILABLE', 0),
(29, 1, '2026-08-10', '13:00', '13:30', 'AVAILABLE', 0),
(30, 1, '2026-08-10', '14:00', '14:30', 'AVAILABLE', 0),
(31, 1, '2026-08-10', '15:00', '15:30', 'AVAILABLE', 0),
(32, 1, '2026-08-10', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 6 – V&A Waterfront (upcoming: Aug 5–7, Aug 10)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(33, 6, '2026-08-05', '08:00', '08:30', 'AVAILABLE', 0),
(34, 6, '2026-08-05', '09:00', '09:30', 'AVAILABLE', 0),
(35, 6, '2026-08-05', '10:00', '10:30', 'BOOKED',    0),
(36, 6, '2026-08-05', '11:00', '11:30', 'AVAILABLE', 0),
(37, 6, '2026-08-05', '13:00', '13:30', 'AVAILABLE', 0),
(38, 6, '2026-08-05', '14:00', '14:30', 'AVAILABLE', 0),
(39, 6, '2026-08-05', '15:00', '15:30', 'AVAILABLE', 0),
(40, 6, '2026-08-05', '16:00', '16:30', 'AVAILABLE', 0),
(41, 6, '2026-08-06', '08:00', '08:30', 'AVAILABLE', 0),
(42, 6, '2026-08-06', '09:00', '09:30', 'AVAILABLE', 0),
(43, 6, '2026-08-06', '10:00', '10:30', 'AVAILABLE', 0),
(44, 6, '2026-08-06', '11:00', '11:30', 'BOOKED',    0),
(45, 6, '2026-08-06', '13:00', '13:30', 'AVAILABLE', 0),
(46, 6, '2026-08-06', '14:00', '14:30', 'AVAILABLE', 0),
(47, 6, '2026-08-06', '15:00', '15:30', 'AVAILABLE', 0),
(48, 6, '2026-08-06', '16:00', '16:30', 'AVAILABLE', 0),
(49, 6, '2026-08-07', '08:00', '08:30', 'BOOKED',    0),
(50, 6, '2026-08-07', '09:00', '09:30', 'AVAILABLE', 0),
(51, 6, '2026-08-07', '10:00', '10:30', 'AVAILABLE', 0),
(52, 6, '2026-08-07', '11:00', '11:30', 'AVAILABLE', 0),
(53, 6, '2026-08-07', '13:00', '13:30', 'AVAILABLE', 0),
(54, 6, '2026-08-07', '14:00', '14:30', 'AVAILABLE', 0),
(55, 6, '2026-08-07', '15:00', '15:30', 'AVAILABLE', 0),
(56, 6, '2026-08-07', '16:00', '16:30', 'AVAILABLE', 0),
(57, 6, '2026-08-10', '08:00', '08:30', 'AVAILABLE', 0),
(58, 6, '2026-08-10', '09:00', '09:30', 'AVAILABLE', 0),
(59, 6, '2026-08-10', '10:00', '10:30', 'AVAILABLE', 0),
(60, 6, '2026-08-10', '11:00', '11:30', 'AVAILABLE', 0),
(61, 6, '2026-08-10', '13:00', '13:30', 'AVAILABLE', 0),
(62, 6, '2026-08-10', '14:00', '14:30', 'AVAILABLE', 0),
(63, 6, '2026-08-10', '15:00', '15:30', 'AVAILABLE', 0),
(64, 6, '2026-08-10', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 11 – Gateway (upcoming: Aug 5–7, Aug 10)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(65, 11, '2026-08-05', '08:00', '08:30', 'AVAILABLE', 0),
(66, 11, '2026-08-05', '09:00', '09:30', 'BOOKED',    0),
(67, 11, '2026-08-05', '10:00', '10:30', 'AVAILABLE', 0),
(68, 11, '2026-08-05', '11:00', '11:30', 'AVAILABLE', 0),
(69, 11, '2026-08-05', '13:00', '13:30', 'AVAILABLE', 0),
(70, 11, '2026-08-05', '14:00', '14:30', 'AVAILABLE', 0),
(71, 11, '2026-08-05', '15:00', '15:30', 'AVAILABLE', 0),
(72, 11, '2026-08-05', '16:00', '16:30', 'AVAILABLE', 0),
(73, 11, '2026-08-06', '08:00', '08:30', 'AVAILABLE', 0),
(74, 11, '2026-08-06', '09:00', '09:30', 'AVAILABLE', 0),
(75, 11, '2026-08-06', '10:00', '10:30', 'AVAILABLE', 0),
(76, 11, '2026-08-06', '11:00', '11:30', 'AVAILABLE', 0),
(77, 11, '2026-08-06', '13:00', '13:30', 'BOOKED',    0),
(78, 11, '2026-08-06', '14:00', '14:30', 'AVAILABLE', 0),
(79, 11, '2026-08-06', '15:00', '15:30', 'AVAILABLE', 0),
(80, 11, '2026-08-06', '16:00', '16:30', 'AVAILABLE', 0),
(81, 11, '2026-08-07', '08:00', '08:30', 'AVAILABLE', 0),
(82, 11, '2026-08-07', '09:00', '09:30', 'AVAILABLE', 0),
(83, 11, '2026-08-07', '10:00', '10:30', 'AVAILABLE', 0),
(84, 11, '2026-08-07', '11:00', '11:30', 'AVAILABLE', 0),
(85, 11, '2026-08-07', '13:00', '13:30', 'AVAILABLE', 0),
(86, 11, '2026-08-07', '14:00', '14:30', 'BOOKED',    0),
(87, 11, '2026-08-07', '15:00', '15:30', 'AVAILABLE', 0),
(88, 11, '2026-08-07', '16:00', '16:30', 'AVAILABLE', 0),
(89, 11, '2026-08-10', '08:00', '08:30', 'AVAILABLE', 0),
(90, 11, '2026-08-10', '09:00', '09:30', 'AVAILABLE', 0),
(91, 11, '2026-08-10', '10:00', '10:30', 'AVAILABLE', 0),
(92, 11, '2026-08-10', '11:00', '11:30', 'AVAILABLE', 0),
(93, 11, '2026-08-10', '13:00', '13:30', 'AVAILABLE', 0),
(94, 11, '2026-08-10', '14:00', '14:30', 'AVAILABLE', 0),
(95, 11, '2026-08-10', '15:00', '15:30', 'AVAILABLE', 0),
(96, 11, '2026-08-10', '16:00', '16:30', 'AVAILABLE', 0);

-- Past slots (for appointment history)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(97,  1, '2026-07-28', '09:00', '09:30', 'BOOKED', 0),
(98,  1, '2026-07-29', '10:00', '10:30', 'BOOKED', 0),
(99,  6, '2026-07-30', '11:00', '11:30', 'BOOKED', 0),
(100, 1, '2026-07-31', '14:00', '14:30', 'BOOKED', 0);

-- Demo Appointments
-- user@capitec.co.za: 3 CONFIRMED upcoming, 1 PENDING, 1 CANCELLED, 2 COMPLETED (history)
INSERT INTO appointments (id, user_id, slot_id, service_type_id, status, customer_name, customer_phone, customer_email, reference_number, created_at) VALUES
(1,  'user@capitec.co.za', 2,   1, 'CONFIRMED', 'Demo User', '0821234567', 'user@capitec.co.za', 'CAP-20260805-001', '2026-08-03 10:00:00'),
(2,  'user@capitec.co.za', 10,  2, 'CONFIRMED', 'Demo User', '0821234567', 'user@capitec.co.za', 'CAP-20260806-001', '2026-08-03 10:05:00'),
(3,  'user@capitec.co.za', 35,  3, 'CONFIRMED', 'Demo User', '0821234567', 'user@capitec.co.za', 'CAP-20260805-002', '2026-08-03 11:00:00'),
(4,  'user@capitec.co.za', 5,   6, 'PENDING',   'Demo User', '0821234567', 'user@capitec.co.za', 'CAP-20260805-003', '2026-08-04 08:00:00'),
(5,  'user@capitec.co.za', 66,  4, 'CANCELLED', 'Demo User', '0821234567', 'user@capitec.co.za', 'CAP-20260805-004', '2026-08-02 09:00:00'),
(6,  'user@capitec.co.za', 97,  1, 'COMPLETED', 'Demo User', '0821234567', 'user@capitec.co.za', 'CAP-20260728-001', '2026-07-25 10:00:00'),
(7,  'user@capitec.co.za', 99,  5, 'COMPLETED', 'Demo User', '0821234567', 'user@capitec.co.za', 'CAP-20260730-001', '2026-07-28 14:00:00');

-- admin@capitec.co.za: additional bookings to fill the calendar
INSERT INTO appointments (id, user_id, slot_id, service_type_id, status, customer_name, customer_phone, customer_email, reference_number, created_at) VALUES
(8,  'admin@capitec.co.za', 15,  1, 'CONFIRMED', 'System Admin', '0800102043', 'admin@capitec.co.za', 'CAP-20260806-002', '2026-08-03 12:00:00'),
(9,  'admin@capitec.co.za', 19,  2, 'CONFIRMED', 'System Admin', '0800102043', 'admin@capitec.co.za', 'CAP-20260807-001', '2026-08-03 12:05:00'),
(10, 'admin@capitec.co.za', 44,  3, 'CONFIRMED', 'System Admin', '0800102043', 'admin@capitec.co.za', 'CAP-20260806-003', '2026-08-03 12:10:00'),
(11, 'admin@capitec.co.za', 49,  7, 'CONFIRMED', 'System Admin', '0800102043', 'admin@capitec.co.za', 'CAP-20260807-002', '2026-08-03 12:15:00'),
(12, 'admin@capitec.co.za', 77,  8, 'CONFIRMED', 'System Admin', '0800102043', 'admin@capitec.co.za', 'CAP-20260806-004', '2026-08-03 12:20:00'),
(13, 'admin@capitec.co.za', 86,  1, 'CONFIRMED', 'System Admin', '0800102043', 'admin@capitec.co.za', 'CAP-20260807-003', '2026-08-03 12:25:00'),
(14, 'admin@capitec.co.za', 98,  4, 'COMPLETED', 'System Admin', '0800102043', 'admin@capitec.co.za', 'CAP-20260729-001', '2026-07-26 09:00:00'),
(15, 'admin@capitec.co.za', 100, 2, 'COMPLETED', 'System Admin', '0800102043', 'admin@capitec.co.za', 'CAP-20260731-001', '2026-07-29 08:00:00');