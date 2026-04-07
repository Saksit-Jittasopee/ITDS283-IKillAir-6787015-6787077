const express = require('express');
const {
  getOrditem,
  createOrditem,
  updateOrditem,
  deleteOrditem
} = require('../Controller/orditemController.js');
const { verifyToken } = require('../middlewares/authMiddleware.js');

const router = express.Router();

router.get('/admin', verifyToken, getOrditem);
router.post('/', createOrditem);
router.put('/admin/:id', verifyToken, updateOrditem);
router.delete('/admin/:id', verifyToken, deleteOrditem);

module.exports = router;
