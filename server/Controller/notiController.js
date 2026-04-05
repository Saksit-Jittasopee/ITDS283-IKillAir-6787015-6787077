import prisma from '../config/db.js';

export const getNotifications = async (req, res) => {
  try {
    const notifications = await prisma.notification.findMany({
      orderBy: { id: 'desc' }
    });
    res.json(notifications);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const createNotification = async (req, res) => {
  try {
    const { title, target, time } = req.body;
    const newNoti = await prisma.notification.create({
      data: { title, target, time }
    });
    res.status(201).json(newNoti);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const updateNotification = async (req, res) => {
  try {
    const { id } = req.params;
    const { title, target, time } = req.body;
    const updatedNoti = await prisma.notification.update({
      where: { id: Number(id) },
      data: { title, target, time }
    });
    res.json(updatedNoti);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const deleteNotification = async (req, res) => {
  try {
    const { id } = req.params;
    await prisma.notification.delete({
      where: { id: Number(id) }
    });
    res.json({ message: "Deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};