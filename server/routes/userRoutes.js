const express = require('express');
const router = express.Router();
const userController = require('../Controller/userController.js');

// Middleware token
const { verifyToken } = require('../middlewares/authMiddleware.js');

//  GET /api/users/profile
router.get('/profile', verifyToken, userController.getProfile);

module.exports = router;