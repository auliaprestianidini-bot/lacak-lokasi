# Phone Investigation Backend

## Setup

```bash
npm install
cp ../.env.example ../.env
npm run dev
```

## API Endpoints

### Phone Analysis
- `POST /api/phone/analyze` - Analyze phone number

### Scam Reports
- `GET /api/reports/:phoneNumber` - Get reports
- `POST /api/reports/submit` - Submit report

### Investigation
- `POST /api/investigation/create` - Create
- `POST /api/investigation/:id/evidence` - Add evidence
- `GET /api/investigation/:id` - Get details
- `POST /api/investigation/:id/report` - Generate report

## Services

- phoneService.js - Phone analysis logic
- reportService.js - Report management
- investigationService.js - Investigation tracking
