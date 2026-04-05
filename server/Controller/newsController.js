const prisma = require('../config/db.js');

const getAllNews = async (req, res) => {
  try {
    const news = await prisma.news.findMany({
      orderBy: { createdAt: 'desc' },
    });
    res.json(news);
  } catch (error) {
    res.status(500).json({ message: "Error fetching news" });
  }
};

const createNews = async (req, res) => {
  try {
    const { title, link, source } = req.body;
    const imagePath = req.file ? `/uploads/${req.file.filename}` : null;
    
    const newNews = await prisma.news.create({
      data: { title, link, source, imagePath },
    });
    res.status(201).json(newNews);
  } catch (error) {
    res.status(500).json({ message: "Error creating news" });
  }
};

const updateNews = async (req, res) => {
  try {
    const { id } = req.params;
    const { title, link, source } = req.body;
    const dataToUpdate = { title, link, source };
    
    if (req.file) {
      dataToUpdate.imagePath = `/uploads/${req.file.filename}`;
    }

    const updatedNews = await prisma.news.update({
      where: { id: parseInt(id) },
      data: dataToUpdate,
    });
    res.json(updatedNews);
  } catch (error) {
    res.status(500).json({ message: "Error updating news" });
  }
};

const deleteNews = async (req, res) => {
  try {
    const { id } = req.params;
    await prisma.news.delete({
      where: { id: parseInt(id) },
    });
    res.json({ message: "News deleted successfully" });
  } catch (error) {
    res.status(500).json({ message: "Error deleting news" });
  }
};

module.exports = {
  getAllNews,
  createNews,
  updateNews,
  deleteNews
};