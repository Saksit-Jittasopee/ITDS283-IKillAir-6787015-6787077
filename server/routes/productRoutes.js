const express = require('express');
const {
  getProducts,
  createProduct,
  updateProduct,
  deleteProduct
} = require('../controllers/productController.js');

const { verifyToken } = require('../middlewares/authMiddleware.js');

const router = express.Router();

router.get('/products', getProducts);
router.post('/admin/products', verifyToken, createProduct);
router.put('/admin/products/:id', verifyToken, updateProduct);
router.delete('/admin/products/:id', verifyToken, deleteProduct);

module.exports = router;