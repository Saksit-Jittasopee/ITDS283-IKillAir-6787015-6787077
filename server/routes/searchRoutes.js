import express from 'express';
import { searchProducts, searchUsers, searchOrders } from '../controllers/searchController.js';

const router = express.Router();

// Route สำหรับค้นหา (GET /api/search/...)
router.get('/products', searchProducts);
router.get('/users', searchUsers);
router.get('/orders', searchOrders);

export default router;