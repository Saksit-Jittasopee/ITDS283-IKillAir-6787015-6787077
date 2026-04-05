const express = require('express');
const multer = require('multer');
const path = require('path');
const { getAllNews, createNews, updateNews, deleteNews } = require('../Controller/newsController.js');
const { verifyToken } = require('../middlewares/authMiddleware.js');

const router = express.Router();

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/')
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname))
  }
});

const upload = multer({ storage: storage });

router.get('/news', getAllNews);
router.post('/admin/news', verifyToken, upload.single('image'), createNews);
router.put('/admin/news/:id', verifyToken, upload.single('image'), updateNews);
router.delete('/admin/news/:id', verifyToken, deleteNews);

module.exports = router;