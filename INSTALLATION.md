# Installation & Setup Guide

## Prerequisites
- Node.js >= 18
- PostgreSQL >= 12
- Git

## Database Setup

```bash
# Create database
createdb phone_investigation

# Run schema
psql phone_investigation < database/schema.sql
```

## Backend Setup

```bash
cd backend
npm install

# Create .env in root
echo 'DATABASE_URL=postgresql://user:password@localhost:5432/phone_investigation' > ../.env
echo 'PORT=5000' >> ../.env
echo 'JWT_SECRET=your_secret_key' >> ../.env

# Run
npm run dev
```

## Frontend Setup

```bash
cd frontend
npm install
npm run dev
```

## Access

- Frontend: http://localhost:5173
- Backend: http://localhost:5000
- API Health: http://localhost:5000/api/health

## Testing

```bash
# Test phone analysis
curl -X POST http://localhost:5000/api/phone/analyze \
  -H 'Content-Type: application/json' \
  -d '{"phoneNumber": "+628xxxxxxxxxx", "country": "ID"}'
```
