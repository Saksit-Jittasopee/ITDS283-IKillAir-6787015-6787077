// setup
require('dotenv').config(); 
const express = require('express');
const cors = require('cors');
const app = express();
const prisma = require('./config/db');

// process.env.PORT is set by hosting provider defaults to 3000 
const port = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.get('/', (req, res) => {
  res.json({ status: "OK", message: "Server is running perfectly! Jiblee mai" });
});

app.get('/api/search', async (req, res) => {
  try {
    const keyword = req.query.q?.toLowerCase() || '';
    
    // ถ้าไม่มีการค้นหา ให้ดึงข้อมูลทั้งหมดออกมา
    // if (!keyword) {
    //   const allUsers = await prisma.useradmin.findMany();
    //   return res.json(allUsers);
    // }

    // ถ้ามีการพิมพ์ค้นหา ให้หาจากชื่อ username หรือ email
    console.log(`Search query: ${keyword}`);
    const results = await prisma.Useradmin.findMany();

    res.json(results);

  } catch (error) {
    console.error("Database Error:", error);
    res.status(500).json({ message: "เกิดข้อผิดพลาดในการดึงข้อมูล" });
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server running at port: ${port}`);
});