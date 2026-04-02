const express = require('express');
const router = express.Router();
const authController = require('../Controller/authController.js');

// POST /api/auth/register call controller.register
router.post('/register', authController.register);

// POST /api/auth/login call controller.login
router.post('/login', authController.login);

module.exports = router;