const rateLimit = require('express-rate-limit');

// จำกัด login ไม่เกิน 10 ครั้ง ต่อ 15 นาที
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, 
  max: 5,
  message: {
    success: false,
    message: 'คุณลองเข้าสู่ระบบบ่อยเกินไป กรุณารอ 15 นาทีแล้วลองใหม่'
  },
  standardHeaders: true,
  legacyHeaders: false,
});

// จำกัด API ทั่วไป ไม่เกิน 100 ครั้ง ต่อ 15 นาที
const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  message: {
    success: false,
    message: 'คุณส่ง request บ่อยเกินไป กรุณารอสักครู่'
  },
  standardHeaders: true,
  legacyHeaders: false,
});

const registerLimiter = rateLimit({
  windowMs: 60 * 60 * 1000, // 1 ชั่วโมง
  max: 5, // สมัครได้แค่ 5 ครั้งต่อ IP
  message: {
    success: false,
    message: 'สมัครสมาชิกบ่อยเกินไป กรุณารอ 1 ชั่วโมง'
  },
  standardHeaders: true,
  legacyHeaders: false,
});

module.exports = { authLimiter, apiLimiter, registerLimiter };