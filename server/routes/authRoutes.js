const express = require('express');
const router = express.Router();
const authController = require('../Controller/authController.js');
const { body, validationResult } = require('express-validator');
const { authLimiter, apiLimiter, registerLimiter } = require('../middlewares/rateLimitMiddleware.js');

const validate = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ success: false, message: errors.array()[0].msg });
  }
  next();
};

router.post('/register', registerLimiter, [
  body('email').isEmail().withMessage('รูปแบบอีเมลไม่ถูกต้อง'),
  body('username').isLength({ min: 3 }).withMessage('username ต้องมีอย่างน้อย 3 ตัวอักษร'),
  body('password').isLength({ min: 6 }).withMessage('password ต้องมีอย่างน้อย 6 ตัวอักษร'),
], validate, authController.register);

router.post('/login', authLimiter, [
  body('email').isEmail().withMessage('รูปแบบอีเมลไม่ถูกต้อง'),
  body('password').notEmpty().withMessage('กรุณากรอกรหัสผ่าน'),
], validate, authController.login);

router.post('/verify-email', [
  body('email').isEmail().withMessage('รูปแบบอีเมลไม่ถูกต้อง'),
], validate, authController.verifyEmail);

router.post('/reset-password', [
  body('email').isEmail().withMessage('รูปแบบอีเมลไม่ถูกต้อง'),
  body('newPassword').isLength({ min: 6 }).withMessage('password ต้องมีอย่างน้อย 6 ตัวอักษร'),
], validate, authController.resetPassword);

module.exports = router;