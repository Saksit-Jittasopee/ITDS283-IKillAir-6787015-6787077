const { Pool } = require('pg');
const { PrismaPg } = require('@prisma/adapter-pg');
const { PrismaClient } = require('@prisma/client');
const connectionString = process.env.DATABASE_URL;

// สร้าง Pool จาก pg ด้วย connection string จาก environment variable 
const pool = new Pool({ connectionString });

// เอา Pool >> Prisma Adapter
const adapter = new PrismaPg(pool);

// call PrismaClient ด้วย adapter ที่สร้างขึ้น
const prisma = new PrismaClient({ adapter });

module.exports = prisma;