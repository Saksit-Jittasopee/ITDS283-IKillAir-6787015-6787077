const express = require('express');
const { getNotifications, createNotification, updateNotification, deleteNotification } = require('../Controller/notiController.js');

const router = express.Router();

router.get('/notifications', getNotifications);
router.get('/admin/notifications', getNotifications);
router.post('/admin/notifications', createNotification);
router.put('/admin/notifications/:id', updateNotification);
router.delete('/admin/notifications/:id', deleteNotification);

module.exports = router;