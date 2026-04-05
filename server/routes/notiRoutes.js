const express = require('express');
const { getNotifications, createNotification, updateNotification, deleteNotification } = require('../Controller/notiController.js');
const { verifyToken } = require('../middlewares/authMiddleware.js');

const router = express.Router();

router.get('/notifications', getNotifications);
router.post('/admin/notifications', verifyToken, createNotification);
router.put('/admin/notifications/:id', verifyToken, updateNotification);
router.delete('/admin/notifications/:id', verifyToken, deleteNotification);

module.exports = router;