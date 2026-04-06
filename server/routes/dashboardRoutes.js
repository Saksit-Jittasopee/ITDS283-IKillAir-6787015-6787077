const express = require('express');
const router = express.Router();
const dashboardController = require('../controllers/dashboardController.js');

router.get('/admin', dashboardController.getStats);

module.exports = router;