const express = require('express');
const {
  getProducts,
  createProduct,
  updateProduct,
  deleteProduct
} = require('../Controller/productController.js');

const { verifyToken } = require('../middlewares/authMiddleware.js');

const router = express.Router();

router.get('/', getProducts);
router.post('/admin', verifyToken, createProduct);
router.put('/admin/:id', verifyToken, updateProduct);
router.delete('/admin/:id', verifyToken, deleteProduct);

module.exports = router;