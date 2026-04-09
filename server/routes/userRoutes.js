const express = require('express');
const router = express.Router();
const userController = require('../Controller/userController.js');
const { verifyToken } = require('../middlewares/authMiddleware.js');

router.get('/profile', verifyToken, userController.getProfile);
router.put('/profile', verifyToken, userController.updateProfile);

router.get('/admin', verifyToken, userController.getAllUsers);
router.post('/admin', verifyToken, userController.createUser);
router.put('/admin/:id', verifyToken, userController.updateUser);
router.delete('/admin/:id', verifyToken, userController.deleteUser);

module.exports = router;