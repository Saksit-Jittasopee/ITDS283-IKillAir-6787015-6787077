const rateLimit = require('express-rate-limit');

// จำกัด login/register ไม่เกิน 10 ครั้ง ต่อ 15 นาที
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 นาที
  max: 10,
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

module.exports = { authLimiter, apiLimiter };