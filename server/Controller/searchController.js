import prisma from '../config/db.js';

// 1. ค้นหาสินค้า (ใช้ร่วมกันได้ทั้ง User และ Admin)
export const searchProducts = async (req, res) => {
  try {
    const keyword = req.query.q || '';
    
    const products = await prisma.product.findMany({
      where: {
        // ค้นหาจากชื่อสินค้า (สมมติว่าใน DB ชื่อคอลัมน์คือ name)
        name: { contains: keyword, mode: 'insensitive' }
      }
    });
    
    res.json(products);
  } catch (error) {
    console.error("Search Products Error:", error);
    res.status(500).json({ message: "เกิดข้อผิดพลาดในการค้นหาสินค้า" });
  }
};

// 2. ค้นหาผู้ใช้งาน (สำหรับ Admin)
export const searchUsers = async (req, res) => {
  try {
    const keyword = req.query.q || '';
    
    const users = await prisma.useradmin.findMany({
      where: {
        // ค้นหาจากชื่อผู้ใช้ (สมมติว่าใน DB ชื่อคอลัมน์คือ username)
        username: { contains: keyword, mode: 'insensitive' }
      }
    });
    
    res.json(users);
  } catch (error) {
    console.error("Search Users Error:", error);
    res.status(500).json({ message: "เกิดข้อผิดพลาดในการค้นหาผู้ใช้" });
  }
};

// 3. ค้นหาคำสั่งซื้อ (สำหรับ Admin)
export const searchOrders = async (req, res) => {
  try {
    const keyword = req.query.q || '';
    
    const orders = await prisma.order.findMany({
      where: {
        // ให้ค้นหาได้ทั้งจากชื่อ Order (ID) หรือ ชื่อคนสั่ง
        OR: [
          { orderId: { contains: keyword, mode: 'insensitive' } },
          { username: { contains: keyword, mode: 'insensitive' } }
        ]
      }
    });
    
    res.json(orders);
  } catch (error) {
    console.error("Search Orders Error:", error);
    res.status(500).json({ message: "เกิดข้อผิดพลาดในการค้นหาคำสั่งซื้อ" });
  }
};