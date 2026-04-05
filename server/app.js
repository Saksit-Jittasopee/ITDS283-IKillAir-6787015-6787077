require('dotenv').config(); 
const express = require('express');
const cors = require('cors');
const app = express();
const prisma = require('./config/db');
const port = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Import Routes
const authRoutes = require('./routes/authRoutes.js');
const userRoutes = require('./routes/userRoutes');
const searchRoutes = requires('./routes/searchRoutes.js');
const notiRoutes = requires('./routes/notiRoutes.js');

// Use Routes
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/search', searchRoutes);
app.use('/api/noti', notiRoutes);

// Test Route
app.get('/', (req, res) => {
  res.json({ status: "OK", message: "Server is running perfectly! Jiblee mai" });
});

app.get('/api/search', async (req, res) => {
  try {
    const keyword = req.query.q?.toLowerCase() || '';
    
    if (!keyword) {
      const allUsers = await prisma.useradmin.findMany();
      return res.json(allUsers);
    }

    console.log(`Search query: ${keyword}`);
    const results = await prisma.useradmin.findMany();

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