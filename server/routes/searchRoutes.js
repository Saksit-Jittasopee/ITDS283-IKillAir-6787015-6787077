const express = require('express');
const router = express.Router();
const { searchProducts, searchUsers, searchOrders } = require('../Controller/searchController.js');
const { verifyToken } = require('../middlewares/authMiddleware.js');

router.get('/products', searchProducts);
router.get('/admin/users', verifyToken, searchUsers);
router.get('/admin/orders', verifyToken, searchOrders);

module.exports = router;