-- Phone Investigation & Global Scam Tracker Database Schema
-- PostgreSQL Schema

-- Create Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Users Table
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  full_name VARCHAR(255),
  role VARCHAR(50) DEFAULT 'user', -- admin, moderator, user
  is_active BOOLEAN DEFAULT true,
  email_verified BOOLEAN DEFAULT false,
  email_verified_at TIMESTAMP,
  last_login TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);

-- Phone Analysis Table
CREATE TABLE IF NOT EXISTS phone_analysis (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  phone_number_hash VARCHAR(255) UNIQUE NOT NULL,
  phone_number_encrypted BYTEA, -- Encrypted phone number for privacy
  country VARCHAR(100),
  country_code VARCHAR(3), -- ISO 2-letter code (ID, US, etc)
  country_code_numeric VARCHAR(5), -- E.164 country code (+62, +1, etc)
  phone_type VARCHAR(50), -- Mobile, Fixed Line, VoIP, Unknown
  carrier VARCHAR(255),
  numbering_region VARCHAR(255),
  timezone VARCHAR(100),
  risk_level VARCHAR(20) DEFAULT 'UNKNOWN', -- LOW, MEDIUM, HIGH, UNKNOWN
  confidence VARCHAR(20) DEFAULT 'UNKNOWN', -- HIGH, MEDIUM, LOW, UNKNOWN
  total_reports INTEGER DEFAULT 0,
  last_checked TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_phone_analysis_hash ON phone_analysis(phone_number_hash);
CREATE INDEX idx_phone_analysis_country ON phone_analysis(country_code);
CREATE INDEX idx_phone_analysis_risk ON phone_analysis(risk_level);
CREATE INDEX idx_phone_analysis_created ON phone_analysis(created_at DESC);

-- Geographic Data Table
CREATE TABLE IF NOT EXISTS geographic_data (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  phone_analysis_id UUID NOT NULL REFERENCES phone_analysis(id) ON DELETE CASCADE,
  country VARCHAR(100),
  region VARCHAR(255), -- State, Province, or Region name
  city VARCHAR(255),
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  accuracy_level VARCHAR(50), -- Country Level, Region Level, City Level, Exact Coordinate, Unknown
  accuracy_meters INTEGER, -- Radius of accuracy in meters
  source VARCHAR(100), -- API source name
  source_type VARCHAR(50), -- Official API, Public Database, User Submitted
  timestamp TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_geographic_data_phone ON geographic_data(phone_analysis_id);
CREATE INDEX idx_geographic_data_accuracy ON geographic_data(accuracy_level);
CREATE INDEX idx_geographic_data_location ON geographic_data(latitude, longitude);

-- Scam Report Table
CREATE TABLE IF NOT EXISTS scam_reports (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  phone_number_hash VARCHAR(255) NOT NULL,
  phone_analysis_id UUID REFERENCES phone_analysis(id) ON DELETE SET NULL,
  category VARCHAR(100) NOT NULL, -- Online Shop Scam, Investment Scam, Loan Scam, etc
  description TEXT,
  source VARCHAR(100), -- Report source identifier
  source_type VARCHAR(50), -- Official API, Public Database, User Submitted
  reporter_id UUID REFERENCES users(id) ON DELETE SET NULL,
  report_date TIMESTAMP,
  is_verified BOOLEAN DEFAULT false,
  verification_count INTEGER DEFAULT 0,
  is_resolved BOOLEAN DEFAULT false,
  resolved_at TIMESTAMP,
  resolution_notes TEXT,
  risk_level VARCHAR(20) DEFAULT 'UNKNOWN', -- LOW, MEDIUM, HIGH
  confidence VARCHAR(20) DEFAULT 'UNKNOWN', -- HIGH, MEDIUM, LOW
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  deleted_at TIMESTAMP
);

CREATE INDEX idx_scam_reports_hash ON scam_reports(phone_number_hash);
CREATE INDEX idx_scam_reports_category ON scam_reports(category);
CREATE INDEX idx_scam_reports_risk ON scam_reports(risk_level);
CREATE INDEX idx_scam_reports_verified ON scam_reports(is_verified);
CREATE INDEX idx_scam_reports_created ON scam_reports(created_at DESC);

-- Scam Report Categories
CREATE TABLE IF NOT EXISTS scam_categories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(100) UNIQUE NOT NULL,
  description TEXT,
  icon VARCHAR(100),
  color VARCHAR(20),
  severity_level INTEGER DEFAULT 1, -- 1-5 scale
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Investigation Table
CREATE TABLE IF NOT EXISTS investigations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  phone_number_hash VARCHAR(255),
  phone_analysis_id UUID REFERENCES phone_analysis(id) ON DELETE SET NULL,
  status VARCHAR(50) DEFAULT 'OPEN', -- OPEN, INVESTIGATING, CLOSED, RESOLVED
  priority VARCHAR(20) DEFAULT 'MEDIUM', -- LOW, MEDIUM, HIGH, URGENT
  notes TEXT,
  conclusion TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  closed_at TIMESTAMP,
  deleted_at TIMESTAMP
);

CREATE INDEX idx_investigations_user ON investigations(user_id);
CREATE INDEX idx_investigations_status ON investigations(status);
CREATE INDEX idx_investigations_priority ON investigations(priority);
CREATE INDEX idx_investigations_created ON investigations(created_at DESC);

-- Investigation Timeline Evidence Table
CREATE TABLE IF NOT EXISTS investigation_evidence (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  investigation_id UUID NOT NULL REFERENCES investigations(id) ON DELETE CASCADE,
  type VARCHAR(50) NOT NULL, -- contact, payment, message, document, screenshot, etc
  description TEXT,
  phone_number VARCHAR(20),
  name_or_username VARCHAR(255),
  platform VARCHAR(100), -- WhatsApp, Telegram, Marketplace, etc
  bank_name VARCHAR(100),
  account_number VARCHAR(100),
  account_name VARCHAR(255),
  ewallet_name VARCHAR(100),
  ewallet_account VARCHAR(100),
  transaction_amount DECIMAL(15, 2),
  transaction_currency VARCHAR(10),
  evidence_date TIMESTAMP NOT NULL,
  evidence_time TIME,
  attachment_url VARCHAR(500),
  metadata JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_investigation_evidence_investigation ON investigation_evidence(investigation_id);
CREATE INDEX idx_investigation_evidence_type ON investigation_evidence(type);
CREATE INDEX idx_investigation_evidence_date ON investigation_evidence(evidence_date DESC);

-- Payment Investigation Table
CREATE TABLE IF NOT EXISTS payment_investigations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  investigation_id UUID REFERENCES investigations(id) ON DELETE SET NULL,
  payment_type VARCHAR(50) NOT NULL, -- bank, ewallet, crypto
  bank_name VARCHAR(100),
  account_number_hash VARCHAR(255),
  account_name VARCHAR(255),
  ewallet_provider VARCHAR(100),
  ewallet_account_hash VARCHAR(255),
  crypto_address VARCHAR(255),
  crypto_type VARCHAR(50),
  status VARCHAR(50) DEFAULT 'UNVERIFIED', -- UNVERIFIED, INVESTIGATING, CONFIRMED, CLEARED
  risk_level VARCHAR(20) DEFAULT 'UNKNOWN',
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_payment_investigations_investigation ON payment_investigations(investigation_id);
CREATE INDEX idx_payment_investigations_type ON payment_investigations(payment_type);
CREATE INDEX idx_payment_investigations_status ON payment_investigations(status);

-- Investigation Reports Table
CREATE TABLE IF NOT EXISTS investigation_reports (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  investigation_id UUID NOT NULL REFERENCES investigations(id) ON DELETE CASCADE,
  generated_by UUID NOT NULL REFERENCES users(id),
  title VARCHAR(255),
  content TEXT,
  phone_number VARCHAR(20),
  country VARCHAR(100),
  country_code VARCHAR(5),
  carrier VARCHAR(255),
  numbering_region VARCHAR(255),
  geographic_info JSONB,
  scam_reports_summary JSONB,
  risk_level VARCHAR(20),
  payment_evidence JSONB,
  timeline JSONB,
  sources_used TEXT[],
  data_confidence VARCHAR(20),
  last_checked TIMESTAMP,
  format VARCHAR(20) DEFAULT 'html', -- html, pdf, json
  file_path VARCHAR(500),
  report_date TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_investigation_reports_investigation ON investigation_reports(investigation_id);
CREATE INDEX idx_investigation_reports_generated_by ON investigation_reports(generated_by);
CREATE INDEX idx_investigation_reports_created ON investigation_reports(created_at DESC);

-- Phone Analysis Cache Table
CREATE TABLE IF NOT EXISTS phone_analysis_cache (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  phone_number_hash VARCHAR(255) UNIQUE NOT NULL,
  country_code VARCHAR(3),
  carrier_name VARCHAR(255),
  carrier_type VARCHAR(50),
  timezone VARCHAR(100),
  region VARCHAR(255),
  city VARCHAR(255),
  api_response JSONB,
  api_source VARCHAR(100),
  last_updated TIMESTAMP,
  expires_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_phone_analysis_cache_hash ON phone_analysis_cache(phone_number_hash);
CREATE INDEX idx_phone_analysis_cache_expires ON phone_analysis_cache(expires_at);

-- Audit Log Table
CREATE TABLE IF NOT EXISTS audit_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id),
  action VARCHAR(100) NOT NULL,
  resource_type VARCHAR(100),
  resource_id UUID,
  old_values JSONB,
  new_values JSONB,
  ip_address INET,
  user_agent TEXT,
  status VARCHAR(20) DEFAULT 'SUCCESS', -- SUCCESS, FAILED
  error_message TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_audit_logs_user ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_action ON audit_logs(action);
CREATE INDEX idx_audit_logs_created ON audit_logs(created_at DESC);

-- Session Table
CREATE TABLE IF NOT EXISTS sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  token VARCHAR(500) UNIQUE NOT NULL,
  ip_address INET,
  user_agent TEXT,
  expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  revoked_at TIMESTAMP
);

CREATE INDEX idx_sessions_user ON sessions(user_id);
CREATE INDEX idx_sessions_token ON sessions(token);
CREATE INDEX idx_sessions_expires ON sessions(expires_at);

-- API Keys Table (for external API integrations)
CREATE TABLE IF NOT EXISTS api_keys (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  key_name VARCHAR(100) NOT NULL,
  key_hash VARCHAR(255) UNIQUE NOT NULL,
  api_provider VARCHAR(100), -- Twilio, OpenCage, Google Maps, etc
  is_active BOOLEAN DEFAULT true,
  last_used TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_api_keys_user ON api_keys(user_id);
CREATE INDEX idx_api_keys_provider ON api_keys(api_provider);

-- Country Metadata Table
CREATE TABLE IF NOT EXISTS country_metadata (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  country_name VARCHAR(100) NOT NULL UNIQUE,
  country_code VARCHAR(3) UNIQUE NOT NULL,
  country_code_numeric VARCHAR(5),
  region VARCHAR(100),
  timezone VARCHAR(100),
  currency_code VARCHAR(3),
  phone_country_code VARCHAR(5),
  is_scam_hotspot BOOLEAN DEFAULT false,
  scam_risk_level VARCHAR(20) DEFAULT 'MEDIUM',
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_country_metadata_code ON country_metadata(country_code);
CREATE INDEX idx_country_metadata_numeric ON country_metadata(country_code_numeric);

-- Rate Limiting Table
CREATE TABLE IF NOT EXISTS rate_limits (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  endpoint VARCHAR(255),
  request_count INTEGER DEFAULT 1,
  window_start TIMESTAMP,
  window_end TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_rate_limits_user ON rate_limits(user_id);
CREATE INDEX idx_rate_limits_endpoint ON rate_limits(endpoint);
CREATE INDEX idx_rate_limits_window ON rate_limits(window_end);

-- Refresh tokens table
CREATE TABLE IF NOT EXISTS refresh_tokens (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  token VARCHAR(500) UNIQUE NOT NULL,
  expires_at TIMESTAMP NOT NULL,
  revoked_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_refresh_tokens_user ON refresh_tokens(user_id);
CREATE INDEX idx_refresh_tokens_token ON refresh_tokens(token);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply triggers
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_phone_analysis_updated_at BEFORE UPDATE ON phone_analysis
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_geographic_data_updated_at BEFORE UPDATE ON geographic_data
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_scam_reports_updated_at BEFORE UPDATE ON scam_reports
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_investigations_updated_at BEFORE UPDATE ON investigations
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_investigation_evidence_updated_at BEFORE UPDATE ON investigation_evidence
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert sample scam categories
INSERT INTO scam_categories (name, description, severity_level) VALUES
('Online Shop Scam', 'Fraudulent online marketplace transactions', 4),
('Investment Scam', 'Fake investment opportunities and schemes', 5),
('Loan Scam', 'Unauthorized or fraudulent loan offerings', 4),
('Romance Scam', 'Emotional manipulation for financial gain', 4),
('Phishing', 'Attempts to steal credentials or personal info', 4),
('Fake Customer Service', 'Impersonation of legitimate company support', 3),
('Fake Bank', 'Impersonation of financial institutions', 5),
('Marketplace Scam', 'Fraudulent marketplace seller activity', 3),
('Payment Fraud', 'Unauthorized payment requests', 4),
('Job Scam', 'Fake job offers or employment fraud', 3),
('Giveaway Scam', 'Fake prize or giveaway scams', 2),
('Other', 'Other types of scam reports', 2)
ON CONFLICT (name) DO NOTHING;
