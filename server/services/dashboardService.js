const prisma = require('../config/db.js');

const getDashboardStats = async () => {
  const totalProducts = await prisma.product.count();

  const totalUsers = await prisma.useradmin.count({
    where: { role: false }
  });

  const activeUsers = await prisma.useradmin.count({
    where: { 
      role: false,
      status: true 
    }
  });

  const orders = await prisma.order.findMany({
    select: { totalPrice: true }
  });
  
  const totalSales = orders.reduce((sum, order) => sum + Number(order.totalPrice), 0);

  return {
    totalProducts,
    totalSales,
    totalUsers,
    activeUsers
  };
};

module.exports = { getDashboardStats };