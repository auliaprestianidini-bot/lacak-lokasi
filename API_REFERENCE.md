# API Reference

## Phone Analysis

### POST /api/phone/analyze

Analyze a phone number.

**Request:**
```json
{
  "phoneNumber": "+628xxxxxxxxxx",
  "country": "ID"
}
```

**Response:**
```json
{
  "id": "uuid",
  "country": "Indonesia",
  "countryCode": "ID",
  "countryCodeNumeric": "+62",
  "phoneType": "MOBILE",
  "timezone": "Asia/Jakarta",
  "riskLevel": "UNKNOWN",
  "confidence": "MEDIUM"
}
```

## Scam Reports

### GET /api/reports/:phoneNumber

Get scam reports for a phone number.

**Response:**
```json
{
  "phoneNumber": "+628xxxxxxxxxx",
  "totalReports": 5,
  "riskLevel": "HIGH",
  "categories": {
    "Marketplace Scam": 3,
    "Payment Fraud": 2
  },
  "reports": [...]
}
```

### POST /api/reports/submit

Submit a scam report.

**Request:**
```json
{
  "phoneNumber": "+628xxxxxxxxxx",
  "category": "Marketplace Scam",
  "description": "Details of the scam..."
}
```

## Investigation

### POST /api/investigation/create

Create investigation.

**Request:**
```json
{
  "title": "Potential Scam",
  "description": "Details...",
  "phoneNumber": "+628xxxxxxxxxx",
  "priority": "HIGH"
}
```

### POST /api/investigation/:id/evidence

Add evidence to investigation.

**Request:**
```json
{
  "type": "payment",
  "description": "Transaction details",
  "transactionAmount": 100000,
  "evidenceDate": "2026-08-21"
}
```

### GET /api/investigation/:id

Get investigation details.

### POST /api/investigation/:id/report

Generate investigation report.
