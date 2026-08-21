# Phone Investigation & Global Scam Tracker

## Deskripsi

Website profesional untuk membantu pengguna melakukan investigasi terhadap nomor telepon yang diduga berkaitan dengan penipuan. Sistem ini mendukung analisis nomor telepon dari berbagai negara di seluruh dunia dengan standar internasional E.164.

## Fitur Utama

### 1. Phone Number Analysis
- Validasi nomor telepon internasional (E.164)
- Identifikasi negara dan wilayah
- Deteksi jenis telepon (Mobile, Fixed Line, VoIP)
- Informasi carrier dan timezone

### 2. Geographic Information
- Analisis data geografis dari berbagai tingkat akurasi (Country, Region, City)
- Peta global dengan Leaflet + OpenStreetMap
- Disclaimer yang jelas tentang limitation

### 3. Scam Report Database
- Koleksi laporan penipuan dari berbagai kategori
- Risk level assessment
- Source tracking

### 4. Investigation Tools
- Investigation timeline untuk mencatat bukti
- Payment investigation module
- Comprehensive investigation report generator

### 5. Risk Analysis System
- Penilaian risiko berdasarkan multiple factors
- Risk level categorization (LOW, MEDIUM, HIGH, UNKNOWN)
- Data confidence scoring

## Arsitektur Teknis

```
phone-investigation/
├── frontend/                 # React + Vite
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   ├── services/
│   │   ├── hooks/
│   │   ├── utils/
│   │   ├── styles/
│   │   └── App.jsx
│   └── package.json
│
├── backend/                  # Node.js + Express
│   ├── src/
│   │   ├── controllers/
│   │   ├── routes/
│   │   ├── services/
│   │   ├── middleware/
│   │   ├── models/
│   │   ├── utils/
│   │   ├── validators/
│   │   └── server.js
│   └── package.json
│
├── database/
│   ├── schema.sql
│   ├── seeds.sql
│   └── migrations/
│
├── docs/
│   ├── API.md
│   ├── DATABASE.md
│   └── DEPLOYMENT.md
│
├── .env.example
├── .gitignore
└── README.md
```

## Tech Stack

### Frontend
- **React** 18+ dengan Vite
- **Tailwind CSS** untuk styling
- **Leaflet + OpenStreetMap** untuk peta
- **Axios** untuk HTTP requests
- **React Router** untuk navigation
- **Zustand** untuk state management

### Backend
- **Node.js** + **Express.js**
- **PostgreSQL** untuk database
- **libphonenumber-js** untuk phone parsing
- **jsonwebtoken** untuk authentication
- **bcryptjs** untuk password hashing
- **express-rate-limit** untuk rate limiting
- **helmet** untuk security
- **zod** untuk validation

### External APIs
- **Twilio Phone Lookup** (optional) - untuk phone validation
- **OpenCage Geocoding** (optional) - untuk geolocation
- **Google Maps API** (optional) - untuk map features

## Setup & Installation

### Prerequisites
- Node.js >= 18
- PostgreSQL >= 12
- Git

### 1. Clone Repository
```bash
git clone https://github.com/auliaprestianidini-bot/lacak-lokasi.git
cd lacak-lokasi
checkout feat/phone-investigation-system
```

### 2. Setup Environment Variables
```bash
cp .env.example .env
# Edit .env dengan konfigurasi Anda
```

### 3. Setup Database
```bash
# Buat database
creatdb phone_investigation

# Run migrations
psql phone_investigation < database/schema.sql
```

### 4. Setup Backend
```bash
cd backend
npm install
npm run dev
```

### 5. Setup Frontend
```bash
cd frontend
npm install
npm run dev
```

### 6. Access Application
- Frontend: http://localhost:5173
- Backend: http://localhost:5000
- API Docs: http://localhost:5000/api/docs

## Usage

### Basic Phone Analysis
```bash
POST /api/phone/analyze
Content-Type: application/json

{
  "phoneNumber": "+628xxxxxxxxxx",
  "country": "ID"
}
```

### Get Phone Details
```bash
GET /api/phone/:phoneNumberHash
```

### Get Scam Reports
```bash
GET /api/reports/:phoneNumber
```

### Submit Investigation
```bash
POST /api/investigation
Content-Type: application/json

{
  "title": "Potential Scam Case",
  "phoneNumber": "+628xxxxxxxxxx",
  "notes": "Details...",
  "timeline": [...],
  "evidence": [...]
}
```

### Generate Report
```bash
POST /api/report/generate
Content-Type: application/json

{
  "investigationId": "uuid",
  "format": "pdf" // or "html"
}
```

## Security Features

✅ HTTPS support  
✅ JWT authentication & authorization  
✅ Rate limiting  
✅ Input validation & sanitization  
✅ SQL injection protection  
✅ XSS protection  
✅ CSRF protection  
✅ Data encryption untuk sensitive info  
✅ Audit logging  
✅ Session expiration  
✅ Access control & role-based permissions  

## Anti-False-Data System

**Sistem validasi ketat untuk mencegah data palsu:**

✅ Hanya menampilkan data yang benar-benar tersedia dari sumber  
✅ Tidak membuat koordinat GPS palsu  
✅ Tidak membuat alamat palsu  
✅ Tidak membuat nama pemilik palsu  
✅ Tidak membuat laporan penipuan palsu  
✅ Clear accuracy level indicators  
✅ Source attribution untuk semua data  
✅ Timestamp untuk data freshness  

## Global Phone Support

Sistem mendukung nomor telepon dari seluruh dunia:

```
+62 = Indonesia          +60 = Malaysia
+65 = Singapura         +66 = Thailand
+63 = Filipina          +81 = Jepang
+82 = Korea Selatan     +91 = India
+61 = Australia         +44 = United Kingdom
+1  = USA/Canada        +33 = Prancis
+49 = Jerman            +39 = Italia
dan lebih dari 190 negara lainnya...
```

## Data Sources

Setiap informasi harus memiliki sumber yang jelas:

- **Official API** - Data dari API resmi (Twilio, OpenCage, dll)
- **Public Database** - Data dari database publik (libphonenumber, OpenStreetMap)
- **User Submitted Report** - Laporan dari pengguna yang verified
- **Last Checked Timestamp** - Menunjukkan freshness data

## Important Disclaimers

⚠️ **Phone numbering information** may indicate a numbering region, but it does not necessarily represent the person's current physical location.

⚠️ **This report** summarizes available information and does not establish the identity, current location, or criminal responsibility of the phone number owner.

⚠️ **System limitations:**
- No OTP requests
- No SMS/WhatsApp sending
- No social engineering
- No device security bypass
- No carrier system bypass
- No GPS real-time tracking

## Privacy & Data Protection

- Nomor telepon sensitif diproteksi dengan hashing
- Data user encrypted
- Compliance dengan privacy regulations
- Audit log untuk semua aktivitas
- GDPR-ready untuk EU users

## Development

### Run Tests
```bash
cd backend
npm run test

cd ../frontend
npm run test
```

### Build for Production
```bash
# Frontend
cd frontend
npm run build

# Backend
cd backend
npm run build
```

### Deploy
Lihat file `docs/DEPLOYMENT.md` untuk detailed instructions.

## Contributing

1. Create feature branch dari `feat/phone-investigation-system`
2. Commit changes dengan meaningful messages
3. Push ke branch
4. Create Pull Request

## License

MIT License

## Contact & Support

Untuk pertanyaan atau support, hubungi:
- Email: support@phone-investigation.local
- Issues: GitHub Issues
- Documentation: `/docs` folder

## Changelog

### v1.0.0 (Initial Release)
- ✅ Phone number analysis & validation
- ✅ Global geographic information
- ✅ Scam report database
- ✅ Investigation timeline
- ✅ Risk assessment system
- ✅ Report generation
- ✅ Global map visualization
- ✅ Payment investigation module

---

**Last Updated:** August 2026
**Status:** Active Development
