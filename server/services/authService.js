const prisma = require('../config/db.js'); 
const bcrypt = require('bcryptjs'); 
const jwt = require('jsonwebtoken');

// 1. Register
const registerUser = async (email, username, password) => {
    const existingUser = await prisma.useradmin.findFirst({
        where: { email: email }
    });

    if (existingUser) {
        throw new Error("อีเมลนี้ถูกใช้งานแล้ว"); 
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const newUser = await prisma.useradmin.create({
        data: {
            email: email,
            username: username,
            password: hashedPassword,
            role: false,
            status: true,
            isNoti: false
        }
    });

    return newUser;
};

// 2. Login
const loginUser = async (email, password) => {
    const user = await prisma.useradmin.findFirst({
        where: { email: email }
    });

    if (!user) {
        throw new Error("ไม่พบผู้ใช้งานนี้ในระบบ");
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
        throw new Error("รหัสผ่านไม่ถูกต้อง");
    }

    // สร้าง Token
    const token = jwt.sign(
        { id: user.id, role: user.role },
        process.env.JWT_SECRET, 
        { expiresIn: '7d' } 
    );

    return { user, token };
};

// 3. Verify Email 
const verifyEmail = async (email) => {
    const user = await prisma.useradmin.findFirst({
        where: { email: email }
    });

    if (!user) {
        throw new Error("ไม่พบอีเมลนี้ในระบบ กรุณาตรวจสอบอีกครั้ง");
    }

    return user;
};

// 4. Reset Password 
const resetPassword = async (email, newPassword) => {
    const user = await prisma.useradmin.findFirst({
        where: { email: email }
    });

    if (!user) {
        throw new Error("เกิดข้อผิดพลาด ไม่พบผู้ใช้งานนี้ในระบบ");
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(newPassword, salt);

    const updatedUser = await prisma.useradmin.update({
        where: { id: user.id }, 
        data: {
            password: hashedPassword
        }
    });

    return updatedUser;
};

module.exports = { registerUser, loginUser, verifyEmail, resetPassword };