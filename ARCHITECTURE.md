# System Architecture

## Frontend Architecture

```
React App (Vite)
├── Pages
│   ├── Home.jsx
│   └── Investigations.jsx
├── Components
│   ├── Navbar.jsx
│   ├── PhoneSearchForm.jsx
│   ├── AnalysisResult.jsx
│   ├── GlobalMap.jsx
│   ├── InvestigationTimeline.jsx
│   └── ReportGenerator.jsx
├── Services
│   └── api.js (Axios client)
├── Store
│   └── store.js (Zustand state)
└── Styles
    └── index.css (Tailwind)
```

## Backend Architecture

```
Express Server
├── Routes
│   ├── phoneRoutes.js
│   ├── reportRoutes.js
│   └── investigationRoutes.js
├── Services
│   ├── phoneService.js
│   ├── reportService.js
│   └── investigationService.js
├── Middleware
│   ├── auth.js
│   └── errorHandler.js
├── Validators
│   └── phoneValidator.js
├── Database
│   └── connection.js
└── Server.js
```

## Database Schema

```
Core Tables:
- phone_analysis (phone data & cache)
- geographic_data (location information)
- scam_reports (report database)
- investigations (user investigations)
- investigation_evidence (timeline)

Support Tables:
- users
- sessions
- audit_logs
- payment_investigations
- country_metadata
- rate_limits
```

## Data Flow

1. User enters phone number
2. Frontend validates format
3. Sends to /api/phone/analyze
4. Backend parses with libphonenumber
5. Queries database for cached data
6. Simultaneously fetches scam reports
7. Calculates risk level
8. Returns complete analysis
9. Frontend displays with map
10. User can create investigation
