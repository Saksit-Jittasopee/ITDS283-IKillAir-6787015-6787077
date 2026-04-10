const prisma = require('../config/db.js');

const getAllNews = async (req, res) => {
  try {
    const news = await prisma.news.findMany({
      orderBy: { date: 'desc' },
    });
    res.json(news);
  } catch (error) {
    console.error("NEWS ERROR:", error); 
    res.status(500).json({ message: 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง' }); 
  }
};

const createNews = async (req, res) => {
  try {
    const { name, source, userId } = req.body;
    const image = req.file ? `/uploads/${req.file.filename}` : '';

    const newNews = await prisma.news.create({
      data: { 
        name,          
        source,
        image,          
        userId: Number(userId)
      }
    });
    res.status(201).json(newNews);
  } catch (error) {
    res.status(500).json({ message: "Error creating news" });
  }
};

const updateNews = async (req, res) => {
  try {
    const { id } = req.params;
    const { name, source } = req.body;
    const dataToUpdate = { name, source };

    if (req.file) {
      dataToUpdate.image = `/uploads/${req.file.filename}`;
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