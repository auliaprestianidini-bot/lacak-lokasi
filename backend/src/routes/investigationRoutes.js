import express from 'express';
import { createInvestigation, addEvidence, getInvestigation, generateReport } from '../services/investigationService.js';

const router = express.Router();

router.post('/create', async (req, res) => {
  try {
    const { title, description, phoneNumber, priority } = req.body;
    const result = await createInvestigation('user-id', { title, description, phoneNumber, priority });
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post('/:id/evidence', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await addEvidence(id, req.body);
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await getInvestigation(id);
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post('/:id/report', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await generateReport(id);
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

export default router;
