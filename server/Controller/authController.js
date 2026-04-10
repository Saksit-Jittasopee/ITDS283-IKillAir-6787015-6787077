const authService = require('../services/authService.js');

const register = async (req, res) => {
  try {
    const { email, username, password } = req.body;
    const user = await authService.registerUser(email, username, password);
    res.status(201).json({ 
      success: true, 
      message: "สมัครสมาชิกสำเร็จ!", 
      user: { id: user.id, username: user.username, email: user.email } 
    });
  } catch (error) {
    res.status(400).json({ success: false, message: 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง' });
  }
};

const login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const { user, token } = await authService.loginUser(email, password);
    res.status(200).json({ 
      success: true, 
      message: "เข้าสู่ระบบสำเร็จ!", 
      token: token, 
      user: { id: user.id, username: user.username, email: user.email, role: user.role }  
    });
  } catch (error) {
    res.status(401).json({ success: false, message: 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง' });
  }
};

const verifyEmail = async (req, res) => {
  try {
    const { email } = req.body;
    await authService.verifyEmail(email);
    res.status(200).json({ success: true, message: "พบอีเมลในระบบ" });
  } catch (error) {
    res.status(404).json({ success: false, message: 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง' });
  }
};

const resetPassword = async (req, res) => {
  try {
    const { email, newPassword } = req.body;
    await authService.resetPassword(email, newPassword);
    res.status(200).json({ success: true, message: "เปลี่ยนรหัสผ่านสำเร็จ!" });
  } catch (error) {
    res.status(400).json({ success: false, message: 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง' });
  }
};

module.exports = { register, login, verifyEmail, resetPassword };