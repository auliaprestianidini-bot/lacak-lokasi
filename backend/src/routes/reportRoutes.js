import express from 'express';
import { getScamReports, submitScamReport } from '../services/reportService.js';

const router = express.Router();

router.get('/:phoneNumber', async (req, res) => {
  try {
    const { phoneNumber } = req.params;
    const result = await getScamReports(phoneNumber);
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post('/submit', async (req, res) => {
  try {
    const { phoneNumber, category, description } = req.body;
    if (!phoneNumber || !category) {
      return res.status(400).json({ error: 'Missing required fields' });
    }
    const result = await submitScamReport(phoneNumber, category, description);
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

export default router;
