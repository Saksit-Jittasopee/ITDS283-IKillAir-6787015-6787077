import express from 'express';
import {
  getNotifications,
  createNotification,
  updateNotification,
  deleteNotification
} from '../controllers/notiController.js';

const router = express.Router();

router.get('/noti', getNotifications);
router.get('/admin/noti', getNotifications);
router.post('/admin/noti', createNotification);
router.put('/admin/noti/:id', updateNotification);
router.delete('/admin/noti/:id', deleteNotification);

export default router;