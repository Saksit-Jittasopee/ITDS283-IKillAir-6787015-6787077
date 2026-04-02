const jwt = require('jsonwebtoken');

const verifyToken = (req, res, next) => {
  // ขอบัตรผ่านจาก Header ที่ Flutter ส่งมา
  const authHeader = req.headers['authorization'];
  
  if (!authHeader) {
    return res.status(403).json({ success: false, message: "ไม่มี Token อนุญาตให้เข้าถึง!" });
  }

  const token = authHeader.split(" ")[1];

  try {
    // ตรวจสอบความถูกต้องของ Token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    // ถ้าแท้ ก็ฝังข้อมูล user ลงไปใน req แล้วปล่อยให้ผ่านไปได้ (next)
    req.user = decoded;
    next(); 
  } catch (error) {
    return res.status(401).json({ success: false, message: "Token ไม่ถูกต้อง หรือหมดอายุแล้ว!" });
  }
};

module.exports = { verifyToken };