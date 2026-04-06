const express = require('express');
const { getNotifications, createNotification, updateNotification, deleteNotification } = require('../Controller/notiController.js');
const { verifyToken } = require('../middlewares/authMiddleware.js');

const router = express.Router();

router.get('/', getNotifications);
router.post('/admin', verifyToken, createNotification);
router.put('/admin/:id', verifyToken, updateNotification);
router.delete('/admin/:id', verifyToken, deleteNotification);

module.exports = router;