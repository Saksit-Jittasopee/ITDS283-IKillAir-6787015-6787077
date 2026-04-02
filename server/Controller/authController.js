const authService = require('../services/authService.js');

// Register
const register = async (req, res) => {
  try {
    // ข้อมูลที่ Flutter ส่งมา
    const { email, username, password } = req.body;

    const user = await authService.registerUser(email, username, password);

    // success
    res.status(201).json({ 
      success: true, 
      message: "สมัครสมาชิกสำเร็จ!", 
      user: { id: user.id, username: user.username, email: user.email } 
    });

  } catch (error) {
    res.status(400).json({ success: false, message: error.message });
  }
};

// login
const login = async (req, res) => {
  try {
    const { email, password } = req.body;
    
    const { user, token } = await authService.loginUser(email, password);

    res.status(200).json({ 
      success: true, 
      message: "เข้าสู่ระบบสำเร็จ!", 
      token: token, 
      user: { 
        id: user.id,          
        username: user.username, 
        email: user.email,      
        role: user.role         
     }  
    });

  } catch (error) {
    res.status(401).json({ success: false, message: error.message });
  }
};

module.exports = { register, login };