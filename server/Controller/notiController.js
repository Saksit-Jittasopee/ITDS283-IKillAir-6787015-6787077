const prisma = require('../config/db.js');

const getNotifications = async (req, res) => {
  try {
    const notifications = await prisma.notification.findMany({
      orderBy: { id: 'desc' }
    });
    res.json(notifications);
  } catch (error) {
    res.status(500).json({ error: 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง' });
  }
};

const createNotification = async (req, res) => {
  try {
    const { name, message, userId } = req.body;
    const newNoti = await prisma.notification.create({
      data: { 
        name,       // ไม่ใช่ title
        message,    // ไม่ใช่ target/time
        userId: Number(userId)
      }
    });
    res.status(201).json(newNoti);
  } catch (error) {
    res.status(500).json({ error: 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง' });
  }
};

const updateNotification = async (req, res) => {
  try {
    const { id } = req.params;
    const { name, message } = req.body;
    const updatedNoti = await prisma.notification.update({
      where: { id: Number(id) },
      data: { name, message }
    });
    res.json(updatedNoti);
  } catch (error) {
    res.status(500).json({ error: 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง' });
  }
};

const deleteNotification = async (req, res) => {
  try {
    const { id } = req.params;
    await prisma.notification.delete({
      where: { id: Number(id) }
    });
    res.json({ message: "Deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง' });
  }
};

module.exports = {
  getNotifications,
  createNotification,
  updateNotification,
  deleteNotification
};