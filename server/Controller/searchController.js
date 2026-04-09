const prisma = require('../config/db.js');

const searchProducts = async (req, res) => {
  try {
    const keyword = req.query.q || '';
    const products = await prisma.product.findMany({
      where: {
        OR: [
          { name: { contains: keyword, mode: 'insensitive' } },
          { category: { contains: keyword, mode: 'insensitive' } }
        ]
      }
    });
    res.json(products);
  } catch (error) {
    res.status(500).json({ message: "เกิดข้อผิดพลาดในการค้นหาสินค้า" });
  }
};

const searchUsers = async (req, res) => {
  try {
    const keyword = req.query.q || '';
    const users = await prisma.useradmin.findMany({
      where: {
        username: { contains: keyword, mode: 'insensitive' }
      }
    });
    res.json(users);
  } catch (error) {
    res.status(500).json({ message: "เกิดข้อผิดพลาดในการค้นหาผู้ใช้" });
  }
};

const searchOrders = async (req, res) => {
  try {
    const keyword = req.query.q || '';
    const orders = await prisma.order.findMany({
      where: {
        OR: [
          { orderId: { contains: keyword, mode: 'insensitive' } },
          { username: { contains: keyword, mode: 'insensitive' } }
        ]
      }
    });
    res.json(orders);
  } catch (error) {
    res.status(500).json({ message: "เกิดข้อผิดพลาดในการค้นหาคำสั่งซื้อ" });
  }
};

module.exports = {
  searchProducts,
  searchUsers,
  searchOrders
};