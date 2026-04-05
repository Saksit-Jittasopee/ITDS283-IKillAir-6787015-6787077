const express = require('express');
const router = express.Router();
const { searchProducts, searchUsers, searchOrders } = require('../Controller/searchController.js');

router.get('/products', searchProducts);
router.get('/admin/products', searchProducts);
router.get('/admin/users', searchUsers);
router.get('/admin/orders', searchOrders);

module.exports = router;