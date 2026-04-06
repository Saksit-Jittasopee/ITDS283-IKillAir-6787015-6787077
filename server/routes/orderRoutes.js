const express = require('express');
const {
  getOrders,
  createOrder,
  updateOrder,
  deleteOrder
} = require('../controllers/orderController.js');

const router = express.Router();

router.get('/admin/orders', getOrders);
router.post('/admin/orders', createOrder);
router.put('/admin/orders/:id', updateOrder);
router.delete('/admin/orders/:id', deleteOrder);

module.exports = router;