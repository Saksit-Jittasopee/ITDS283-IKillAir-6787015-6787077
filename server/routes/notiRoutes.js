import express from 'express';
import {
  getNotifications,
  createNotification,
  updateNotification,
  deleteNotification
} from '../controllers/notiController.js';

const router = express.Router();

router.get('/notifications', getNotifications);
router.get('/admin/notifications', getNotifications);
router.post('/admin/notifications', createNotification);
router.put('/admin/notifications/:id', updateNotification);
router.delete('/admin/notifications/:id', deleteNotification);

export default router;