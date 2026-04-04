import express from 'express';
import multer from 'multer';
import path from 'path';
import { getAllNews, createNews, updateNews, deleteNews } from '../controllers/newsController.js';

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
router.get('/admin/news', getAllNews);
router.post('/admin/news', upload.single('image'), createNews);
router.put('/admin/news/:id', upload.single('image'), updateNews);
router.delete('/admin/news/:id', deleteNews);

export default router;