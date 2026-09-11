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

-- Branch 1 – Sandton City (upcoming: Sep 9–11, Sep 14)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(1,  1, '2026-09-09', '08:00', '08:30', 'AVAILABLE', 0),
(2,  1, '2026-09-09', '09:00', '09:30', 'BOOKED',    0),
(3,  1, '2026-09-09', '10:00', '10:30', 'AVAILABLE', 0),
(4,  1, '2026-09-09', '11:00', '11:30', 'AVAILABLE', 0),
(5,  1, '2026-09-09', '13:00', '13:30', 'BOOKED',    0),
(6,  1, '2026-09-09', '14:00', '14:30', 'AVAILABLE', 0),
(7,  1, '2026-09-09', '15:00', '15:30', 'AVAILABLE', 0),
(8,  1, '2026-09-09', '16:00', '16:30', 'AVAILABLE', 0),
(9,  1, '2026-09-10', '08:00', '08:30', 'AVAILABLE', 0),
(10, 1, '2026-09-10', '09:00', '09:30', 'BOOKED',    0),
(11, 1, '2026-09-10', '10:00', '10:30', 'AVAILABLE', 0),
(12, 1, '2026-09-10', '11:00', '11:30', 'AVAILABLE', 0),
(13, 1, '2026-09-10', '13:00', '13:30', 'AVAILABLE', 0),
(14, 1, '2026-09-10', '14:00', '14:30', 'AVAILABLE', 0),
(15, 1, '2026-09-10', '15:00', '15:30', 'BOOKED',    0),
(16, 1, '2026-09-10', '16:00', '16:30', 'AVAILABLE', 0),
(17, 1, '2026-09-11', '08:00', '08:30', 'AVAILABLE', 0),
(18, 1, '2026-09-11', '09:00', '09:30', 'AVAILABLE', 0),
(19, 1, '2026-09-11', '10:00', '10:30', 'BOOKED',    0),
(20, 1, '2026-09-11', '11:00', '11:30', 'AVAILABLE', 0),
(21, 1, '2026-09-11', '13:00', '13:30', 'AVAILABLE', 0),
(22, 1, '2026-09-11', '14:00', '14:30', 'AVAILABLE', 0),
(23, 1, '2026-09-11', '15:00', '15:30', 'AVAILABLE', 0),
(24, 1, '2026-09-11', '16:00', '16:30', 'AVAILABLE', 0),
(25, 1, '2026-09-14', '08:00', '08:30', 'AVAILABLE', 0),
(26, 1, '2026-09-14', '09:00', '09:30', 'AVAILABLE', 0),
(27, 1, '2026-09-14', '10:00', '10:30', 'AVAILABLE', 0),
(28, 1, '2026-09-14', '11:00', '11:30', 'AVAILABLE', 0),
(29, 1, '2026-09-14', '13:00', '13:30', 'AVAILABLE', 0),
(30, 1, '2026-09-14', '14:00', '14:30', 'AVAILABLE', 0),
(31, 1, '2026-09-14', '15:00', '15:30', 'AVAILABLE', 0),
(32, 1, '2026-09-14', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 6 – V&A Waterfront (upcoming: Sep 9–11, Sep 14)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(33, 6, '2026-09-09', '08:00', '08:30', 'AVAILABLE', 0),
(34, 6, '2026-09-09', '09:00', '09:30', 'AVAILABLE', 0),
(35, 6, '2026-09-09', '10:00', '10:30', 'BOOKED',    0),
(36, 6, '2026-09-09', '11:00', '11:30', 'AVAILABLE', 0),
(37, 6, '2026-09-09', '13:00', '13:30', 'AVAILABLE', 0),
(38, 6, '2026-09-09', '14:00', '14:30', 'AVAILABLE', 0),
(39, 6, '2026-09-09', '15:00', '15:30', 'AVAILABLE', 0),
(40, 6, '2026-09-09', '16:00', '16:30', 'AVAILABLE', 0),
(41, 6, '2026-09-10', '08:00', '08:30', 'AVAILABLE', 0),
(42, 6, '2026-09-10', '09:00', '09:30', 'AVAILABLE', 0),
(43, 6, '2026-09-10', '10:00', '10:30', 'AVAILABLE', 0),
(44, 6, '2026-09-10', '11:00', '11:30', 'BOOKED',    0),
(45, 6, '2026-09-10', '13:00', '13:30', 'AVAILABLE', 0),
(46, 6, '2026-09-10', '14:00', '14:30', 'AVAILABLE', 0),
(47, 6, '2026-09-10', '15:00', '15:30', 'AVAILABLE', 0),
(48, 6, '2026-09-10', '16:00', '16:30', 'AVAILABLE', 0),
(49, 6, '2026-09-11', '08:00', '08:30', 'BOOKED',    0),
(50, 6, '2026-09-11', '09:00', '09:30', 'AVAILABLE', 0),
(51, 6, '2026-09-11', '10:00', '10:30', 'AVAILABLE', 0),
(52, 6, '2026-09-11', '11:00', '11:30', 'AVAILABLE', 0),
(53, 6, '2026-09-11', '13:00', '13:30', 'AVAILABLE', 0),
(54, 6, '2026-09-11', '14:00', '14:30', 'AVAILABLE', 0),
(55, 6, '2026-09-11', '15:00', '15:30', 'AVAILABLE', 0),
(56, 6, '2026-09-11', '16:00', '16:30', 'AVAILABLE', 0),
(57, 6, '2026-09-14', '08:00', '08:30', 'AVAILABLE', 0),
(58, 6, '2026-09-14', '09:00', '09:30', 'AVAILABLE', 0),
(59, 6, '2026-09-14', '10:00', '10:30', 'AVAILABLE', 0),
(60, 6, '2026-09-14', '11:00', '11:30', 'AVAILABLE', 0),
(61, 6, '2026-09-14', '13:00', '13:30', 'AVAILABLE', 0),
(62, 6, '2026-09-14', '14:00', '14:30', 'AVAILABLE', 0),
(63, 6, '2026-09-14', '15:00', '15:30', 'AVAILABLE', 0),
(64, 6, '2026-09-14', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 11 – Gateway (upcoming: Sep 9–11, Sep 14)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(65, 11, '2026-09-09', '08:00', '08:30', 'AVAILABLE', 0),
(66, 11, '2026-09-09', '09:00', '09:30', 'AVAILABLE', 0),
(67, 11, '2026-09-09', '10:00', '10:30', 'AVAILABLE', 0),
(68, 11, '2026-09-09', '11:00', '11:30', 'AVAILABLE', 0),
(69, 11, '2026-09-09', '13:00', '13:30', 'AVAILABLE', 0),
(70, 11, '2026-09-09', '14:00', '14:30', 'AVAILABLE', 0),
(71, 11, '2026-09-09', '15:00', '15:30', 'AVAILABLE', 0),
(72, 11, '2026-09-09', '16:00', '16:30', 'AVAILABLE', 0),
(73, 11, '2026-09-10', '08:00', '08:30', 'AVAILABLE', 0),
(74, 11, '2026-09-10', '09:00', '09:30', 'AVAILABLE', 0),
(75, 11, '2026-09-10', '10:00', '10:30', 'AVAILABLE', 0),
(76, 11, '2026-09-10', '11:00', '11:30', 'AVAILABLE', 0),
(77, 11, '2026-09-10', '13:00', '13:30', 'BOOKED',    0),
(78, 11, '2026-09-10', '14:00', '14:30', 'AVAILABLE', 0),
(79, 11, '2026-09-10', '15:00', '15:30', 'AVAILABLE', 0),
(80, 11, '2026-09-10', '16:00', '16:30', 'AVAILABLE', 0),
(81, 11, '2026-09-11', '08:00', '08:30', 'AVAILABLE', 0),
(82, 11, '2026-09-11', '09:00', '09:30', 'AVAILABLE', 0),
(83, 11, '2026-09-11', '10:00', '10:30', 'AVAILABLE', 0),
(84, 11, '2026-09-11', '11:00', '11:30', 'AVAILABLE', 0),
(85, 11, '2026-09-11', '13:00', '13:30', 'AVAILABLE', 0),
(86, 11, '2026-09-11', '14:00', '14:30', 'BOOKED',    0),
(87, 11, '2026-09-11', '15:00', '15:30', 'AVAILABLE', 0),
(88, 11, '2026-09-11', '16:00', '16:30', 'AVAILABLE', 0),
(89, 11, '2026-09-14', '08:00', '08:30', 'AVAILABLE', 0),
(90, 11, '2026-09-14', '09:00', '09:30', 'AVAILABLE', 0),
(91, 11, '2026-09-14', '10:00', '10:30', 'AVAILABLE', 0),
(92, 11, '2026-09-14', '11:00', '11:30', 'AVAILABLE', 0),
(93, 11, '2026-09-14', '13:00', '13:30', 'AVAILABLE', 0),
(94, 11, '2026-09-14', '14:00', '14:30', 'AVAILABLE', 0),
(95, 11, '2026-09-14', '15:00', '15:30', 'AVAILABLE', 0),
(96, 11, '2026-09-14', '16:00', '16:30', 'AVAILABLE', 0);

-- Past slots (for appointment history)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(97,  1, '2026-07-28', '09:00', '09:30', 'BOOKED', 0),
(98,  1, '2026-07-29', '10:00', '10:30', 'BOOKED', 0),
(99,  6, '2026-07-30', '11:00', '11:30', 'BOOKED', 0),
(100, 1, '2026-07-31', '14:00', '14:30', 'BOOKED', 0);

-- Demo Appointments
-- user@capitec.co.za: 3 CONFIRMED upcoming, 1 PENDING, 1 CANCELLED, 2 COMPLETED (history)
INSERT INTO appointments (id, user_id, slot_id, service_type_id, status, customer_name, customer_phone, customer_email, reference_number, created_at) VALUES
(1,  'user@capitec.co.za', 2,   1, 'CONFIRMED', 'Demo User', '0821234567', 'user@capitec.co.za', 'CAP-20260909-001', '2026-09-05 10:00:00'),
(2,  'user@capitec.co.za', 10,  2, 'CONFIRMED', 'Demo User', '0821234567', 'user@capitec.co.za', 'CAP-20260910-001', '2026-09-05 10:05:00'),
(3,  'user@capitec.co.za', 35,  3, 'CONFIRMED', 'Demo User', '0821234567', 'user@capitec.co.za', 'CAP-20260909-002', '2026-09-05 11:00:00'),
(4,  'user@capitec.co.za', 5,   6, 'PENDING',   'Demo User', '0821234567', 'user@capitec.co.za', 'CAP-20260909-003', '2026-09-06 08:00:00'),
(5,  'user@capitec.co.za', 66,  4, 'CANCELLED', 'Demo User', '0821234567', 'user@capitec.co.za', 'CAP-20260909-004', '2026-09-04 09:00:00'),
(6,  'user@capitec.co.za', 97,  1, 'COMPLETED', 'Demo User', '0821234567', 'user@capitec.co.za', 'CAP-20260728-001', '2026-07-25 10:00:00'),
(7,  'user@capitec.co.za', 99,  5, 'COMPLETED', 'Demo User', '0821234567', 'user@capitec.co.za', 'CAP-20260730-001', '2026-07-28 14:00:00');

-- admin@capitec.co.za: additional bookings to fill the calendar
INSERT INTO appointments (id, user_id, slot_id, service_type_id, status, customer_name, customer_phone, customer_email, reference_number, created_at) VALUES
(8,  'admin@capitec.co.za', 15,  1, 'CONFIRMED', 'System Admin', '0800102043', 'admin@capitec.co.za', 'CAP-20260910-002', '2026-09-05 12:00:00'),
(9,  'admin@capitec.co.za', 19,  2, 'CONFIRMED', 'System Admin', '0800102043', 'admin@capitec.co.za', 'CAP-20260911-001', '2026-09-05 12:05:00'),
(10, 'admin@capitec.co.za', 44,  3, 'CONFIRMED', 'System Admin', '0800102043', 'admin@capitec.co.za', 'CAP-20260910-003', '2026-09-05 12:10:00'),
(11, 'admin@capitec.co.za', 49,  7, 'CONFIRMED', 'System Admin', '0800102043', 'admin@capitec.co.za', 'CAP-20260911-002', '2026-09-05 12:15:00'),
(12, 'admin@capitec.co.za', 77,  8, 'CONFIRMED', 'System Admin', '0800102043', 'admin@capitec.co.za', 'CAP-20260910-004', '2026-09-05 12:20:00'),
(13, 'admin@capitec.co.za', 86,  1, 'CONFIRMED', 'System Admin', '0800102043', 'admin@capitec.co.za', 'CAP-20260911-003', '2026-09-05 12:25:00'),
(14, 'admin@capitec.co.za', 98,  4, 'COMPLETED', 'System Admin', '0800102043', 'admin@capitec.co.za', 'CAP-20260729-001', '2026-07-26 09:00:00'),
(15, 'admin@capitec.co.za', 100, 2, 'COMPLETED', 'System Admin', '0800102043', 'admin@capitec.co.za', 'CAP-20260731-001', '2026-07-29 08:00:00');


-- =============================================================
-- EXTENDED DEMO DATA: Appointment Slots + Appointments
-- Coverage: Sep 15 – Dec 14, 2026 (2 days/week, avoiding holidays)
-- Branches: 1 Sandton City · 6 V&A Waterfront · 11 Gateway
-- 648 slot rows (IDs 101-748), 246 appointment rows (IDs 16-261)
-- ~3-4 BOOKED slots per day give a realistic busy calendar
-- =============================================================

-- Branch 1 – Sandton City (2026-09-15)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(101, 1, '2026-09-15', '08:00', '08:30', 'AVAILABLE', 0),
(102, 1, '2026-09-15', '09:00', '09:30', 'BOOKED', 0),
(103, 1, '2026-09-15', '10:00', '10:30', 'AVAILABLE', 0),
(104, 1, '2026-09-15', '11:00', '11:30', 'BOOKED', 0),
(105, 1, '2026-09-15', '13:00', '13:30', 'AVAILABLE', 0),
(106, 1, '2026-09-15', '14:00', '14:30', 'BOOKED', 0),
(107, 1, '2026-09-15', '15:00', '15:30', 'AVAILABLE', 0),
(108, 1, '2026-09-15', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 6 – V&A Waterfront (2026-09-15)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(109, 6, '2026-09-15', '08:00', '08:30', 'AVAILABLE', 0),
(110, 6, '2026-09-15', '09:00', '09:30', 'BOOKED', 0),
(111, 6, '2026-09-15', '10:00', '10:30', 'AVAILABLE', 0),
(112, 6, '2026-09-15', '11:00', '11:30', 'BOOKED', 0),
(113, 6, '2026-09-15', '13:00', '13:30', 'AVAILABLE', 0),
(114, 6, '2026-09-15', '14:00', '14:30', 'BOOKED', 0),
(115, 6, '2026-09-15', '15:00', '15:30', 'AVAILABLE', 0),
(116, 6, '2026-09-15', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 11 – Gateway (2026-09-15)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(117, 11, '2026-09-15', '08:00', '08:30', 'AVAILABLE', 0),
(118, 11, '2026-09-15', '09:00', '09:30', 'BOOKED', 0),
(119, 11, '2026-09-15', '10:00', '10:30', 'AVAILABLE', 0),
(120, 11, '2026-09-15', '11:00', '11:30', 'BOOKED', 0),
(121, 11, '2026-09-15', '13:00', '13:30', 'AVAILABLE', 0),
(122, 11, '2026-09-15', '14:00', '14:30', 'BOOKED', 0),
(123, 11, '2026-09-15', '15:00', '15:30', 'AVAILABLE', 0),
(124, 11, '2026-09-15', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 1 – Sandton City (2026-09-17)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(125, 1, '2026-09-17', '08:00', '08:30', 'BOOKED', 0),
(126, 1, '2026-09-17', '09:00', '09:30', 'AVAILABLE', 0),
(127, 1, '2026-09-17', '10:00', '10:30', 'BOOKED', 0),
(128, 1, '2026-09-17', '11:00', '11:30', 'AVAILABLE', 0),
(129, 1, '2026-09-17', '13:00', '13:30', 'AVAILABLE', 0),
(130, 1, '2026-09-17', '14:00', '14:30', 'AVAILABLE', 0),
(131, 1, '2026-09-17', '15:00', '15:30', 'BOOKED', 0),
(132, 1, '2026-09-17', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 6 – V&A Waterfront (2026-09-17)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(133, 6, '2026-09-17', '08:00', '08:30', 'BOOKED', 0),
(134, 6, '2026-09-17', '09:00', '09:30', 'AVAILABLE', 0),
(135, 6, '2026-09-17', '10:00', '10:30', 'BOOKED', 0),
(136, 6, '2026-09-17', '11:00', '11:30', 'AVAILABLE', 0),
(137, 6, '2026-09-17', '13:00', '13:30', 'AVAILABLE', 0),
(138, 6, '2026-09-17', '14:00', '14:30', 'AVAILABLE', 0),
(139, 6, '2026-09-17', '15:00', '15:30', 'BOOKED', 0),
(140, 6, '2026-09-17', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 11 – Gateway (2026-09-17)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(141, 11, '2026-09-17', '08:00', '08:30', 'BOOKED', 0),
(142, 11, '2026-09-17', '09:00', '09:30', 'AVAILABLE', 0),
(143, 11, '2026-09-17', '10:00', '10:30', 'BOOKED', 0),
(144, 11, '2026-09-17', '11:00', '11:30', 'AVAILABLE', 0),
(145, 11, '2026-09-17', '13:00', '13:30', 'AVAILABLE', 0),
(146, 11, '2026-09-17', '14:00', '14:30', 'AVAILABLE', 0),
(147, 11, '2026-09-17', '15:00', '15:30', 'BOOKED', 0),
(148, 11, '2026-09-17', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 1 – Sandton City (2026-09-22)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(149, 1, '2026-09-22', '08:00', '08:30', 'AVAILABLE', 0),
(150, 1, '2026-09-22', '09:00', '09:30', 'BOOKED', 0),
(151, 1, '2026-09-22', '10:00', '10:30', 'AVAILABLE', 0),
(152, 1, '2026-09-22', '11:00', '11:30', 'AVAILABLE', 0),
(153, 1, '2026-09-22', '13:00', '13:30', 'BOOKED', 0),
(154, 1, '2026-09-22', '14:00', '14:30', 'AVAILABLE', 0),
(155, 1, '2026-09-22', '15:00', '15:30', 'AVAILABLE', 0),
(156, 1, '2026-09-22', '16:00', '16:30', 'BOOKED', 0);

-- Branch 6 – V&A Waterfront (2026-09-22)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(157, 6, '2026-09-22', '08:00', '08:30', 'AVAILABLE', 0),
(158, 6, '2026-09-22', '09:00', '09:30', 'BOOKED', 0),
(159, 6, '2026-09-22', '10:00', '10:30', 'AVAILABLE', 0),
(160, 6, '2026-09-22', '11:00', '11:30', 'AVAILABLE', 0),
(161, 6, '2026-09-22', '13:00', '13:30', 'BOOKED', 0),
(162, 6, '2026-09-22', '14:00', '14:30', 'AVAILABLE', 0),
(163, 6, '2026-09-22', '15:00', '15:30', 'AVAILABLE', 0),
(164, 6, '2026-09-22', '16:00', '16:30', 'BOOKED', 0);

-- Branch 11 – Gateway (2026-09-22)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(165, 11, '2026-09-22', '08:00', '08:30', 'AVAILABLE', 0),
(166, 11, '2026-09-22', '09:00', '09:30', 'BOOKED', 0),
(167, 11, '2026-09-22', '10:00', '10:30', 'AVAILABLE', 0),
(168, 11, '2026-09-22', '11:00', '11:30', 'AVAILABLE', 0),
(169, 11, '2026-09-22', '13:00', '13:30', 'BOOKED', 0),
(170, 11, '2026-09-22', '14:00', '14:30', 'AVAILABLE', 0),
(171, 11, '2026-09-22', '15:00', '15:30', 'AVAILABLE', 0),
(172, 11, '2026-09-22', '16:00', '16:30', 'BOOKED', 0);

-- Branch 1 – Sandton City (2026-09-23)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(173, 1, '2026-09-23', '08:00', '08:30', 'AVAILABLE', 0),
(174, 1, '2026-09-23', '09:00', '09:30', 'AVAILABLE', 0),
(175, 1, '2026-09-23', '10:00', '10:30', 'BOOKED', 0),
(176, 1, '2026-09-23', '11:00', '11:30', 'BOOKED', 0),
(177, 1, '2026-09-23', '13:00', '13:30', 'AVAILABLE', 0),
(178, 1, '2026-09-23', '14:00', '14:30', 'BOOKED', 0),
(179, 1, '2026-09-23', '15:00', '15:30', 'AVAILABLE', 0),
(180, 1, '2026-09-23', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 6 – V&A Waterfront (2026-09-23)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(181, 6, '2026-09-23', '08:00', '08:30', 'AVAILABLE', 0),
(182, 6, '2026-09-23', '09:00', '09:30', 'AVAILABLE', 0),
(183, 6, '2026-09-23', '10:00', '10:30', 'BOOKED', 0),
(184, 6, '2026-09-23', '11:00', '11:30', 'BOOKED', 0),
(185, 6, '2026-09-23', '13:00', '13:30', 'AVAILABLE', 0),
(186, 6, '2026-09-23', '14:00', '14:30', 'BOOKED', 0),
(187, 6, '2026-09-23', '15:00', '15:30', 'AVAILABLE', 0),
(188, 6, '2026-09-23', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 11 – Gateway (2026-09-23)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(189, 11, '2026-09-23', '08:00', '08:30', 'AVAILABLE', 0),
(190, 11, '2026-09-23', '09:00', '09:30', 'AVAILABLE', 0),
(191, 11, '2026-09-23', '10:00', '10:30', 'BOOKED', 0),
(192, 11, '2026-09-23', '11:00', '11:30', 'BOOKED', 0),
(193, 11, '2026-09-23', '13:00', '13:30', 'AVAILABLE', 0),
(194, 11, '2026-09-23', '14:00', '14:30', 'BOOKED', 0),
(195, 11, '2026-09-23', '15:00', '15:30', 'AVAILABLE', 0),
(196, 11, '2026-09-23', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 1 – Sandton City (2026-09-29)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(197, 1, '2026-09-29', '08:00', '08:30', 'BOOKED', 0),
(198, 1, '2026-09-29', '09:00', '09:30', 'AVAILABLE', 0),
(199, 1, '2026-09-29', '10:00', '10:30', 'AVAILABLE', 0),
(200, 1, '2026-09-29', '11:00', '11:30', 'BOOKED', 0),
(201, 1, '2026-09-29', '13:00', '13:30', 'AVAILABLE', 0),
(202, 1, '2026-09-29', '14:00', '14:30', 'AVAILABLE', 0),
(203, 1, '2026-09-29', '15:00', '15:30', 'BOOKED', 0),
(204, 1, '2026-09-29', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 6 – V&A Waterfront (2026-09-29)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(205, 6, '2026-09-29', '08:00', '08:30', 'BOOKED', 0),
(206, 6, '2026-09-29', '09:00', '09:30', 'AVAILABLE', 0),
(207, 6, '2026-09-29', '10:00', '10:30', 'AVAILABLE', 0),
(208, 6, '2026-09-29', '11:00', '11:30', 'BOOKED', 0),
(209, 6, '2026-09-29', '13:00', '13:30', 'AVAILABLE', 0),
(210, 6, '2026-09-29', '14:00', '14:30', 'AVAILABLE', 0),
(211, 6, '2026-09-29', '15:00', '15:30', 'BOOKED', 0),
(212, 6, '2026-09-29', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 11 – Gateway (2026-09-29)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(213, 11, '2026-09-29', '08:00', '08:30', 'BOOKED', 0),
(214, 11, '2026-09-29', '09:00', '09:30', 'AVAILABLE', 0),
(215, 11, '2026-09-29', '10:00', '10:30', 'AVAILABLE', 0),
(216, 11, '2026-09-29', '11:00', '11:30', 'BOOKED', 0),
(217, 11, '2026-09-29', '13:00', '13:30', 'AVAILABLE', 0),
(218, 11, '2026-09-29', '14:00', '14:30', 'AVAILABLE', 0),
(219, 11, '2026-09-29', '15:00', '15:30', 'BOOKED', 0),
(220, 11, '2026-09-29', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 1 – Sandton City (2026-10-01)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(221, 1, '2026-10-01', '08:00', '08:30', 'AVAILABLE', 0),
(222, 1, '2026-10-01', '09:00', '09:30', 'BOOKED', 0),
(223, 1, '2026-10-01', '10:00', '10:30', 'BOOKED', 0),
(224, 1, '2026-10-01', '11:00', '11:30', 'AVAILABLE', 0),
(225, 1, '2026-10-01', '13:00', '13:30', 'AVAILABLE', 0),
(226, 1, '2026-10-01', '14:00', '14:30', 'AVAILABLE', 0),
(227, 1, '2026-10-01', '15:00', '15:30', 'AVAILABLE', 0),
(228, 1, '2026-10-01', '16:00', '16:30', 'BOOKED', 0);

-- Branch 6 – V&A Waterfront (2026-10-01)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(229, 6, '2026-10-01', '08:00', '08:30', 'AVAILABLE', 0),
(230, 6, '2026-10-01', '09:00', '09:30', 'BOOKED', 0),
(231, 6, '2026-10-01', '10:00', '10:30', 'BOOKED', 0),
(232, 6, '2026-10-01', '11:00', '11:30', 'AVAILABLE', 0),
(233, 6, '2026-10-01', '13:00', '13:30', 'AVAILABLE', 0),
(234, 6, '2026-10-01', '14:00', '14:30', 'AVAILABLE', 0),
(235, 6, '2026-10-01', '15:00', '15:30', 'AVAILABLE', 0),
(236, 6, '2026-10-01', '16:00', '16:30', 'BOOKED', 0);

-- Branch 11 – Gateway (2026-10-01)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(237, 11, '2026-10-01', '08:00', '08:30', 'AVAILABLE', 0),
(238, 11, '2026-10-01', '09:00', '09:30', 'BOOKED', 0),
(239, 11, '2026-10-01', '10:00', '10:30', 'BOOKED', 0),
(240, 11, '2026-10-01', '11:00', '11:30', 'AVAILABLE', 0),
(241, 11, '2026-10-01', '13:00', '13:30', 'AVAILABLE', 0),
(242, 11, '2026-10-01', '14:00', '14:30', 'AVAILABLE', 0),
(243, 11, '2026-10-01', '15:00', '15:30', 'AVAILABLE', 0),
(244, 11, '2026-10-01', '16:00', '16:30', 'BOOKED', 0);

-- Branch 1 – Sandton City (2026-10-05)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(245, 1, '2026-10-05', '08:00', '08:30', 'BOOKED', 0),
(246, 1, '2026-10-05', '09:00', '09:30', 'AVAILABLE', 0),
(247, 1, '2026-10-05', '10:00', '10:30', 'AVAILABLE', 0),
(248, 1, '2026-10-05', '11:00', '11:30', 'AVAILABLE', 0),
(249, 1, '2026-10-05', '13:00', '13:30', 'BOOKED', 0),
(250, 1, '2026-10-05', '14:00', '14:30', 'BOOKED', 0),
(251, 1, '2026-10-05', '15:00', '15:30', 'AVAILABLE', 0),
(252, 1, '2026-10-05', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 6 – V&A Waterfront (2026-10-05)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(253, 6, '2026-10-05', '08:00', '08:30', 'BOOKED', 0),
(254, 6, '2026-10-05', '09:00', '09:30', 'AVAILABLE', 0),
(255, 6, '2026-10-05', '10:00', '10:30', 'AVAILABLE', 0),
(256, 6, '2026-10-05', '11:00', '11:30', 'AVAILABLE', 0),
(257, 6, '2026-10-05', '13:00', '13:30', 'BOOKED', 0),
(258, 6, '2026-10-05', '14:00', '14:30', 'BOOKED', 0),
(259, 6, '2026-10-05', '15:00', '15:30', 'AVAILABLE', 0),
(260, 6, '2026-10-05', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 11 – Gateway (2026-10-05)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(261, 11, '2026-10-05', '08:00', '08:30', 'BOOKED', 0),
(262, 11, '2026-10-05', '09:00', '09:30', 'AVAILABLE', 0),
(263, 11, '2026-10-05', '10:00', '10:30', 'AVAILABLE', 0),
(264, 11, '2026-10-05', '11:00', '11:30', 'AVAILABLE', 0),
(265, 11, '2026-10-05', '13:00', '13:30', 'BOOKED', 0),
(266, 11, '2026-10-05', '14:00', '14:30', 'BOOKED', 0),
(267, 11, '2026-10-05', '15:00', '15:30', 'AVAILABLE', 0),
(268, 11, '2026-10-05', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 1 – Sandton City (2026-10-07)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(269, 1, '2026-10-07', '08:00', '08:30', 'AVAILABLE', 0),
(270, 1, '2026-10-07', '09:00', '09:30', 'AVAILABLE', 0),
(271, 1, '2026-10-07', '10:00', '10:30', 'BOOKED', 0),
(272, 1, '2026-10-07', '11:00', '11:30', 'AVAILABLE', 0),
(273, 1, '2026-10-07', '13:00', '13:30', 'AVAILABLE', 0),
(274, 1, '2026-10-07', '14:00', '14:30', 'BOOKED', 0),
(275, 1, '2026-10-07', '15:00', '15:30', 'AVAILABLE', 0),
(276, 1, '2026-10-07', '16:00', '16:30', 'BOOKED', 0);

-- Branch 6 – V&A Waterfront (2026-10-07)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(277, 6, '2026-10-07', '08:00', '08:30', 'AVAILABLE', 0),
(278, 6, '2026-10-07', '09:00', '09:30', 'AVAILABLE', 0),
(279, 6, '2026-10-07', '10:00', '10:30', 'BOOKED', 0),
(280, 6, '2026-10-07', '11:00', '11:30', 'AVAILABLE', 0),
(281, 6, '2026-10-07', '13:00', '13:30', 'AVAILABLE', 0),
(282, 6, '2026-10-07', '14:00', '14:30', 'BOOKED', 0),
(283, 6, '2026-10-07', '15:00', '15:30', 'AVAILABLE', 0),
(284, 6, '2026-10-07', '16:00', '16:30', 'BOOKED', 0);

-- Branch 11 – Gateway (2026-10-07)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(285, 11, '2026-10-07', '08:00', '08:30', 'AVAILABLE', 0),
(286, 11, '2026-10-07', '09:00', '09:30', 'AVAILABLE', 0),
(287, 11, '2026-10-07', '10:00', '10:30', 'BOOKED', 0),
(288, 11, '2026-10-07', '11:00', '11:30', 'AVAILABLE', 0),
(289, 11, '2026-10-07', '13:00', '13:30', 'AVAILABLE', 0),
(290, 11, '2026-10-07', '14:00', '14:30', 'BOOKED', 0),
(291, 11, '2026-10-07', '15:00', '15:30', 'AVAILABLE', 0),
(292, 11, '2026-10-07', '16:00', '16:30', 'BOOKED', 0);

-- Branch 1 – Sandton City (2026-10-12)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(293, 1, '2026-10-12', '08:00', '08:30', 'AVAILABLE', 0),
(294, 1, '2026-10-12', '09:00', '09:30', 'BOOKED', 0),
(295, 1, '2026-10-12', '10:00', '10:30', 'AVAILABLE', 0),
(296, 1, '2026-10-12', '11:00', '11:30', 'BOOKED', 0),
(297, 1, '2026-10-12', '13:00', '13:30', 'AVAILABLE', 0),
(298, 1, '2026-10-12', '14:00', '14:30', 'AVAILABLE', 0),
(299, 1, '2026-10-12', '15:00', '15:30', 'BOOKED', 0),
(300, 1, '2026-10-12', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 6 – V&A Waterfront (2026-10-12)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(301, 6, '2026-10-12', '08:00', '08:30', 'AVAILABLE', 0),
(302, 6, '2026-10-12', '09:00', '09:30', 'BOOKED', 0),
(303, 6, '2026-10-12', '10:00', '10:30', 'AVAILABLE', 0),
(304, 6, '2026-10-12', '11:00', '11:30', 'BOOKED', 0),
(305, 6, '2026-10-12', '13:00', '13:30', 'AVAILABLE', 0),
(306, 6, '2026-10-12', '14:00', '14:30', 'AVAILABLE', 0),
(307, 6, '2026-10-12', '15:00', '15:30', 'BOOKED', 0),
(308, 6, '2026-10-12', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 11 – Gateway (2026-10-12)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(309, 11, '2026-10-12', '08:00', '08:30', 'AVAILABLE', 0),
(310, 11, '2026-10-12', '09:00', '09:30', 'BOOKED', 0),
(311, 11, '2026-10-12', '10:00', '10:30', 'AVAILABLE', 0),
(312, 11, '2026-10-12', '11:00', '11:30', 'BOOKED', 0),
(313, 11, '2026-10-12', '13:00', '13:30', 'AVAILABLE', 0),
(314, 11, '2026-10-12', '14:00', '14:30', 'AVAILABLE', 0),
(315, 11, '2026-10-12', '15:00', '15:30', 'BOOKED', 0),
(316, 11, '2026-10-12', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 1 – Sandton City (2026-10-14)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(317, 1, '2026-10-14', '08:00', '08:30', 'BOOKED', 0),
(318, 1, '2026-10-14', '09:00', '09:30', 'AVAILABLE', 0),
(319, 1, '2026-10-14', '10:00', '10:30', 'BOOKED', 0),
(320, 1, '2026-10-14', '11:00', '11:30', 'AVAILABLE', 0),
(321, 1, '2026-10-14', '13:00', '13:30', 'AVAILABLE', 0),
(322, 1, '2026-10-14', '14:00', '14:30', 'BOOKED', 0),
(323, 1, '2026-10-14', '15:00', '15:30', 'AVAILABLE', 0),
(324, 1, '2026-10-14', '16:00', '16:30', 'BOOKED', 0);

-- Branch 6 – V&A Waterfront (2026-10-14)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(325, 6, '2026-10-14', '08:00', '08:30', 'BOOKED', 0),
(326, 6, '2026-10-14', '09:00', '09:30', 'AVAILABLE', 0),
(327, 6, '2026-10-14', '10:00', '10:30', 'BOOKED', 0),
(328, 6, '2026-10-14', '11:00', '11:30', 'AVAILABLE', 0),
(329, 6, '2026-10-14', '13:00', '13:30', 'AVAILABLE', 0),
(330, 6, '2026-10-14', '14:00', '14:30', 'BOOKED', 0),
(331, 6, '2026-10-14', '15:00', '15:30', 'AVAILABLE', 0),
(332, 6, '2026-10-14', '16:00', '16:30', 'BOOKED', 0);

-- Branch 11 – Gateway (2026-10-14)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(333, 11, '2026-10-14', '08:00', '08:30', 'BOOKED', 0),
(334, 11, '2026-10-14', '09:00', '09:30', 'AVAILABLE', 0),
(335, 11, '2026-10-14', '10:00', '10:30', 'BOOKED', 0),
(336, 11, '2026-10-14', '11:00', '11:30', 'AVAILABLE', 0),
(337, 11, '2026-10-14', '13:00', '13:30', 'AVAILABLE', 0),
(338, 11, '2026-10-14', '14:00', '14:30', 'BOOKED', 0),
(339, 11, '2026-10-14', '15:00', '15:30', 'AVAILABLE', 0),
(340, 11, '2026-10-14', '16:00', '16:30', 'BOOKED', 0);

-- Branch 1 – Sandton City (2026-10-19)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(341, 1, '2026-10-19', '08:00', '08:30', 'AVAILABLE', 0),
(342, 1, '2026-10-19', '09:00', '09:30', 'BOOKED', 0),
(343, 1, '2026-10-19', '10:00', '10:30', 'AVAILABLE', 0),
(344, 1, '2026-10-19', '11:00', '11:30', 'AVAILABLE', 0),
(345, 1, '2026-10-19', '13:00', '13:30', 'BOOKED', 0),
(346, 1, '2026-10-19', '14:00', '14:30', 'AVAILABLE', 0),
(347, 1, '2026-10-19', '15:00', '15:30', 'BOOKED', 0),
(348, 1, '2026-10-19', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 6 – V&A Waterfront (2026-10-19)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(349, 6, '2026-10-19', '08:00', '08:30', 'AVAILABLE', 0),
(350, 6, '2026-10-19', '09:00', '09:30', 'BOOKED', 0),
(351, 6, '2026-10-19', '10:00', '10:30', 'AVAILABLE', 0),
(352, 6, '2026-10-19', '11:00', '11:30', 'AVAILABLE', 0),
(353, 6, '2026-10-19', '13:00', '13:30', 'BOOKED', 0),
(354, 6, '2026-10-19', '14:00', '14:30', 'AVAILABLE', 0),
(355, 6, '2026-10-19', '15:00', '15:30', 'BOOKED', 0),
(356, 6, '2026-10-19', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 11 – Gateway (2026-10-19)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(357, 11, '2026-10-19', '08:00', '08:30', 'AVAILABLE', 0),
(358, 11, '2026-10-19', '09:00', '09:30', 'BOOKED', 0),
(359, 11, '2026-10-19', '10:00', '10:30', 'AVAILABLE', 0),
(360, 11, '2026-10-19', '11:00', '11:30', 'AVAILABLE', 0),
(361, 11, '2026-10-19', '13:00', '13:30', 'BOOKED', 0),
(362, 11, '2026-10-19', '14:00', '14:30', 'AVAILABLE', 0),
(363, 11, '2026-10-19', '15:00', '15:30', 'BOOKED', 0),
(364, 11, '2026-10-19', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 1 – Sandton City (2026-10-21)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(365, 1, '2026-10-21', '08:00', '08:30', 'BOOKED', 0),
(366, 1, '2026-10-21', '09:00', '09:30', 'AVAILABLE', 0),
(367, 1, '2026-10-21', '10:00', '10:30', 'AVAILABLE', 0),
(368, 1, '2026-10-21', '11:00', '11:30', 'BOOKED', 0),
(369, 1, '2026-10-21', '13:00', '13:30', 'AVAILABLE', 0),
(370, 1, '2026-10-21', '14:00', '14:30', 'AVAILABLE', 0),
(371, 1, '2026-10-21', '15:00', '15:30', 'AVAILABLE', 0),
(372, 1, '2026-10-21', '16:00', '16:30', 'BOOKED', 0);

-- Branch 6 – V&A Waterfront (2026-10-21)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(373, 6, '2026-10-21', '08:00', '08:30', 'BOOKED', 0),
(374, 6, '2026-10-21', '09:00', '09:30', 'AVAILABLE', 0),
(375, 6, '2026-10-21', '10:00', '10:30', 'AVAILABLE', 0),
(376, 6, '2026-10-21', '11:00', '11:30', 'BOOKED', 0),
(377, 6, '2026-10-21', '13:00', '13:30', 'AVAILABLE', 0),
(378, 6, '2026-10-21', '14:00', '14:30', 'AVAILABLE', 0),
(379, 6, '2026-10-21', '15:00', '15:30', 'AVAILABLE', 0),
(380, 6, '2026-10-21', '16:00', '16:30', 'BOOKED', 0);

-- Branch 11 – Gateway (2026-10-21)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(381, 11, '2026-10-21', '08:00', '08:30', 'BOOKED', 0),
(382, 11, '2026-10-21', '09:00', '09:30', 'AVAILABLE', 0),
(383, 11, '2026-10-21', '10:00', '10:30', 'AVAILABLE', 0),
(384, 11, '2026-10-21', '11:00', '11:30', 'BOOKED', 0),
(385, 11, '2026-10-21', '13:00', '13:30', 'AVAILABLE', 0),
(386, 11, '2026-10-21', '14:00', '14:30', 'AVAILABLE', 0),
(387, 11, '2026-10-21', '15:00', '15:30', 'AVAILABLE', 0),
(388, 11, '2026-10-21', '16:00', '16:30', 'BOOKED', 0);

-- Branch 1 – Sandton City (2026-10-26)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(389, 1, '2026-10-26', '08:00', '08:30', 'AVAILABLE', 0),
(390, 1, '2026-10-26', '09:00', '09:30', 'AVAILABLE', 0),
(391, 1, '2026-10-26', '10:00', '10:30', 'BOOKED', 0),
(392, 1, '2026-10-26', '11:00', '11:30', 'AVAILABLE', 0),
(393, 1, '2026-10-26', '13:00', '13:30', 'BOOKED', 0),
(394, 1, '2026-10-26', '14:00', '14:30', 'BOOKED', 0),
(395, 1, '2026-10-26', '15:00', '15:30', 'AVAILABLE', 0),
(396, 1, '2026-10-26', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 6 – V&A Waterfront (2026-10-26)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(397, 6, '2026-10-26', '08:00', '08:30', 'AVAILABLE', 0),
(398, 6, '2026-10-26', '09:00', '09:30', 'AVAILABLE', 0),
(399, 6, '2026-10-26', '10:00', '10:30', 'BOOKED', 0),
(400, 6, '2026-10-26', '11:00', '11:30', 'AVAILABLE', 0),
(401, 6, '2026-10-26', '13:00', '13:30', 'BOOKED', 0),
(402, 6, '2026-10-26', '14:00', '14:30', 'BOOKED', 0),
(403, 6, '2026-10-26', '15:00', '15:30', 'AVAILABLE', 0),
(404, 6, '2026-10-26', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 11 – Gateway (2026-10-26)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(405, 11, '2026-10-26', '08:00', '08:30', 'AVAILABLE', 0),
(406, 11, '2026-10-26', '09:00', '09:30', 'AVAILABLE', 0),
(407, 11, '2026-10-26', '10:00', '10:30', 'BOOKED', 0),
(408, 11, '2026-10-26', '11:00', '11:30', 'AVAILABLE', 0),
(409, 11, '2026-10-26', '13:00', '13:30', 'BOOKED', 0),
(410, 11, '2026-10-26', '14:00', '14:30', 'BOOKED', 0),
(411, 11, '2026-10-26', '15:00', '15:30', 'AVAILABLE', 0),
(412, 11, '2026-10-26', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 1 – Sandton City (2026-10-28)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(413, 1, '2026-10-28', '08:00', '08:30', 'AVAILABLE', 0),
(414, 1, '2026-10-28', '09:00', '09:30', 'BOOKED', 0),
(415, 1, '2026-10-28', '10:00', '10:30', 'AVAILABLE', 0),
(416, 1, '2026-10-28', '11:00', '11:30', 'BOOKED', 0),
(417, 1, '2026-10-28', '13:00', '13:30', 'AVAILABLE', 0),
(418, 1, '2026-10-28', '14:00', '14:30', 'AVAILABLE', 0),
(419, 1, '2026-10-28', '15:00', '15:30', 'BOOKED', 0),
(420, 1, '2026-10-28', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 6 – V&A Waterfront (2026-10-28)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(421, 6, '2026-10-28', '08:00', '08:30', 'AVAILABLE', 0),
(422, 6, '2026-10-28', '09:00', '09:30', 'BOOKED', 0),
(423, 6, '2026-10-28', '10:00', '10:30', 'AVAILABLE', 0),
(424, 6, '2026-10-28', '11:00', '11:30', 'BOOKED', 0),
(425, 6, '2026-10-28', '13:00', '13:30', 'AVAILABLE', 0),
(426, 6, '2026-10-28', '14:00', '14:30', 'AVAILABLE', 0),
(427, 6, '2026-10-28', '15:00', '15:30', 'BOOKED', 0),
(428, 6, '2026-10-28', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 11 – Gateway (2026-10-28)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(429, 11, '2026-10-28', '08:00', '08:30', 'AVAILABLE', 0),
(430, 11, '2026-10-28', '09:00', '09:30', 'BOOKED', 0),
(431, 11, '2026-10-28', '10:00', '10:30', 'AVAILABLE', 0),
(432, 11, '2026-10-28', '11:00', '11:30', 'BOOKED', 0),
(433, 11, '2026-10-28', '13:00', '13:30', 'AVAILABLE', 0),
(434, 11, '2026-10-28', '14:00', '14:30', 'AVAILABLE', 0),
(435, 11, '2026-10-28', '15:00', '15:30', 'BOOKED', 0),
(436, 11, '2026-10-28', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 1 – Sandton City (2026-11-02)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(437, 1, '2026-11-02', '08:00', '08:30', 'BOOKED', 0),
(438, 1, '2026-11-02', '09:00', '09:30', 'AVAILABLE', 0),
(439, 1, '2026-11-02', '10:00', '10:30', 'BOOKED', 0),
(440, 1, '2026-11-02', '11:00', '11:30', 'AVAILABLE', 0),
(441, 1, '2026-11-02', '13:00', '13:30', 'AVAILABLE', 0),
(442, 1, '2026-11-02', '14:00', '14:30', 'AVAILABLE', 0),
(443, 1, '2026-11-02', '15:00', '15:30', 'AVAILABLE', 0),
(444, 1, '2026-11-02', '16:00', '16:30', 'BOOKED', 0);

-- Branch 6 – V&A Waterfront (2026-11-02)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(445, 6, '2026-11-02', '08:00', '08:30', 'BOOKED', 0),
(446, 6, '2026-11-02', '09:00', '09:30', 'AVAILABLE', 0),
(447, 6, '2026-11-02', '10:00', '10:30', 'BOOKED', 0),
(448, 6, '2026-11-02', '11:00', '11:30', 'AVAILABLE', 0),
(449, 6, '2026-11-02', '13:00', '13:30', 'AVAILABLE', 0),
(450, 6, '2026-11-02', '14:00', '14:30', 'AVAILABLE', 0),
(451, 6, '2026-11-02', '15:00', '15:30', 'AVAILABLE', 0),
(452, 6, '2026-11-02', '16:00', '16:30', 'BOOKED', 0);

-- Branch 11 – Gateway (2026-11-02)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(453, 11, '2026-11-02', '08:00', '08:30', 'BOOKED', 0),
(454, 11, '2026-11-02', '09:00', '09:30', 'AVAILABLE', 0),
(455, 11, '2026-11-02', '10:00', '10:30', 'BOOKED', 0),
(456, 11, '2026-11-02', '11:00', '11:30', 'AVAILABLE', 0),
(457, 11, '2026-11-02', '13:00', '13:30', 'AVAILABLE', 0),
(458, 11, '2026-11-02', '14:00', '14:30', 'AVAILABLE', 0),
(459, 11, '2026-11-02', '15:00', '15:30', 'AVAILABLE', 0),
(460, 11, '2026-11-02', '16:00', '16:30', 'BOOKED', 0);

-- Branch 1 – Sandton City (2026-11-04)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(461, 1, '2026-11-04', '08:00', '08:30', 'AVAILABLE', 0),
(462, 1, '2026-11-04', '09:00', '09:30', 'AVAILABLE', 0),
(463, 1, '2026-11-04', '10:00', '10:30', 'AVAILABLE', 0),
(464, 1, '2026-11-04', '11:00', '11:30', 'BOOKED', 0),
(465, 1, '2026-11-04', '13:00', '13:30', 'AVAILABLE', 0),
(466, 1, '2026-11-04', '14:00', '14:30', 'BOOKED', 0),
(467, 1, '2026-11-04', '15:00', '15:30', 'BOOKED', 0),
(468, 1, '2026-11-04', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 6 – V&A Waterfront (2026-11-04)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(469, 6, '2026-11-04', '08:00', '08:30', 'AVAILABLE', 0),
(470, 6, '2026-11-04', '09:00', '09:30', 'AVAILABLE', 0),
(471, 6, '2026-11-04', '10:00', '10:30', 'AVAILABLE', 0),
(472, 6, '2026-11-04', '11:00', '11:30', 'BOOKED', 0),
(473, 6, '2026-11-04', '13:00', '13:30', 'AVAILABLE', 0),
(474, 6, '2026-11-04', '14:00', '14:30', 'BOOKED', 0),
(475, 6, '2026-11-04', '15:00', '15:30', 'BOOKED', 0),
(476, 6, '2026-11-04', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 11 – Gateway (2026-11-04)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(477, 11, '2026-11-04', '08:00', '08:30', 'AVAILABLE', 0),
(478, 11, '2026-11-04', '09:00', '09:30', 'AVAILABLE', 0),
(479, 11, '2026-11-04', '10:00', '10:30', 'AVAILABLE', 0),
(480, 11, '2026-11-04', '11:00', '11:30', 'BOOKED', 0),
(481, 11, '2026-11-04', '13:00', '13:30', 'AVAILABLE', 0),
(482, 11, '2026-11-04', '14:00', '14:30', 'BOOKED', 0),
(483, 11, '2026-11-04', '15:00', '15:30', 'BOOKED', 0),
(484, 11, '2026-11-04', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 1 – Sandton City (2026-11-09)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(485, 1, '2026-11-09', '08:00', '08:30', 'AVAILABLE', 0),
(486, 1, '2026-11-09', '09:00', '09:30', 'BOOKED', 0),
(487, 1, '2026-11-09', '10:00', '10:30', 'AVAILABLE', 0),
(488, 1, '2026-11-09', '11:00', '11:30', 'AVAILABLE', 0),
(489, 1, '2026-11-09', '13:00', '13:30', 'BOOKED', 0),
(490, 1, '2026-11-09', '14:00', '14:30', 'AVAILABLE', 0),
(491, 1, '2026-11-09', '15:00', '15:30', 'AVAILABLE', 0),
(492, 1, '2026-11-09', '16:00', '16:30', 'BOOKED', 0);

-- Branch 6 – V&A Waterfront (2026-11-09)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(493, 6, '2026-11-09', '08:00', '08:30', 'AVAILABLE', 0),
(494, 6, '2026-11-09', '09:00', '09:30', 'BOOKED', 0),
(495, 6, '2026-11-09', '10:00', '10:30', 'AVAILABLE', 0),
(496, 6, '2026-11-09', '11:00', '11:30', 'AVAILABLE', 0),
(497, 6, '2026-11-09', '13:00', '13:30', 'BOOKED', 0),
(498, 6, '2026-11-09', '14:00', '14:30', 'AVAILABLE', 0),
(499, 6, '2026-11-09', '15:00', '15:30', 'AVAILABLE', 0),
(500, 6, '2026-11-09', '16:00', '16:30', 'BOOKED', 0);

-- Branch 11 – Gateway (2026-11-09)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(501, 11, '2026-11-09', '08:00', '08:30', 'AVAILABLE', 0),
(502, 11, '2026-11-09', '09:00', '09:30', 'BOOKED', 0),
(503, 11, '2026-11-09', '10:00', '10:30', 'AVAILABLE', 0),
(504, 11, '2026-11-09', '11:00', '11:30', 'AVAILABLE', 0),
(505, 11, '2026-11-09', '13:00', '13:30', 'BOOKED', 0),
(506, 11, '2026-11-09', '14:00', '14:30', 'AVAILABLE', 0),
(507, 11, '2026-11-09', '15:00', '15:30', 'AVAILABLE', 0),
(508, 11, '2026-11-09', '16:00', '16:30', 'BOOKED', 0);

-- Branch 1 – Sandton City (2026-11-11)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(509, 1, '2026-11-11', '08:00', '08:30', 'BOOKED', 0),
(510, 1, '2026-11-11', '09:00', '09:30', 'AVAILABLE', 0),
(511, 1, '2026-11-11', '10:00', '10:30', 'BOOKED', 0),
(512, 1, '2026-11-11', '11:00', '11:30', 'AVAILABLE', 0),
(513, 1, '2026-11-11', '13:00', '13:30', 'AVAILABLE', 0),
(514, 1, '2026-11-11', '14:00', '14:30', 'AVAILABLE', 0),
(515, 1, '2026-11-11', '15:00', '15:30', 'BOOKED', 0),
(516, 1, '2026-11-11', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 6 – V&A Waterfront (2026-11-11)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(517, 6, '2026-11-11', '08:00', '08:30', 'BOOKED', 0),
(518, 6, '2026-11-11', '09:00', '09:30', 'AVAILABLE', 0),
(519, 6, '2026-11-11', '10:00', '10:30', 'BOOKED', 0),
(520, 6, '2026-11-11', '11:00', '11:30', 'AVAILABLE', 0),
(521, 6, '2026-11-11', '13:00', '13:30', 'AVAILABLE', 0),
(522, 6, '2026-11-11', '14:00', '14:30', 'AVAILABLE', 0),
(523, 6, '2026-11-11', '15:00', '15:30', 'BOOKED', 0),
(524, 6, '2026-11-11', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 11 – Gateway (2026-11-11)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(525, 11, '2026-11-11', '08:00', '08:30', 'BOOKED', 0),
(526, 11, '2026-11-11', '09:00', '09:30', 'AVAILABLE', 0),
(527, 11, '2026-11-11', '10:00', '10:30', 'BOOKED', 0),
(528, 11, '2026-11-11', '11:00', '11:30', 'AVAILABLE', 0),
(529, 11, '2026-11-11', '13:00', '13:30', 'AVAILABLE', 0),
(530, 11, '2026-11-11', '14:00', '14:30', 'AVAILABLE', 0),
(531, 11, '2026-11-11', '15:00', '15:30', 'BOOKED', 0),
(532, 11, '2026-11-11', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 1 – Sandton City (2026-11-16)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(533, 1, '2026-11-16', '08:00', '08:30', 'AVAILABLE', 0),
(534, 1, '2026-11-16', '09:00', '09:30', 'AVAILABLE', 0),
(535, 1, '2026-11-16', '10:00', '10:30', 'BOOKED', 0),
(536, 1, '2026-11-16', '11:00', '11:30', 'BOOKED', 0),
(537, 1, '2026-11-16', '13:00', '13:30', 'AVAILABLE', 0),
(538, 1, '2026-11-16', '14:00', '14:30', 'BOOKED', 0),
(539, 1, '2026-11-16', '15:00', '15:30', 'AVAILABLE', 0),
(540, 1, '2026-11-16', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 6 – V&A Waterfront (2026-11-16)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(541, 6, '2026-11-16', '08:00', '08:30', 'AVAILABLE', 0),
(542, 6, '2026-11-16', '09:00', '09:30', 'AVAILABLE', 0),
(543, 6, '2026-11-16', '10:00', '10:30', 'BOOKED', 0),
(544, 6, '2026-11-16', '11:00', '11:30', 'BOOKED', 0),
(545, 6, '2026-11-16', '13:00', '13:30', 'AVAILABLE', 0),
(546, 6, '2026-11-16', '14:00', '14:30', 'BOOKED', 0),
(547, 6, '2026-11-16', '15:00', '15:30', 'AVAILABLE', 0),
(548, 6, '2026-11-16', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 11 – Gateway (2026-11-16)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(549, 11, '2026-11-16', '08:00', '08:30', 'AVAILABLE', 0),
(550, 11, '2026-11-16', '09:00', '09:30', 'AVAILABLE', 0),
(551, 11, '2026-11-16', '10:00', '10:30', 'BOOKED', 0),
(552, 11, '2026-11-16', '11:00', '11:30', 'BOOKED', 0),
(553, 11, '2026-11-16', '13:00', '13:30', 'AVAILABLE', 0),
(554, 11, '2026-11-16', '14:00', '14:30', 'BOOKED', 0),
(555, 11, '2026-11-16', '15:00', '15:30', 'AVAILABLE', 0),
(556, 11, '2026-11-16', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 1 – Sandton City (2026-11-18)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(557, 1, '2026-11-18', '08:00', '08:30', 'BOOKED', 0),
(558, 1, '2026-11-18', '09:00', '09:30', 'AVAILABLE', 0),
(559, 1, '2026-11-18', '10:00', '10:30', 'AVAILABLE', 0),
(560, 1, '2026-11-18', '11:00', '11:30', 'AVAILABLE', 0),
(561, 1, '2026-11-18', '13:00', '13:30', 'BOOKED', 0),
(562, 1, '2026-11-18', '14:00', '14:30', 'AVAILABLE', 0),
(563, 1, '2026-11-18', '15:00', '15:30', 'AVAILABLE', 0),
(564, 1, '2026-11-18', '16:00', '16:30', 'BOOKED', 0);

-- Branch 6 – V&A Waterfront (2026-11-18)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(565, 6, '2026-11-18', '08:00', '08:30', 'BOOKED', 0),
(566, 6, '2026-11-18', '09:00', '09:30', 'AVAILABLE', 0),
(567, 6, '2026-11-18', '10:00', '10:30', 'AVAILABLE', 0),
(568, 6, '2026-11-18', '11:00', '11:30', 'AVAILABLE', 0),
(569, 6, '2026-11-18', '13:00', '13:30', 'BOOKED', 0),
(570, 6, '2026-11-18', '14:00', '14:30', 'AVAILABLE', 0),
(571, 6, '2026-11-18', '15:00', '15:30', 'AVAILABLE', 0),
(572, 6, '2026-11-18', '16:00', '16:30', 'BOOKED', 0);

-- Branch 11 – Gateway (2026-11-18)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(573, 11, '2026-11-18', '08:00', '08:30', 'BOOKED', 0),
(574, 11, '2026-11-18', '09:00', '09:30', 'AVAILABLE', 0),
(575, 11, '2026-11-18', '10:00', '10:30', 'AVAILABLE', 0),
(576, 11, '2026-11-18', '11:00', '11:30', 'AVAILABLE', 0),
(577, 11, '2026-11-18', '13:00', '13:30', 'BOOKED', 0),
(578, 11, '2026-11-18', '14:00', '14:30', 'AVAILABLE', 0),
(579, 11, '2026-11-18', '15:00', '15:30', 'AVAILABLE', 0),
(580, 11, '2026-11-18', '16:00', '16:30', 'BOOKED', 0);

-- Branch 1 – Sandton City (2026-11-23)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(581, 1, '2026-11-23', '08:00', '08:30', 'AVAILABLE', 0),
(582, 1, '2026-11-23', '09:00', '09:30', 'BOOKED', 0),
(583, 1, '2026-11-23', '10:00', '10:30', 'AVAILABLE', 0),
(584, 1, '2026-11-23', '11:00', '11:30', 'BOOKED', 0),
(585, 1, '2026-11-23', '13:00', '13:30', 'AVAILABLE', 0),
(586, 1, '2026-11-23', '14:00', '14:30', 'AVAILABLE', 0),
(587, 1, '2026-11-23', '15:00', '15:30', 'BOOKED', 0),
(588, 1, '2026-11-23', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 6 – V&A Waterfront (2026-11-23)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(589, 6, '2026-11-23', '08:00', '08:30', 'AVAILABLE', 0),
(590, 6, '2026-11-23', '09:00', '09:30', 'BOOKED', 0),
(591, 6, '2026-11-23', '10:00', '10:30', 'AVAILABLE', 0),
(592, 6, '2026-11-23', '11:00', '11:30', 'BOOKED', 0),
(593, 6, '2026-11-23', '13:00', '13:30', 'AVAILABLE', 0),
(594, 6, '2026-11-23', '14:00', '14:30', 'AVAILABLE', 0),
(595, 6, '2026-11-23', '15:00', '15:30', 'BOOKED', 0),
(596, 6, '2026-11-23', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 11 – Gateway (2026-11-23)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(597, 11, '2026-11-23', '08:00', '08:30', 'AVAILABLE', 0),
(598, 11, '2026-11-23', '09:00', '09:30', 'BOOKED', 0),
(599, 11, '2026-11-23', '10:00', '10:30', 'AVAILABLE', 0),
(600, 11, '2026-11-23', '11:00', '11:30', 'BOOKED', 0),
(601, 11, '2026-11-23', '13:00', '13:30', 'AVAILABLE', 0),
(602, 11, '2026-11-23', '14:00', '14:30', 'AVAILABLE', 0),
(603, 11, '2026-11-23', '15:00', '15:30', 'BOOKED', 0),
(604, 11, '2026-11-23', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 1 – Sandton City (2026-11-25)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(605, 1, '2026-11-25', '08:00', '08:30', 'AVAILABLE', 0),
(606, 1, '2026-11-25', '09:00', '09:30', 'AVAILABLE', 0),
(607, 1, '2026-11-25', '10:00', '10:30', 'BOOKED', 0),
(608, 1, '2026-11-25', '11:00', '11:30', 'AVAILABLE', 0),
(609, 1, '2026-11-25', '13:00', '13:30', 'AVAILABLE', 0),
(610, 1, '2026-11-25', '14:00', '14:30', 'BOOKED', 0),
(611, 1, '2026-11-25', '15:00', '15:30', 'AVAILABLE', 0),
(612, 1, '2026-11-25', '16:00', '16:30', 'BOOKED', 0);

-- Branch 6 – V&A Waterfront (2026-11-25)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(613, 6, '2026-11-25', '08:00', '08:30', 'AVAILABLE', 0),
(614, 6, '2026-11-25', '09:00', '09:30', 'AVAILABLE', 0),
(615, 6, '2026-11-25', '10:00', '10:30', 'BOOKED', 0),
(616, 6, '2026-11-25', '11:00', '11:30', 'AVAILABLE', 0),
(617, 6, '2026-11-25', '13:00', '13:30', 'AVAILABLE', 0),
(618, 6, '2026-11-25', '14:00', '14:30', 'BOOKED', 0),
(619, 6, '2026-11-25', '15:00', '15:30', 'AVAILABLE', 0),
(620, 6, '2026-11-25', '16:00', '16:30', 'BOOKED', 0);

-- Branch 11 – Gateway (2026-11-25)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(621, 11, '2026-11-25', '08:00', '08:30', 'AVAILABLE', 0),
(622, 11, '2026-11-25', '09:00', '09:30', 'AVAILABLE', 0),
(623, 11, '2026-11-25', '10:00', '10:30', 'BOOKED', 0),
(624, 11, '2026-11-25', '11:00', '11:30', 'AVAILABLE', 0),
(625, 11, '2026-11-25', '13:00', '13:30', 'AVAILABLE', 0),
(626, 11, '2026-11-25', '14:00', '14:30', 'BOOKED', 0),
(627, 11, '2026-11-25', '15:00', '15:30', 'AVAILABLE', 0),
(628, 11, '2026-11-25', '16:00', '16:30', 'BOOKED', 0);

-- Branch 1 – Sandton City (2026-11-30)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(629, 1, '2026-11-30', '08:00', '08:30', 'BOOKED', 0),
(630, 1, '2026-11-30', '09:00', '09:30', 'AVAILABLE', 0),
(631, 1, '2026-11-30', '10:00', '10:30', 'AVAILABLE', 0),
(632, 1, '2026-11-30', '11:00', '11:30', 'BOOKED', 0),
(633, 1, '2026-11-30', '13:00', '13:30', 'BOOKED', 0),
(634, 1, '2026-11-30', '14:00', '14:30', 'AVAILABLE', 0),
(635, 1, '2026-11-30', '15:00', '15:30', 'AVAILABLE', 0),
(636, 1, '2026-11-30', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 6 – V&A Waterfront (2026-11-30)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(637, 6, '2026-11-30', '08:00', '08:30', 'BOOKED', 0),
(638, 6, '2026-11-30', '09:00', '09:30', 'AVAILABLE', 0),
(639, 6, '2026-11-30', '10:00', '10:30', 'AVAILABLE', 0),
(640, 6, '2026-11-30', '11:00', '11:30', 'BOOKED', 0),
(641, 6, '2026-11-30', '13:00', '13:30', 'BOOKED', 0),
(642, 6, '2026-11-30', '14:00', '14:30', 'AVAILABLE', 0),
(643, 6, '2026-11-30', '15:00', '15:30', 'AVAILABLE', 0),
(644, 6, '2026-11-30', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 11 – Gateway (2026-11-30)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(645, 11, '2026-11-30', '08:00', '08:30', 'BOOKED', 0),
(646, 11, '2026-11-30', '09:00', '09:30', 'AVAILABLE', 0),
(647, 11, '2026-11-30', '10:00', '10:30', 'AVAILABLE', 0),
(648, 11, '2026-11-30', '11:00', '11:30', 'BOOKED', 0),
(649, 11, '2026-11-30', '13:00', '13:30', 'BOOKED', 0),
(650, 11, '2026-11-30', '14:00', '14:30', 'AVAILABLE', 0),
(651, 11, '2026-11-30', '15:00', '15:30', 'AVAILABLE', 0),
(652, 11, '2026-11-30', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 1 – Sandton City (2026-12-02)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(653, 1, '2026-12-02', '08:00', '08:30', 'AVAILABLE', 0),
(654, 1, '2026-12-02', '09:00', '09:30', 'BOOKED', 0),
(655, 1, '2026-12-02', '10:00', '10:30', 'AVAILABLE', 0),
(656, 1, '2026-12-02', '11:00', '11:30', 'AVAILABLE', 0),
(657, 1, '2026-12-02', '13:00', '13:30', 'AVAILABLE', 0),
(658, 1, '2026-12-02', '14:00', '14:30', 'AVAILABLE', 0),
(659, 1, '2026-12-02', '15:00', '15:30', 'BOOKED', 0),
(660, 1, '2026-12-02', '16:00', '16:30', 'BOOKED', 0);

-- Branch 6 – V&A Waterfront (2026-12-02)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(661, 6, '2026-12-02', '08:00', '08:30', 'AVAILABLE', 0),
(662, 6, '2026-12-02', '09:00', '09:30', 'BOOKED', 0),
(663, 6, '2026-12-02', '10:00', '10:30', 'AVAILABLE', 0),
(664, 6, '2026-12-02', '11:00', '11:30', 'AVAILABLE', 0),
(665, 6, '2026-12-02', '13:00', '13:30', 'AVAILABLE', 0),
(666, 6, '2026-12-02', '14:00', '14:30', 'AVAILABLE', 0),
(667, 6, '2026-12-02', '15:00', '15:30', 'BOOKED', 0),
(668, 6, '2026-12-02', '16:00', '16:30', 'BOOKED', 0);

-- Branch 11 – Gateway (2026-12-02)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(669, 11, '2026-12-02', '08:00', '08:30', 'AVAILABLE', 0),
(670, 11, '2026-12-02', '09:00', '09:30', 'BOOKED', 0),
(671, 11, '2026-12-02', '10:00', '10:30', 'AVAILABLE', 0),
(672, 11, '2026-12-02', '11:00', '11:30', 'AVAILABLE', 0),
(673, 11, '2026-12-02', '13:00', '13:30', 'AVAILABLE', 0),
(674, 11, '2026-12-02', '14:00', '14:30', 'AVAILABLE', 0),
(675, 11, '2026-12-02', '15:00', '15:30', 'BOOKED', 0),
(676, 11, '2026-12-02', '16:00', '16:30', 'BOOKED', 0);

-- Branch 1 – Sandton City (2026-12-07)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(677, 1, '2026-12-07', '08:00', '08:30', 'AVAILABLE', 0),
(678, 1, '2026-12-07', '09:00', '09:30', 'AVAILABLE', 0),
(679, 1, '2026-12-07', '10:00', '10:30', 'BOOKED', 0),
(680, 1, '2026-12-07', '11:00', '11:30', 'AVAILABLE', 0),
(681, 1, '2026-12-07', '13:00', '13:30', 'BOOKED', 0),
(682, 1, '2026-12-07', '14:00', '14:30', 'BOOKED', 0),
(683, 1, '2026-12-07', '15:00', '15:30', 'AVAILABLE', 0),
(684, 1, '2026-12-07', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 6 – V&A Waterfront (2026-12-07)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(685, 6, '2026-12-07', '08:00', '08:30', 'AVAILABLE', 0),
(686, 6, '2026-12-07', '09:00', '09:30', 'AVAILABLE', 0),
(687, 6, '2026-12-07', '10:00', '10:30', 'BOOKED', 0),
(688, 6, '2026-12-07', '11:00', '11:30', 'AVAILABLE', 0),
(689, 6, '2026-12-07', '13:00', '13:30', 'BOOKED', 0),
(690, 6, '2026-12-07', '14:00', '14:30', 'BOOKED', 0),
(691, 6, '2026-12-07', '15:00', '15:30', 'AVAILABLE', 0),
(692, 6, '2026-12-07', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 11 – Gateway (2026-12-07)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(693, 11, '2026-12-07', '08:00', '08:30', 'AVAILABLE', 0),
(694, 11, '2026-12-07', '09:00', '09:30', 'AVAILABLE', 0),
(695, 11, '2026-12-07', '10:00', '10:30', 'BOOKED', 0),
(696, 11, '2026-12-07', '11:00', '11:30', 'AVAILABLE', 0),
(697, 11, '2026-12-07', '13:00', '13:30', 'BOOKED', 0),
(698, 11, '2026-12-07', '14:00', '14:30', 'BOOKED', 0),
(699, 11, '2026-12-07', '15:00', '15:30', 'AVAILABLE', 0),
(700, 11, '2026-12-07', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 1 – Sandton City (2026-12-09)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(701, 1, '2026-12-09', '08:00', '08:30', 'BOOKED', 0),
(702, 1, '2026-12-09', '09:00', '09:30', 'AVAILABLE', 0),
(703, 1, '2026-12-09', '10:00', '10:30', 'AVAILABLE', 0),
(704, 1, '2026-12-09', '11:00', '11:30', 'BOOKED', 0),
(705, 1, '2026-12-09', '13:00', '13:30', 'AVAILABLE', 0),
(706, 1, '2026-12-09', '14:00', '14:30', 'AVAILABLE', 0),
(707, 1, '2026-12-09', '15:00', '15:30', 'AVAILABLE', 0),
(708, 1, '2026-12-09', '16:00', '16:30', 'BOOKED', 0);

-- Branch 6 – V&A Waterfront (2026-12-09)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(709, 6, '2026-12-09', '08:00', '08:30', 'BOOKED', 0),
(710, 6, '2026-12-09', '09:00', '09:30', 'AVAILABLE', 0),
(711, 6, '2026-12-09', '10:00', '10:30', 'AVAILABLE', 0),
(712, 6, '2026-12-09', '11:00', '11:30', 'BOOKED', 0),
(713, 6, '2026-12-09', '13:00', '13:30', 'AVAILABLE', 0),
(714, 6, '2026-12-09', '14:00', '14:30', 'AVAILABLE', 0),
(715, 6, '2026-12-09', '15:00', '15:30', 'AVAILABLE', 0),
(716, 6, '2026-12-09', '16:00', '16:30', 'BOOKED', 0);

-- Branch 11 – Gateway (2026-12-09)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(717, 11, '2026-12-09', '08:00', '08:30', 'BOOKED', 0),
(718, 11, '2026-12-09', '09:00', '09:30', 'AVAILABLE', 0),
(719, 11, '2026-12-09', '10:00', '10:30', 'AVAILABLE', 0),
(720, 11, '2026-12-09', '11:00', '11:30', 'BOOKED', 0),
(721, 11, '2026-12-09', '13:00', '13:30', 'AVAILABLE', 0),
(722, 11, '2026-12-09', '14:00', '14:30', 'AVAILABLE', 0),
(723, 11, '2026-12-09', '15:00', '15:30', 'AVAILABLE', 0),
(724, 11, '2026-12-09', '16:00', '16:30', 'BOOKED', 0);

-- Branch 1 – Sandton City (2026-12-14)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(725, 1, '2026-12-14', '08:00', '08:30', 'AVAILABLE', 0),
(726, 1, '2026-12-14', '09:00', '09:30', 'BOOKED', 0),
(727, 1, '2026-12-14', '10:00', '10:30', 'AVAILABLE', 0),
(728, 1, '2026-12-14', '11:00', '11:30', 'AVAILABLE', 0),
(729, 1, '2026-12-14', '13:00', '13:30', 'AVAILABLE', 0),
(730, 1, '2026-12-14', '14:00', '14:30', 'BOOKED', 0),
(731, 1, '2026-12-14', '15:00', '15:30', 'BOOKED', 0),
(732, 1, '2026-12-14', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 6 – V&A Waterfront (2026-12-14)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(733, 6, '2026-12-14', '08:00', '08:30', 'AVAILABLE', 0),
(734, 6, '2026-12-14', '09:00', '09:30', 'BOOKED', 0),
(735, 6, '2026-12-14', '10:00', '10:30', 'AVAILABLE', 0),
(736, 6, '2026-12-14', '11:00', '11:30', 'AVAILABLE', 0),
(737, 6, '2026-12-14', '13:00', '13:30', 'AVAILABLE', 0),
(738, 6, '2026-12-14', '14:00', '14:30', 'BOOKED', 0),
(739, 6, '2026-12-14', '15:00', '15:30', 'BOOKED', 0),
(740, 6, '2026-12-14', '16:00', '16:30', 'AVAILABLE', 0);

-- Branch 11 – Gateway (2026-12-14)
INSERT INTO appointment_slots (id, branch_id, slot_date, start_time, end_time, status, version) VALUES
(741, 11, '2026-12-14', '08:00', '08:30', 'AVAILABLE', 0),
(742, 11, '2026-12-14', '09:00', '09:30', 'BOOKED', 0),
(743, 11, '2026-12-14', '10:00', '10:30', 'AVAILABLE', 0),
(744, 11, '2026-12-14', '11:00', '11:30', 'AVAILABLE', 0),
(745, 11, '2026-12-14', '13:00', '13:30', 'AVAILABLE', 0),
(746, 11, '2026-12-14', '14:00', '14:30', 'BOOKED', 0),
(747, 11, '2026-12-14', '15:00', '15:30', 'BOOKED', 0),
(748, 11, '2026-12-14', '16:00', '16:30', 'AVAILABLE', 0);


-- Appointments for all BOOKED slots above (IDs 16+)
INSERT INTO appointments (id, user_id, slot_id, service_type_id, status, customer_name, customer_phone, customer_email, reference_number, created_at) VALUES
(16, 'demo1@capitec.co.za', 102, 1, 'CONFIRMED', 'Naledi Sithole', '0821234007', 'naledi.s@email.com', 'CAP-260915-016', '2026-09-01 09:00:00'),
(17, 'demo2@capitec.co.za', 104, 2, 'CONFIRMED', 'Johannes Botha', '0741234008', 'jbotha@email.com', 'CAP-260915-017', '2026-09-01 09:00:00'),
(18, 'demo3@capitec.co.za', 106, 3, 'CONFIRMED', 'Lerato Mokoena', '0831234009', 'lerato.m@email.com', 'CAP-260915-018', '2026-09-01 09:00:00'),
(19, 'demo4@capitec.co.za', 110, 4, 'CONFIRMED', 'Fatima Adams', '0821234010', 'fatima.a@email.com', 'CAP-260915-019', '2026-09-01 09:00:00'),
(20, 'demo1@capitec.co.za', 112, 5, 'CONFIRMED', 'Thabo Nkosi', '0831234001', 'thabo.nkosi@email.com', 'CAP-260915-020', '2026-09-01 09:00:00'),
(21, 'demo2@capitec.co.za', 114, 6, 'CONFIRMED', 'Priya Pillay', '0821234002', 'priya.pillay@email.com', 'CAP-260915-021', '2026-09-01 09:00:00'),
(22, 'demo3@capitec.co.za', 118, 7, 'CONFIRMED', 'Zanele Dlamini', '0761234003', 'zanele.d@email.com', 'CAP-260915-022', '2026-09-01 09:00:00'),
(23, 'demo4@capitec.co.za', 120, 8, 'CONFIRMED', 'Sipho Mahlangu', '0741234004', 'sipho.m@email.com', 'CAP-260915-023', '2026-09-01 09:00:00'),
(24, 'demo1@capitec.co.za', 122, 1, 'CONFIRMED', 'Maria van Wyk', '0831234005', 'mvw@email.com', 'CAP-260915-024', '2026-09-01 09:00:00'),
(25, 'demo2@capitec.co.za', 125, 3, 'CONFIRMED', 'Ahmed Moosa', '0761234006', 'ahmed.m@email.com', 'CAP-260917-025', '2026-09-01 09:00:00'),
(26, 'demo3@capitec.co.za', 127, 2, 'CONFIRMED', 'Naledi Sithole', '0821234007', 'naledi.s@email.com', 'CAP-260917-026', '2026-09-01 09:00:00'),
(27, 'demo4@capitec.co.za', 131, 4, 'CONFIRMED', 'Johannes Botha', '0741234008', 'jbotha@email.com', 'CAP-260917-027', '2026-09-01 09:00:00'),
(28, 'demo1@capitec.co.za', 133, 6, 'CONFIRMED', 'Lerato Mokoena', '0831234009', 'lerato.m@email.com', 'CAP-260917-028', '2026-09-01 09:00:00'),
(29, 'demo2@capitec.co.za', 135, 5, 'CONFIRMED', 'Fatima Adams', '0821234010', 'fatima.a@email.com', 'CAP-260917-029', '2026-09-01 09:00:00'),
(30, 'demo3@capitec.co.za', 139, 7, 'CONFIRMED', 'Thabo Nkosi', '0831234001', 'thabo.nkosi@email.com', 'CAP-260917-030', '2026-09-01 09:00:00'),
(31, 'demo4@capitec.co.za', 141, 8, 'CONFIRMED', 'Priya Pillay', '0821234002', 'priya.pillay@email.com', 'CAP-260917-031', '2026-09-01 09:00:00'),
(32, 'demo1@capitec.co.za', 143, 1, 'CONFIRMED', 'Zanele Dlamini', '0761234003', 'zanele.d@email.com', 'CAP-260917-032', '2026-09-01 09:00:00'),
(33, 'demo2@capitec.co.za', 147, 2, 'CONFIRMED', 'Sipho Mahlangu', '0741234004', 'sipho.m@email.com', 'CAP-260917-033', '2026-09-01 09:00:00'),
(34, 'demo3@capitec.co.za', 150, 3, 'CONFIRMED', 'Maria van Wyk', '0831234005', 'mvw@email.com', 'CAP-260922-034', '2026-09-01 09:00:00'),
(35, 'demo4@capitec.co.za', 153, 4, 'CONFIRMED', 'Ahmed Moosa', '0761234006', 'ahmed.m@email.com', 'CAP-260922-035', '2026-09-01 09:00:00');

INSERT INTO appointments (id, user_id, slot_id, service_type_id, status, customer_name, customer_phone, customer_email, reference_number, created_at) VALUES
(36, 'demo1@capitec.co.za', 156, 5, 'CONFIRMED', 'Naledi Sithole', '0821234007', 'naledi.s@email.com', 'CAP-260922-036', '2026-09-01 09:00:00'),
(37, 'demo2@capitec.co.za', 158, 6, 'CONFIRMED', 'Johannes Botha', '0741234008', 'jbotha@email.com', 'CAP-260922-037', '2026-09-01 09:00:00'),
(38, 'demo3@capitec.co.za', 161, 7, 'CONFIRMED', 'Lerato Mokoena', '0831234009', 'lerato.m@email.com', 'CAP-260922-038', '2026-09-01 09:00:00'),
(39, 'demo4@capitec.co.za', 164, 8, 'CONFIRMED', 'Fatima Adams', '0821234010', 'fatima.a@email.com', 'CAP-260922-039', '2026-09-01 09:00:00'),
(40, 'demo1@capitec.co.za', 166, 1, 'CONFIRMED', 'Thabo Nkosi', '0831234001', 'thabo.nkosi@email.com', 'CAP-260922-040', '2026-09-01 09:00:00'),
(41, 'demo2@capitec.co.za', 169, 3, 'CONFIRMED', 'Priya Pillay', '0821234002', 'priya.pillay@email.com', 'CAP-260922-041', '2026-09-01 09:00:00'),
(42, 'demo3@capitec.co.za', 172, 2, 'CONFIRMED', 'Zanele Dlamini', '0761234003', 'zanele.d@email.com', 'CAP-260922-042', '2026-09-01 09:00:00'),
(43, 'demo4@capitec.co.za', 175, 4, 'CONFIRMED', 'Sipho Mahlangu', '0741234004', 'sipho.m@email.com', 'CAP-260923-043', '2026-09-01 09:00:00'),
(44, 'demo1@capitec.co.za', 176, 6, 'CONFIRMED', 'Maria van Wyk', '0831234005', 'mvw@email.com', 'CAP-260923-044', '2026-09-01 09:00:00'),
(45, 'demo2@capitec.co.za', 178, 5, 'CONFIRMED', 'Ahmed Moosa', '0761234006', 'ahmed.m@email.com', 'CAP-260923-045', '2026-09-01 09:00:00'),
(46, 'demo3@capitec.co.za', 183, 7, 'CONFIRMED', 'Naledi Sithole', '0821234007', 'naledi.s@email.com', 'CAP-260923-046', '2026-09-01 09:00:00'),
(47, 'demo4@capitec.co.za', 184, 8, 'CONFIRMED', 'Johannes Botha', '0741234008', 'jbotha@email.com', 'CAP-260923-047', '2026-09-01 09:00:00'),
(48, 'demo1@capitec.co.za', 186, 1, 'CONFIRMED', 'Lerato Mokoena', '0831234009', 'lerato.m@email.com', 'CAP-260923-048', '2026-09-01 09:00:00'),
(49, 'demo2@capitec.co.za', 191, 2, 'CONFIRMED', 'Fatima Adams', '0821234010', 'fatima.a@email.com', 'CAP-260923-049', '2026-09-01 09:00:00'),
(50, 'demo3@capitec.co.za', 192, 3, 'CONFIRMED', 'Thabo Nkosi', '0831234001', 'thabo.nkosi@email.com', 'CAP-260923-050', '2026-09-01 09:00:00'),
(51, 'demo4@capitec.co.za', 194, 4, 'CONFIRMED', 'Priya Pillay', '0821234002', 'priya.pillay@email.com', 'CAP-260923-051', '2026-09-01 09:00:00'),
(52, 'demo1@capitec.co.za', 197, 5, 'CONFIRMED', 'Zanele Dlamini', '0761234003', 'zanele.d@email.com', 'CAP-260929-052', '2026-09-01 09:00:00'),
(53, 'demo2@capitec.co.za', 200, 6, 'CONFIRMED', 'Sipho Mahlangu', '0741234004', 'sipho.m@email.com', 'CAP-260929-053', '2026-09-01 09:00:00'),
(54, 'demo3@capitec.co.za', 203, 7, 'CONFIRMED', 'Maria van Wyk', '0831234005', 'mvw@email.com', 'CAP-260929-054', '2026-09-01 09:00:00'),
(55, 'demo4@capitec.co.za', 205, 8, 'CONFIRMED', 'Ahmed Moosa', '0761234006', 'ahmed.m@email.com', 'CAP-260929-055', '2026-09-01 09:00:00');

INSERT INTO appointments (id, user_id, slot_id, service_type_id, status, customer_name, customer_phone, customer_email, reference_number, created_at) VALUES
(56, 'demo1@capitec.co.za', 208, 1, 'CONFIRMED', 'Naledi Sithole', '0821234007', 'naledi.s@email.com', 'CAP-260929-056', '2026-09-01 09:00:00'),
(57, 'demo2@capitec.co.za', 211, 3, 'CONFIRMED', 'Johannes Botha', '0741234008', 'jbotha@email.com', 'CAP-260929-057', '2026-09-01 09:00:00'),
(58, 'demo3@capitec.co.za', 213, 2, 'CONFIRMED', 'Lerato Mokoena', '0831234009', 'lerato.m@email.com', 'CAP-260929-058', '2026-09-01 09:00:00'),
(59, 'demo4@capitec.co.za', 216, 4, 'CONFIRMED', 'Fatima Adams', '0821234010', 'fatima.a@email.com', 'CAP-260929-059', '2026-09-01 09:00:00'),
(60, 'demo1@capitec.co.za', 219, 6, 'CONFIRMED', 'Thabo Nkosi', '0831234001', 'thabo.nkosi@email.com', 'CAP-260929-060', '2026-09-01 09:00:00'),
(61, 'demo2@capitec.co.za', 222, 5, 'CONFIRMED', 'Priya Pillay', '0821234002', 'priya.pillay@email.com', 'CAP-261001-061', '2026-10-01 09:00:00'),
(62, 'demo3@capitec.co.za', 223, 7, 'CONFIRMED', 'Zanele Dlamini', '0761234003', 'zanele.d@email.com', 'CAP-261001-062', '2026-10-01 09:00:00'),
(63, 'demo4@capitec.co.za', 228, 8, 'CONFIRMED', 'Sipho Mahlangu', '0741234004', 'sipho.m@email.com', 'CAP-261001-063', '2026-10-01 09:00:00'),
(64, 'demo1@capitec.co.za', 230, 1, 'CONFIRMED', 'Maria van Wyk', '0831234005', 'mvw@email.com', 'CAP-261001-064', '2026-10-01 09:00:00'),
(65, 'demo2@capitec.co.za', 231, 2, 'CONFIRMED', 'Ahmed Moosa', '0761234006', 'ahmed.m@email.com', 'CAP-261001-065', '2026-10-01 09:00:00'),
(66, 'demo3@capitec.co.za', 236, 3, 'CONFIRMED', 'Naledi Sithole', '0821234007', 'naledi.s@email.com', 'CAP-261001-066', '2026-10-01 09:00:00'),
(67, 'demo4@capitec.co.za', 238, 4, 'CONFIRMED', 'Johannes Botha', '0741234008', 'jbotha@email.com', 'CAP-261001-067', '2026-10-01 09:00:00'),
(68, 'demo1@capitec.co.za', 239, 5, 'CONFIRMED', 'Lerato Mokoena', '0831234009', 'lerato.m@email.com', 'CAP-261001-068', '2026-10-01 09:00:00'),
(69, 'demo2@capitec.co.za', 244, 6, 'CONFIRMED', 'Fatima Adams', '0821234010', 'fatima.a@email.com', 'CAP-261001-069', '2026-10-01 09:00:00'),
(70, 'demo3@capitec.co.za', 245, 7, 'CONFIRMED', 'Thabo Nkosi', '0831234001', 'thabo.nkosi@email.com', 'CAP-261005-070', '2026-10-01 09:00:00'),
(71, 'demo4@capitec.co.za', 249, 8, 'CONFIRMED', 'Priya Pillay', '0821234002', 'priya.pillay@email.com', 'CAP-261005-071', '2026-10-01 09:00:00'),
(72, 'demo1@capitec.co.za', 250, 1, 'CONFIRMED', 'Zanele Dlamini', '0761234003', 'zanele.d@email.com', 'CAP-261005-072', '2026-10-01 09:00:00'),
(73, 'demo2@capitec.co.za', 253, 3, 'CONFIRMED', 'Sipho Mahlangu', '0741234004', 'sipho.m@email.com', 'CAP-261005-073', '2026-10-01 09:00:00'),
(74, 'demo3@capitec.co.za', 257, 2, 'CONFIRMED', 'Maria van Wyk', '0831234005', 'mvw@email.com', 'CAP-261005-074', '2026-10-01 09:00:00'),
(75, 'demo4@capitec.co.za', 258, 4, 'CONFIRMED', 'Ahmed Moosa', '0761234006', 'ahmed.m@email.com', 'CAP-261005-075', '2026-10-01 09:00:00');

INSERT INTO appointments (id, user_id, slot_id, service_type_id, status, customer_name, customer_phone, customer_email, reference_number, created_at) VALUES
(76, 'demo1@capitec.co.za', 261, 6, 'CONFIRMED', 'Naledi Sithole', '0821234007', 'naledi.s@email.com', 'CAP-261005-076', '2026-10-01 09:00:00'),
(77, 'demo2@capitec.co.za', 265, 5, 'CONFIRMED', 'Johannes Botha', '0741234008', 'jbotha@email.com', 'CAP-261005-077', '2026-10-01 09:00:00'),
(78, 'demo3@capitec.co.za', 266, 7, 'CONFIRMED', 'Lerato Mokoena', '0831234009', 'lerato.m@email.com', 'CAP-261005-078', '2026-10-01 09:00:00'),
(79, 'demo4@capitec.co.za', 271, 8, 'CONFIRMED', 'Fatima Adams', '0821234010', 'fatima.a@email.com', 'CAP-261007-079', '2026-10-01 09:00:00'),
(80, 'demo1@capitec.co.za', 274, 1, 'CONFIRMED', 'Thabo Nkosi', '0831234001', 'thabo.nkosi@email.com', 'CAP-261007-080', '2026-10-01 09:00:00'),
(81, 'demo2@capitec.co.za', 276, 2, 'CONFIRMED', 'Priya Pillay', '0821234002', 'priya.pillay@email.com', 'CAP-261007-081', '2026-10-01 09:00:00'),
(82, 'demo3@capitec.co.za', 279, 3, 'CONFIRMED', 'Zanele Dlamini', '0761234003', 'zanele.d@email.com', 'CAP-261007-082', '2026-10-01 09:00:00'),
(83, 'demo4@capitec.co.za', 282, 4, 'CONFIRMED', 'Sipho Mahlangu', '0741234004', 'sipho.m@email.com', 'CAP-261007-083', '2026-10-01 09:00:00'),
(84, 'demo1@capitec.co.za', 284, 5, 'CONFIRMED', 'Maria van Wyk', '0831234005', 'mvw@email.com', 'CAP-261007-084', '2026-10-01 09:00:00'),
(85, 'demo2@capitec.co.za', 287, 6, 'CONFIRMED', 'Ahmed Moosa', '0761234006', 'ahmed.m@email.com', 'CAP-261007-085', '2026-10-01 09:00:00'),
(86, 'demo3@capitec.co.za', 290, 7, 'CONFIRMED', 'Naledi Sithole', '0821234007', 'naledi.s@email.com', 'CAP-261007-086', '2026-10-01 09:00:00'),
(87, 'demo4@capitec.co.za', 292, 8, 'CONFIRMED', 'Johannes Botha', '0741234008', 'jbotha@email.com', 'CAP-261007-087', '2026-10-01 09:00:00'),
(88, 'demo1@capitec.co.za', 294, 1, 'CONFIRMED', 'Lerato Mokoena', '0831234009', 'lerato.m@email.com', 'CAP-261012-088', '2026-10-01 09:00:00'),
(89, 'demo2@capitec.co.za', 296, 3, 'CONFIRMED', 'Fatima Adams', '0821234010', 'fatima.a@email.com', 'CAP-261012-089', '2026-10-01 09:00:00'),
(90, 'demo3@capitec.co.za', 299, 2, 'CONFIRMED', 'Thabo Nkosi', '0831234001', 'thabo.nkosi@email.com', 'CAP-261012-090', '2026-10-01 09:00:00'),
(91, 'demo4@capitec.co.za', 302, 4, 'CONFIRMED', 'Priya Pillay', '0821234002', 'priya.pillay@email.com', 'CAP-261012-091', '2026-10-01 09:00:00'),
(92, 'demo1@capitec.co.za', 304, 6, 'CONFIRMED', 'Zanele Dlamini', '0761234003', 'zanele.d@email.com', 'CAP-261012-092', '2026-10-01 09:00:00'),
(93, 'demo2@capitec.co.za', 307, 5, 'CONFIRMED', 'Sipho Mahlangu', '0741234004', 'sipho.m@email.com', 'CAP-261012-093', '2026-10-01 09:00:00'),
(94, 'demo3@capitec.co.za', 310, 7, 'CONFIRMED', 'Maria van Wyk', '0831234005', 'mvw@email.com', 'CAP-261012-094', '2026-10-01 09:00:00'),
(95, 'demo4@capitec.co.za', 312, 8, 'CONFIRMED', 'Ahmed Moosa', '0761234006', 'ahmed.m@email.com', 'CAP-261012-095', '2026-10-01 09:00:00');

INSERT INTO appointments (id, user_id, slot_id, service_type_id, status, customer_name, customer_phone, customer_email, reference_number, created_at) VALUES
(96, 'demo1@capitec.co.za', 315, 1, 'CONFIRMED', 'Naledi Sithole', '0821234007', 'naledi.s@email.com', 'CAP-261012-096', '2026-10-01 09:00:00'),
(97, 'demo2@capitec.co.za', 317, 2, 'CONFIRMED', 'Johannes Botha', '0741234008', 'jbotha@email.com', 'CAP-261014-097', '2026-10-01 09:00:00'),
(98, 'demo3@capitec.co.za', 319, 3, 'CONFIRMED', 'Lerato Mokoena', '0831234009', 'lerato.m@email.com', 'CAP-261014-098', '2026-10-01 09:00:00'),
(99, 'demo4@capitec.co.za', 322, 4, 'CONFIRMED', 'Fatima Adams', '0821234010', 'fatima.a@email.com', 'CAP-261014-099', '2026-10-01 09:00:00'),
(100, 'demo1@capitec.co.za', 324, 5, 'CONFIRMED', 'Thabo Nkosi', '0831234001', 'thabo.nkosi@email.com', 'CAP-261014-100', '2026-10-01 09:00:00'),
(101, 'demo2@capitec.co.za', 325, 6, 'CONFIRMED', 'Priya Pillay', '0821234002', 'priya.pillay@email.com', 'CAP-261014-101', '2026-10-01 09:00:00'),
(102, 'demo3@capitec.co.za', 327, 7, 'CONFIRMED', 'Zanele Dlamini', '0761234003', 'zanele.d@email.com', 'CAP-261014-102', '2026-10-01 09:00:00'),
(103, 'demo4@capitec.co.za', 330, 8, 'CONFIRMED', 'Sipho Mahlangu', '0741234004', 'sipho.m@email.com', 'CAP-261014-103', '2026-10-01 09:00:00'),
(104, 'demo1@capitec.co.za', 332, 1, 'CONFIRMED', 'Maria van Wyk', '0831234005', 'mvw@email.com', 'CAP-261014-104', '2026-10-01 09:00:00'),
(105, 'demo2@capitec.co.za', 333, 3, 'CONFIRMED', 'Ahmed Moosa', '0761234006', 'ahmed.m@email.com', 'CAP-261014-105', '2026-10-01 09:00:00'),
(106, 'demo3@capitec.co.za', 335, 2, 'CONFIRMED', 'Naledi Sithole', '0821234007', 'naledi.s@email.com', 'CAP-261014-106', '2026-10-01 09:00:00'),
(107, 'demo4@capitec.co.za', 338, 4, 'CONFIRMED', 'Johannes Botha', '0741234008', 'jbotha@email.com', 'CAP-261014-107', '2026-10-01 09:00:00'),
(108, 'demo1@capitec.co.za', 340, 6, 'CONFIRMED', 'Lerato Mokoena', '0831234009', 'lerato.m@email.com', 'CAP-261014-108', '2026-10-01 09:00:00'),
(109, 'demo2@capitec.co.za', 342, 5, 'CONFIRMED', 'Fatima Adams', '0821234010', 'fatima.a@email.com', 'CAP-261019-109', '2026-10-01 09:00:00'),
(110, 'demo3@capitec.co.za', 345, 7, 'CONFIRMED', 'Thabo Nkosi', '0831234001', 'thabo.nkosi@email.com', 'CAP-261019-110', '2026-10-01 09:00:00'),
(111, 'demo4@capitec.co.za', 347, 8, 'CONFIRMED', 'Priya Pillay', '0821234002', 'priya.pillay@email.com', 'CAP-261019-111', '2026-10-01 09:00:00'),
(112, 'demo1@capitec.co.za', 350, 1, 'CONFIRMED', 'Zanele Dlamini', '0761234003', 'zanele.d@email.com', 'CAP-261019-112', '2026-10-01 09:00:00'),
(113, 'demo2@capitec.co.za', 353, 2, 'CONFIRMED', 'Sipho Mahlangu', '0741234004', 'sipho.m@email.com', 'CAP-261019-113', '2026-10-01 09:00:00'),
(114, 'demo3@capitec.co.za', 355, 3, 'CONFIRMED', 'Maria van Wyk', '0831234005', 'mvw@email.com', 'CAP-261019-114', '2026-10-01 09:00:00'),
(115, 'demo4@capitec.co.za', 358, 4, 'CONFIRMED', 'Ahmed Moosa', '0761234006', 'ahmed.m@email.com', 'CAP-261019-115', '2026-10-01 09:00:00');

INSERT INTO appointments (id, user_id, slot_id, service_type_id, status, customer_name, customer_phone, customer_email, reference_number, created_at) VALUES
(116, 'demo1@capitec.co.za', 361, 5, 'CONFIRMED', 'Naledi Sithole', '0821234007', 'naledi.s@email.com', 'CAP-261019-116', '2026-10-01 09:00:00'),
(117, 'demo2@capitec.co.za', 363, 6, 'CONFIRMED', 'Johannes Botha', '0741234008', 'jbotha@email.com', 'CAP-261019-117', '2026-10-01 09:00:00'),
(118, 'demo3@capitec.co.za', 365, 7, 'CONFIRMED', 'Lerato Mokoena', '0831234009', 'lerato.m@email.com', 'CAP-261021-118', '2026-10-01 09:00:00'),
(119, 'demo4@capitec.co.za', 368, 8, 'CONFIRMED', 'Fatima Adams', '0821234010', 'fatima.a@email.com', 'CAP-261021-119', '2026-10-01 09:00:00'),
(120, 'demo1@capitec.co.za', 372, 1, 'CONFIRMED', 'Thabo Nkosi', '0831234001', 'thabo.nkosi@email.com', 'CAP-261021-120', '2026-10-01 09:00:00'),
(121, 'demo2@capitec.co.za', 373, 3, 'CONFIRMED', 'Priya Pillay', '0821234002', 'priya.pillay@email.com', 'CAP-261021-121', '2026-10-01 09:00:00'),
(122, 'demo3@capitec.co.za', 376, 2, 'CONFIRMED', 'Zanele Dlamini', '0761234003', 'zanele.d@email.com', 'CAP-261021-122', '2026-10-01 09:00:00'),
(123, 'demo4@capitec.co.za', 380, 4, 'CONFIRMED', 'Sipho Mahlangu', '0741234004', 'sipho.m@email.com', 'CAP-261021-123', '2026-10-01 09:00:00'),
(124, 'demo1@capitec.co.za', 381, 6, 'CONFIRMED', 'Maria van Wyk', '0831234005', 'mvw@email.com', 'CAP-261021-124', '2026-10-01 09:00:00'),
(125, 'demo2@capitec.co.za', 384, 5, 'CONFIRMED', 'Ahmed Moosa', '0761234006', 'ahmed.m@email.com', 'CAP-261021-125', '2026-10-01 09:00:00'),
(126, 'demo3@capitec.co.za', 388, 7, 'CONFIRMED', 'Naledi Sithole', '0821234007', 'naledi.s@email.com', 'CAP-261021-126', '2026-10-01 09:00:00'),
(127, 'demo4@capitec.co.za', 391, 8, 'CONFIRMED', 'Johannes Botha', '0741234008', 'jbotha@email.com', 'CAP-261026-127', '2026-10-01 09:00:00'),
(128, 'demo1@capitec.co.za', 393, 1, 'CONFIRMED', 'Lerato Mokoena', '0831234009', 'lerato.m@email.com', 'CAP-261026-128', '2026-10-01 09:00:00'),
(129, 'demo2@capitec.co.za', 394, 2, 'CONFIRMED', 'Fatima Adams', '0821234010', 'fatima.a@email.com', 'CAP-261026-129', '2026-10-01 09:00:00'),
(130, 'demo3@capitec.co.za', 399, 3, 'CONFIRMED', 'Thabo Nkosi', '0831234001', 'thabo.nkosi@email.com', 'CAP-261026-130', '2026-10-01 09:00:00'),
(131, 'demo4@capitec.co.za', 401, 4, 'CONFIRMED', 'Priya Pillay', '0821234002', 'priya.pillay@email.com', 'CAP-261026-131', '2026-10-01 09:00:00'),
(132, 'demo1@capitec.co.za', 402, 5, 'CONFIRMED', 'Zanele Dlamini', '0761234003', 'zanele.d@email.com', 'CAP-261026-132', '2026-10-01 09:00:00'),
(133, 'demo2@capitec.co.za', 407, 6, 'CONFIRMED', 'Sipho Mahlangu', '0741234004', 'sipho.m@email.com', 'CAP-261026-133', '2026-10-01 09:00:00'),
(134, 'demo3@capitec.co.za', 409, 7, 'CONFIRMED', 'Maria van Wyk', '0831234005', 'mvw@email.com', 'CAP-261026-134', '2026-10-01 09:00:00'),
(135, 'demo4@capitec.co.za', 410, 8, 'CONFIRMED', 'Ahmed Moosa', '0761234006', 'ahmed.m@email.com', 'CAP-261026-135', '2026-10-01 09:00:00');

INSERT INTO appointments (id, user_id, slot_id, service_type_id, status, customer_name, customer_phone, customer_email, reference_number, created_at) VALUES
(136, 'demo1@capitec.co.za', 414, 1, 'CONFIRMED', 'Naledi Sithole', '0821234007', 'naledi.s@email.com', 'CAP-261028-136', '2026-10-01 09:00:00'),
(137, 'demo2@capitec.co.za', 416, 3, 'CONFIRMED', 'Johannes Botha', '0741234008', 'jbotha@email.com', 'CAP-261028-137', '2026-10-01 09:00:00'),
(138, 'demo3@capitec.co.za', 419, 2, 'CONFIRMED', 'Lerato Mokoena', '0831234009', 'lerato.m@email.com', 'CAP-261028-138', '2026-10-01 09:00:00'),
(139, 'demo4@capitec.co.za', 422, 4, 'CONFIRMED', 'Fatima Adams', '0821234010', 'fatima.a@email.com', 'CAP-261028-139', '2026-10-01 09:00:00'),
(140, 'demo1@capitec.co.za', 424, 6, 'CONFIRMED', 'Thabo Nkosi', '0831234001', 'thabo.nkosi@email.com', 'CAP-261028-140', '2026-10-01 09:00:00'),
(141, 'demo2@capitec.co.za', 427, 5, 'CONFIRMED', 'Priya Pillay', '0821234002', 'priya.pillay@email.com', 'CAP-261028-141', '2026-10-01 09:00:00'),
(142, 'demo3@capitec.co.za', 430, 7, 'CONFIRMED', 'Zanele Dlamini', '0761234003', 'zanele.d@email.com', 'CAP-261028-142', '2026-10-01 09:00:00'),
(143, 'demo4@capitec.co.za', 432, 8, 'CONFIRMED', 'Sipho Mahlangu', '0741234004', 'sipho.m@email.com', 'CAP-261028-143', '2026-10-01 09:00:00'),
(144, 'demo1@capitec.co.za', 435, 1, 'CONFIRMED', 'Maria van Wyk', '0831234005', 'mvw@email.com', 'CAP-261028-144', '2026-10-01 09:00:00'),
(145, 'demo2@capitec.co.za', 437, 2, 'CONFIRMED', 'Ahmed Moosa', '0761234006', 'ahmed.m@email.com', 'CAP-261102-145', '2026-11-01 09:00:00'),
(146, 'demo3@capitec.co.za', 439, 3, 'CONFIRMED', 'Naledi Sithole', '0821234007', 'naledi.s@email.com', 'CAP-261102-146', '2026-11-01 09:00:00'),
(147, 'demo4@capitec.co.za', 444, 4, 'CONFIRMED', 'Johannes Botha', '0741234008', 'jbotha@email.com', 'CAP-261102-147', '2026-11-01 09:00:00'),
(148, 'demo1@capitec.co.za', 445, 5, 'CONFIRMED', 'Lerato Mokoena', '0831234009', 'lerato.m@email.com', 'CAP-261102-148', '2026-11-01 09:00:00'),
(149, 'demo2@capitec.co.za', 447, 6, 'CONFIRMED', 'Fatima Adams', '0821234010', 'fatima.a@email.com', 'CAP-261102-149', '2026-11-01 09:00:00'),
(150, 'demo3@capitec.co.za', 452, 7, 'CONFIRMED', 'Thabo Nkosi', '0831234001', 'thabo.nkosi@email.com', 'CAP-261102-150', '2026-11-01 09:00:00'),
(151, 'demo4@capitec.co.za', 453, 8, 'CONFIRMED', 'Priya Pillay', '0821234002', 'priya.pillay@email.com', 'CAP-261102-151', '2026-11-01 09:00:00'),
(152, 'demo1@capitec.co.za', 455, 1, 'CONFIRMED', 'Zanele Dlamini', '0761234003', 'zanele.d@email.com', 'CAP-261102-152', '2026-11-01 09:00:00'),
(153, 'demo2@capitec.co.za', 460, 3, 'CONFIRMED', 'Sipho Mahlangu', '0741234004', 'sipho.m@email.com', 'CAP-261102-153', '2026-11-01 09:00:00'),
(154, 'demo3@capitec.co.za', 464, 2, 'CONFIRMED', 'Maria van Wyk', '0831234005', 'mvw@email.com', 'CAP-261104-154', '2026-11-01 09:00:00'),
(155, 'demo4@capitec.co.za', 466, 4, 'CONFIRMED', 'Ahmed Moosa', '0761234006', 'ahmed.m@email.com', 'CAP-261104-155', '2026-11-01 09:00:00');

INSERT INTO appointments (id, user_id, slot_id, service_type_id, status, customer_name, customer_phone, customer_email, reference_number, created_at) VALUES
(156, 'demo1@capitec.co.za', 467, 6, 'CONFIRMED', 'Naledi Sithole', '0821234007', 'naledi.s@email.com', 'CAP-261104-156', '2026-11-01 09:00:00'),
(157, 'demo2@capitec.co.za', 472, 5, 'CONFIRMED', 'Johannes Botha', '0741234008', 'jbotha@email.com', 'CAP-261104-157', '2026-11-01 09:00:00'),
(158, 'demo3@capitec.co.za', 474, 7, 'CONFIRMED', 'Lerato Mokoena', '0831234009', 'lerato.m@email.com', 'CAP-261104-158', '2026-11-01 09:00:00'),
(159, 'demo4@capitec.co.za', 475, 8, 'CONFIRMED', 'Fatima Adams', '0821234010', 'fatima.a@email.com', 'CAP-261104-159', '2026-11-01 09:00:00'),
(160, 'demo1@capitec.co.za', 480, 1, 'CONFIRMED', 'Thabo Nkosi', '0831234001', 'thabo.nkosi@email.com', 'CAP-261104-160', '2026-11-01 09:00:00'),
(161, 'demo2@capitec.co.za', 482, 2, 'CONFIRMED', 'Priya Pillay', '0821234002', 'priya.pillay@email.com', 'CAP-261104-161', '2026-11-01 09:00:00'),
(162, 'demo3@capitec.co.za', 483, 3, 'CONFIRMED', 'Zanele Dlamini', '0761234003', 'zanele.d@email.com', 'CAP-261104-162', '2026-11-01 09:00:00'),
(163, 'demo4@capitec.co.za', 486, 4, 'CONFIRMED', 'Sipho Mahlangu', '0741234004', 'sipho.m@email.com', 'CAP-261109-163', '2026-11-01 09:00:00'),
(164, 'demo1@capitec.co.za', 489, 5, 'CONFIRMED', 'Maria van Wyk', '0831234005', 'mvw@email.com', 'CAP-261109-164', '2026-11-01 09:00:00'),
(165, 'demo2@capitec.co.za', 492, 6, 'CONFIRMED', 'Ahmed Moosa', '0761234006', 'ahmed.m@email.com', 'CAP-261109-165', '2026-11-01 09:00:00'),
(166, 'demo3@capitec.co.za', 494, 7, 'CONFIRMED', 'Naledi Sithole', '0821234007', 'naledi.s@email.com', 'CAP-261109-166', '2026-11-01 09:00:00'),
(167, 'demo4@capitec.co.za', 497, 8, 'CONFIRMED', 'Johannes Botha', '0741234008', 'jbotha@email.com', 'CAP-261109-167', '2026-11-01 09:00:00'),
(168, 'demo1@capitec.co.za', 500, 1, 'CONFIRMED', 'Lerato Mokoena', '0831234009', 'lerato.m@email.com', 'CAP-261109-168', '2026-11-01 09:00:00'),
(169, 'demo2@capitec.co.za', 502, 3, 'CONFIRMED', 'Fatima Adams', '0821234010', 'fatima.a@email.com', 'CAP-261109-169', '2026-11-01 09:00:00'),
(170, 'demo3@capitec.co.za', 505, 2, 'CONFIRMED', 'Thabo Nkosi', '0831234001', 'thabo.nkosi@email.com', 'CAP-261109-170', '2026-11-01 09:00:00'),
(171, 'demo4@capitec.co.za', 508, 4, 'CONFIRMED', 'Priya Pillay', '0821234002', 'priya.pillay@email.com', 'CAP-261109-171', '2026-11-01 09:00:00'),
(172, 'demo1@capitec.co.za', 509, 6, 'CONFIRMED', 'Zanele Dlamini', '0761234003', 'zanele.d@email.com', 'CAP-261111-172', '2026-11-01 09:00:00'),
(173, 'demo2@capitec.co.za', 511, 5, 'CONFIRMED', 'Sipho Mahlangu', '0741234004', 'sipho.m@email.com', 'CAP-261111-173', '2026-11-01 09:00:00'),
(174, 'demo3@capitec.co.za', 515, 7, 'CONFIRMED', 'Maria van Wyk', '0831234005', 'mvw@email.com', 'CAP-261111-174', '2026-11-01 09:00:00'),
(175, 'demo4@capitec.co.za', 517, 8, 'CONFIRMED', 'Ahmed Moosa', '0761234006', 'ahmed.m@email.com', 'CAP-261111-175', '2026-11-01 09:00:00');

INSERT INTO appointments (id, user_id, slot_id, service_type_id, status, customer_name, customer_phone, customer_email, reference_number, created_at) VALUES
(176, 'demo1@capitec.co.za', 519, 1, 'CONFIRMED', 'Naledi Sithole', '0821234007', 'naledi.s@email.com', 'CAP-261111-176', '2026-11-01 09:00:00'),
(177, 'demo2@capitec.co.za', 523, 2, 'CONFIRMED', 'Johannes Botha', '0741234008', 'jbotha@email.com', 'CAP-261111-177', '2026-11-01 09:00:00'),
(178, 'demo3@capitec.co.za', 525, 3, 'CONFIRMED', 'Lerato Mokoena', '0831234009', 'lerato.m@email.com', 'CAP-261111-178', '2026-11-01 09:00:00'),
(179, 'demo4@capitec.co.za', 527, 4, 'CONFIRMED', 'Fatima Adams', '0821234010', 'fatima.a@email.com', 'CAP-261111-179', '2026-11-01 09:00:00'),
(180, 'demo1@capitec.co.za', 531, 5, 'CONFIRMED', 'Thabo Nkosi', '0831234001', 'thabo.nkosi@email.com', 'CAP-261111-180', '2026-11-01 09:00:00'),
(181, 'demo2@capitec.co.za', 535, 6, 'CONFIRMED', 'Priya Pillay', '0821234002', 'priya.pillay@email.com', 'CAP-261116-181', '2026-11-01 09:00:00'),
(182, 'demo3@capitec.co.za', 536, 7, 'CONFIRMED', 'Zanele Dlamini', '0761234003', 'zanele.d@email.com', 'CAP-261116-182', '2026-11-01 09:00:00'),
(183, 'demo4@capitec.co.za', 538, 8, 'CONFIRMED', 'Sipho Mahlangu', '0741234004', 'sipho.m@email.com', 'CAP-261116-183', '2026-11-01 09:00:00'),
(184, 'demo1@capitec.co.za', 543, 1, 'CONFIRMED', 'Maria van Wyk', '0831234005', 'mvw@email.com', 'CAP-261116-184', '2026-11-01 09:00:00'),
(185, 'demo2@capitec.co.za', 544, 3, 'CONFIRMED', 'Ahmed Moosa', '0761234006', 'ahmed.m@email.com', 'CAP-261116-185', '2026-11-01 09:00:00'),
(186, 'demo3@capitec.co.za', 546, 2, 'CONFIRMED', 'Naledi Sithole', '0821234007', 'naledi.s@email.com', 'CAP-261116-186', '2026-11-01 09:00:00'),
(187, 'demo4@capitec.co.za', 551, 4, 'CONFIRMED', 'Johannes Botha', '0741234008', 'jbotha@email.com', 'CAP-261116-187', '2026-11-01 09:00:00'),
(188, 'demo1@capitec.co.za', 552, 6, 'CONFIRMED', 'Lerato Mokoena', '0831234009', 'lerato.m@email.com', 'CAP-261116-188', '2026-11-01 09:00:00'),
(189, 'demo2@capitec.co.za', 554, 5, 'CONFIRMED', 'Fatima Adams', '0821234010', 'fatima.a@email.com', 'CAP-261116-189', '2026-11-01 09:00:00'),
(190, 'demo3@capitec.co.za', 557, 7, 'CONFIRMED', 'Thabo Nkosi', '0831234001', 'thabo.nkosi@email.com', 'CAP-261118-190', '2026-11-01 09:00:00'),
(191, 'demo4@capitec.co.za', 561, 8, 'CONFIRMED', 'Priya Pillay', '0821234002', 'priya.pillay@email.com', 'CAP-261118-191', '2026-11-01 09:00:00'),
(192, 'demo1@capitec.co.za', 564, 1, 'CONFIRMED', 'Zanele Dlamini', '0761234003', 'zanele.d@email.com', 'CAP-261118-192', '2026-11-01 09:00:00'),
(193, 'demo2@capitec.co.za', 565, 2, 'CONFIRMED', 'Sipho Mahlangu', '0741234004', 'sipho.m@email.com', 'CAP-261118-193', '2026-11-01 09:00:00'),
(194, 'demo3@capitec.co.za', 569, 3, 'CONFIRMED', 'Maria van Wyk', '0831234005', 'mvw@email.com', 'CAP-261118-194', '2026-11-01 09:00:00'),
(195, 'demo4@capitec.co.za', 572, 4, 'CONFIRMED', 'Ahmed Moosa', '0761234006', 'ahmed.m@email.com', 'CAP-261118-195', '2026-11-01 09:00:00');

INSERT INTO appointments (id, user_id, slot_id, service_type_id, status, customer_name, customer_phone, customer_email, reference_number, created_at) VALUES
(196, 'demo1@capitec.co.za', 573, 5, 'CONFIRMED', 'Naledi Sithole', '0821234007', 'naledi.s@email.com', 'CAP-261118-196', '2026-11-01 09:00:00'),
(197, 'demo2@capitec.co.za', 577, 6, 'CONFIRMED', 'Johannes Botha', '0741234008', 'jbotha@email.com', 'CAP-261118-197', '2026-11-01 09:00:00'),
(198, 'demo3@capitec.co.za', 580, 7, 'CONFIRMED', 'Lerato Mokoena', '0831234009', 'lerato.m@email.com', 'CAP-261118-198', '2026-11-01 09:00:00'),
(199, 'demo4@capitec.co.za', 582, 8, 'CONFIRMED', 'Fatima Adams', '0821234010', 'fatima.a@email.com', 'CAP-261123-199', '2026-11-01 09:00:00'),
(200, 'demo1@capitec.co.za', 584, 1, 'CONFIRMED', 'Thabo Nkosi', '0831234001', 'thabo.nkosi@email.com', 'CAP-261123-200', '2026-11-01 09:00:00'),
(201, 'demo2@capitec.co.za', 587, 3, 'CONFIRMED', 'Priya Pillay', '0821234002', 'priya.pillay@email.com', 'CAP-261123-201', '2026-11-01 09:00:00'),
(202, 'demo3@capitec.co.za', 590, 2, 'CONFIRMED', 'Zanele Dlamini', '0761234003', 'zanele.d@email.com', 'CAP-261123-202', '2026-11-01 09:00:00'),
(203, 'demo4@capitec.co.za', 592, 4, 'CONFIRMED', 'Sipho Mahlangu', '0741234004', 'sipho.m@email.com', 'CAP-261123-203', '2026-11-01 09:00:00'),
(204, 'demo1@capitec.co.za', 595, 6, 'CONFIRMED', 'Maria van Wyk', '0831234005', 'mvw@email.com', 'CAP-261123-204', '2026-11-01 09:00:00'),
(205, 'demo2@capitec.co.za', 598, 5, 'CONFIRMED', 'Ahmed Moosa', '0761234006', 'ahmed.m@email.com', 'CAP-261123-205', '2026-11-01 09:00:00'),
(206, 'demo3@capitec.co.za', 600, 7, 'CONFIRMED', 'Naledi Sithole', '0821234007', 'naledi.s@email.com', 'CAP-261123-206', '2026-11-01 09:00:00'),
(207, 'demo4@capitec.co.za', 603, 8, 'CONFIRMED', 'Johannes Botha', '0741234008', 'jbotha@email.com', 'CAP-261123-207', '2026-11-01 09:00:00'),
(208, 'demo1@capitec.co.za', 607, 1, 'CONFIRMED', 'Lerato Mokoena', '0831234009', 'lerato.m@email.com', 'CAP-261125-208', '2026-11-01 09:00:00'),
(209, 'demo2@capitec.co.za', 610, 2, 'CONFIRMED', 'Fatima Adams', '0821234010', 'fatima.a@email.com', 'CAP-261125-209', '2026-11-01 09:00:00'),
(210, 'demo3@capitec.co.za', 612, 3, 'CONFIRMED', 'Thabo Nkosi', '0831234001', 'thabo.nkosi@email.com', 'CAP-261125-210', '2026-11-01 09:00:00'),
(211, 'demo4@capitec.co.za', 615, 4, 'CONFIRMED', 'Priya Pillay', '0821234002', 'priya.pillay@email.com', 'CAP-261125-211', '2026-11-01 09:00:00'),
(212, 'demo1@capitec.co.za', 618, 5, 'CONFIRMED', 'Zanele Dlamini', '0761234003', 'zanele.d@email.com', 'CAP-261125-212', '2026-11-01 09:00:00'),
(213, 'demo2@capitec.co.za', 620, 6, 'CONFIRMED', 'Sipho Mahlangu', '0741234004', 'sipho.m@email.com', 'CAP-261125-213', '2026-11-01 09:00:00'),
(214, 'demo3@capitec.co.za', 623, 7, 'CONFIRMED', 'Maria van Wyk', '0831234005', 'mvw@email.com', 'CAP-261125-214', '2026-11-01 09:00:00'),
(215, 'demo4@capitec.co.za', 626, 8, 'CONFIRMED', 'Ahmed Moosa', '0761234006', 'ahmed.m@email.com', 'CAP-261125-215', '2026-11-01 09:00:00');

INSERT INTO appointments (id, user_id, slot_id, service_type_id, status, customer_name, customer_phone, customer_email, reference_number, created_at) VALUES
(216, 'demo1@capitec.co.za', 628, 1, 'CONFIRMED', 'Naledi Sithole', '0821234007', 'naledi.s@email.com', 'CAP-261125-216', '2026-11-01 09:00:00'),
(217, 'demo2@capitec.co.za', 629, 3, 'CONFIRMED', 'Johannes Botha', '0741234008', 'jbotha@email.com', 'CAP-261130-217', '2026-11-01 09:00:00'),
(218, 'demo3@capitec.co.za', 632, 2, 'CONFIRMED', 'Lerato Mokoena', '0831234009', 'lerato.m@email.com', 'CAP-261130-218', '2026-11-01 09:00:00'),
(219, 'demo4@capitec.co.za', 633, 4, 'CONFIRMED', 'Fatima Adams', '0821234010', 'fatima.a@email.com', 'CAP-261130-219', '2026-11-01 09:00:00'),
(220, 'demo1@capitec.co.za', 637, 6, 'CONFIRMED', 'Thabo Nkosi', '0831234001', 'thabo.nkosi@email.com', 'CAP-261130-220', '2026-11-01 09:00:00'),
(221, 'demo2@capitec.co.za', 640, 5, 'CONFIRMED', 'Priya Pillay', '0821234002', 'priya.pillay@email.com', 'CAP-261130-221', '2026-11-01 09:00:00'),
(222, 'demo3@capitec.co.za', 641, 7, 'CONFIRMED', 'Zanele Dlamini', '0761234003', 'zanele.d@email.com', 'CAP-261130-222', '2026-11-01 09:00:00'),
(223, 'demo4@capitec.co.za', 645, 8, 'CONFIRMED', 'Sipho Mahlangu', '0741234004', 'sipho.m@email.com', 'CAP-261130-223', '2026-11-01 09:00:00'),
(224, 'demo1@capitec.co.za', 648, 1, 'CONFIRMED', 'Maria van Wyk', '0831234005', 'mvw@email.com', 'CAP-261130-224', '2026-11-01 09:00:00'),
(225, 'demo2@capitec.co.za', 649, 2, 'CONFIRMED', 'Ahmed Moosa', '0761234006', 'ahmed.m@email.com', 'CAP-261130-225', '2026-11-01 09:00:00'),
(226, 'demo3@capitec.co.za', 654, 3, 'CONFIRMED', 'Naledi Sithole', '0821234007', 'naledi.s@email.com', 'CAP-261202-226', '2026-12-01 09:00:00'),
(227, 'demo4@capitec.co.za', 659, 4, 'CONFIRMED', 'Johannes Botha', '0741234008', 'jbotha@email.com', 'CAP-261202-227', '2026-12-01 09:00:00'),
(228, 'demo1@capitec.co.za', 660, 5, 'CONFIRMED', 'Lerato Mokoena', '0831234009', 'lerato.m@email.com', 'CAP-261202-228', '2026-12-01 09:00:00'),
(229, 'demo2@capitec.co.za', 662, 6, 'CONFIRMED', 'Fatima Adams', '0821234010', 'fatima.a@email.com', 'CAP-261202-229', '2026-12-01 09:00:00'),
(230, 'demo3@capitec.co.za', 667, 7, 'CONFIRMED', 'Thabo Nkosi', '0831234001', 'thabo.nkosi@email.com', 'CAP-261202-230', '2026-12-01 09:00:00'),
(231, 'demo4@capitec.co.za', 668, 8, 'CONFIRMED', 'Priya Pillay', '0821234002', 'priya.pillay@email.com', 'CAP-261202-231', '2026-12-01 09:00:00'),
(232, 'demo1@capitec.co.za', 670, 1, 'CONFIRMED', 'Zanele Dlamini', '0761234003', 'zanele.d@email.com', 'CAP-261202-232', '2026-12-01 09:00:00'),
(233, 'demo2@capitec.co.za', 675, 3, 'CONFIRMED', 'Sipho Mahlangu', '0741234004', 'sipho.m@email.com', 'CAP-261202-233', '2026-12-01 09:00:00'),
(234, 'demo3@capitec.co.za', 676, 2, 'CONFIRMED', 'Maria van Wyk', '0831234005', 'mvw@email.com', 'CAP-261202-234', '2026-12-01 09:00:00'),
(235, 'demo4@capitec.co.za', 679, 4, 'CONFIRMED', 'Ahmed Moosa', '0761234006', 'ahmed.m@email.com', 'CAP-261207-235', '2026-12-01 09:00:00');

INSERT INTO appointments (id, user_id, slot_id, service_type_id, status, customer_name, customer_phone, customer_email, reference_number, created_at) VALUES
(236, 'demo1@capitec.co.za', 681, 6, 'CONFIRMED', 'Naledi Sithole', '0821234007', 'naledi.s@email.com', 'CAP-261207-236', '2026-12-01 09:00:00'),
(237, 'demo2@capitec.co.za', 682, 5, 'CONFIRMED', 'Johannes Botha', '0741234008', 'jbotha@email.com', 'CAP-261207-237', '2026-12-01 09:00:00'),
(238, 'demo3@capitec.co.za', 687, 7, 'CONFIRMED', 'Lerato Mokoena', '0831234009', 'lerato.m@email.com', 'CAP-261207-238', '2026-12-01 09:00:00'),
(239, 'demo4@capitec.co.za', 689, 8, 'CONFIRMED', 'Fatima Adams', '0821234010', 'fatima.a@email.com', 'CAP-261207-239', '2026-12-01 09:00:00'),
(240, 'demo1@capitec.co.za', 690, 1, 'CONFIRMED', 'Thabo Nkosi', '0831234001', 'thabo.nkosi@email.com', 'CAP-261207-240', '2026-12-01 09:00:00'),
(241, 'demo2@capitec.co.za', 695, 2, 'CONFIRMED', 'Priya Pillay', '0821234002', 'priya.pillay@email.com', 'CAP-261207-241', '2026-12-01 09:00:00'),
(242, 'demo3@capitec.co.za', 697, 3, 'CONFIRMED', 'Zanele Dlamini', '0761234003', 'zanele.d@email.com', 'CAP-261207-242', '2026-12-01 09:00:00'),
(243, 'demo4@capitec.co.za', 698, 4, 'CONFIRMED', 'Sipho Mahlangu', '0741234004', 'sipho.m@email.com', 'CAP-261207-243', '2026-12-01 09:00:00'),
(244, 'demo1@capitec.co.za', 701, 5, 'CONFIRMED', 'Maria van Wyk', '0831234005', 'mvw@email.com', 'CAP-261209-244', '2026-12-01 09:00:00'),
(245, 'demo2@capitec.co.za', 704, 6, 'CONFIRMED', 'Ahmed Moosa', '0761234006', 'ahmed.m@email.com', 'CAP-261209-245', '2026-12-01 09:00:00'),
(246, 'demo3@capitec.co.za', 708, 7, 'CONFIRMED', 'Naledi Sithole', '0821234007', 'naledi.s@email.com', 'CAP-261209-246', '2026-12-01 09:00:00'),
(247, 'demo4@capitec.co.za', 709, 8, 'CONFIRMED', 'Johannes Botha', '0741234008', 'jbotha@email.com', 'CAP-261209-247', '2026-12-01 09:00:00'),
(248, 'demo1@capitec.co.za', 712, 1, 'CONFIRMED', 'Lerato Mokoena', '0831234009', 'lerato.m@email.com', 'CAP-261209-248', '2026-12-01 09:00:00'),
(249, 'demo2@capitec.co.za', 716, 3, 'CONFIRMED', 'Fatima Adams', '0821234010', 'fatima.a@email.com', 'CAP-261209-249', '2026-12-01 09:00:00'),
(250, 'demo3@capitec.co.za', 717, 2, 'CONFIRMED', 'Thabo Nkosi', '0831234001', 'thabo.nkosi@email.com', 'CAP-261209-250', '2026-12-01 09:00:00'),
(251, 'demo4@capitec.co.za', 720, 4, 'CONFIRMED', 'Priya Pillay', '0821234002', 'priya.pillay@email.com', 'CAP-261209-251', '2026-12-01 09:00:00'),
(252, 'demo1@capitec.co.za', 724, 6, 'CONFIRMED', 'Zanele Dlamini', '0761234003', 'zanele.d@email.com', 'CAP-261209-252', '2026-12-01 09:00:00'),
(253, 'demo2@capitec.co.za', 726, 5, 'CONFIRMED', 'Sipho Mahlangu', '0741234004', 'sipho.m@email.com', 'CAP-261214-253', '2026-12-01 09:00:00'),
(254, 'demo3@capitec.co.za', 730, 7, 'CONFIRMED', 'Maria van Wyk', '0831234005', 'mvw@email.com', 'CAP-261214-254', '2026-12-01 09:00:00'),
(255, 'demo4@capitec.co.za', 731, 8, 'CONFIRMED', 'Ahmed Moosa', '0761234006', 'ahmed.m@email.com', 'CAP-261214-255', '2026-12-01 09:00:00');

INSERT INTO appointments (id, user_id, slot_id, service_type_id, status, customer_name, customer_phone, customer_email, reference_number, created_at) VALUES
(256, 'demo1@capitec.co.za', 734, 1, 'CONFIRMED', 'Naledi Sithole', '0821234007', 'naledi.s@email.com', 'CAP-261214-256', '2026-12-01 09:00:00'),
(257, 'demo2@capitec.co.za', 738, 2, 'CONFIRMED', 'Johannes Botha', '0741234008', 'jbotha@email.com', 'CAP-261214-257', '2026-12-01 09:00:00'),
(258, 'demo3@capitec.co.za', 739, 3, 'CONFIRMED', 'Lerato Mokoena', '0831234009', 'lerato.m@email.com', 'CAP-261214-258', '2026-12-01 09:00:00'),
(259, 'demo4@capitec.co.za', 742, 4, 'CONFIRMED', 'Fatima Adams', '0821234010', 'fatima.a@email.com', 'CAP-261214-259', '2026-12-01 09:00:00'),
(260, 'demo1@capitec.co.za', 746, 5, 'CONFIRMED', 'Thabo Nkosi', '0831234001', 'thabo.nkosi@email.com', 'CAP-261214-260', '2026-12-01 09:00:00'),
(261, 'demo2@capitec.co.za', 747, 6, 'CONFIRMED', 'Priya Pillay', '0821234002', 'priya.pillay@email.com', 'CAP-261214-261', '2026-12-01 09:00:00');

-- Reset sequences so new rows don't conflict with the seeded IDs
ALTER TABLE appointment_slots ALTER COLUMN id RESTART WITH 749;
ALTER TABLE appointments ALTER COLUMN id RESTART WITH 262;
