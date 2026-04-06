const express = require('express');
const router = express.Router();
const dashboardController = require('../controllers/dashboardController.js');
const { verifyToken } = require('../middlewares/authMiddleware.js');

router.get('/admin', verifyToken, dashboardController.getStats);

module.exports = router;