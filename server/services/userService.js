const prisma = require('../config/db.js');
const bcrypt = require('bcryptjs');

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
      imagePath: true,
      creDate: true
    }
  });
  if (!user) {
    throw new Error("ไม่พบข้อมูลผู้ใช้งาน");
  }
  return user;
};

const updateProfile = async (userId, data) => {
  return await prisma.useradmin.update({
    where: { id: userId },
    data: {
      username: data.username,
      imagePath: data.imagePath
    }
  });
};

const getAllUsers = async (search) => {
  const where = search ? {
    OR: [
      { username: { contains: search, mode: 'insensitive' } },
      { email: { contains: search, mode: 'insensitive' } }
    ]
  } : {};
  
  return await prisma.useradmin.findMany({
    where,
    orderBy: { id: 'desc' }
  });
};

const createUser = async (data) => {
  const existingUser = await prisma.useradmin.findFirst({
    where: { email: data.email }
  });
  if (existingUser) {
    throw new Error("อีเมลนี้ถูกใช้งานแล้ว");
  }

  const salt = await bcrypt.genSalt(10);
  const hashedPassword = await bcrypt.hash(data.password, salt);

  return await prisma.useradmin.create({
    data: {
      username: data.username,
      email: data.email,
      password: hashedPassword,
      role: data.isAdmin,
      status: data.isActive,
      isNoti: false
    }
  });
};

const updateUser = async (id, data) => {
  const updateData = {
    username: data.username,
    email: data.email,
    role: data.isAdmin,
    status: data.isActive
  };

  if (data.password && data.password.trim() !== "") {
    const salt = await bcrypt.genSalt(10);
    updateData.password = await bcrypt.hash(data.password, salt);
  }

  return await prisma.useradmin.update({
    where: { id: Number(id) },
    data: updateData
  });
};

const deleteUser = async (id) => {
  return await prisma.useradmin.delete({
    where: { id: Number(id) }
  });
};

module.exports = { 
  getUserProfile, 
  updateProfile, 
  getAllUsers, 
  createUser, 
  updateUser, 
  deleteUser 
};