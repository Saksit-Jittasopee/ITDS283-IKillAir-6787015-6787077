const express = require('express');
const {
  getOrders,
  createOrder,
  updateOrder,
  deleteOrder
} = require('../controllers/orderController.js');
const { verifyToken } = require('../middlewares/authMiddleware.js');

const router = express.Router();

// Users
router.post('/', createOrder);

// Admin
router.get('/admin', verifyToken, getOrders);
router.post('/admin', verifyToken, createOrder);
router.put('/admin/:id', verifyToken, updateOrder);
router.delete('/admin/:id', verifyToken, deleteOrder);

module.exports = router;