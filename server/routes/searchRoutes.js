import express from 'express';
import { searchProducts, searchUsers, searchOrders } from '../controllers/searchController.js';

const router = express.Router();

// Route สำหรับค้นหา (GET /api/search/...)
router.get('/products', searchProducts);
router.get('/admin/products', searchProducts);
router.get('/admin/users', searchUsers);
router.get('/admin/orders', searchOrders);

export default router;