const prisma = require('../config/db.js');

const getUserProfile = async (userId) => {
  const user = await prisma.useradmin.findUnique({
    where: { id: userId },
    select: {
      id: true,
      username: true,
      email: true,
      role: true,
      status: true,
      isNoti: true,
      creDate: true
    }
  });

  if (!user) {
    throw new Error("ไม่พบข้อมูลผู้ใช้งาน");
  }

  return user;
};

module.exports = { getUserProfile };