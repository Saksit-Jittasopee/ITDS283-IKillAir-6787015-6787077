const userService = require('../services/userService.js');

const getProfile = async (req, res) => {
  try {
    // req.user.id จาก authMiddleware ที่ decode มาเเล้ว
    const userId = req.user.id; 
    
    const userProfile = await userService.getUserProfile(userId);

    res.status(200).json({
      success: true,
      data: userProfile
    });

  } catch (error) {
    res.status(404).json({ success: false, message: error.message });
  }
};

module.exports = { getProfile };