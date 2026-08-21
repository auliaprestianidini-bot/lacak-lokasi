# Deployment Guide

## Production Environment Variables

```bash
NODE_ENV=production
PORT=5000
DATABASE_URL=postgresql://...
JWT_SECRET=<strong-random-key>
JWT_EXPIRE=7d
```

## Database Migration

```bash
# Create production database
createdb phone_investigation_prod

# Run schema
psql phone_investigation_prod < database/schema.sql
```

## Backend Deployment (Node.js)

### Option 1: PM2

```bash
npm install -g pm2
cd backend
npm install
pm2 start src/server.js --name phone-investigation
pm2 save
```

### Option 2: Docker

```dockerfile
FROM node:18
WORKDIR /app
COPY backend/package*.json ./
RUN npm ci --only=production
COPY backend/src ./src
EXPOSE 5000
CMD ["node", "src/server.js"]
```

### Option 3: Heroku

```bash
heroku create phone-investigation
heroku addons:create heroku-postgresql:standard-0
git push heroku main
```

## Frontend Deployment

### Build

```bash
cd frontend
npm run build
```

### Option 1: Vercel

```bash
npm install -g vercel
vercel
```

### Option 2: Netlify

```bash
npm run build
# Deploy dist folder
```

### Option 3: Docker

```dockerfile
FROM node:18 AS build
WORKDIR /app
COPY frontend/package*.json ./
RUN npm ci
COPY frontend/src ./src
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

## SSL/HTTPS

```bash
# Using Let's Encrypt with Certbot
sudo certbot certonly --standalone -d yourdomain.com
```

## Monitoring

```bash
# PM2 monitoring
pm2 monit

# Database monitoring
watch -n 1 'psql phone_investigation -c "SELECT count(*) FROM phone_analysis;"'
```

## Backup Strategy

```bash
# Database backup
pg_dump phone_investigation > backup-$(date +%Y%m%d).sql

# Automated daily backup
0 2 * * * pg_dump phone_investigation | gzip > /backups/phone_investigation-$(date +\%Y\%m\%d).sql.gz
```
