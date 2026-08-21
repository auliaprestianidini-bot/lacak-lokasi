import { isValidPhoneNumber } from 'libphonenumber-js';

export const validatePhoneNumber = (phoneNumber, country) => {
  if (!phoneNumber) return { valid: false, error: 'Phone number required' };
  if (!isValidPhoneNumber(phoneNumber, country)) {
    return { valid: false, error: 'Invalid phone number format' };
  }
  return { valid: true };
};

export const validateReportSubmission = (data) => {
  if (!data.phoneNumber) return { valid: false, error: 'Phone number required' };
  if (!data.category) return { valid: false, error: 'Category required' };
  if (!data.description) return { valid: false, error: 'Description required' };
  return { valid: true };
};
