const prisma = require('../config/db.js');

const getOrders = async (search) => {
  return await prisma.order.findMany({
    where: search ? {
      user: {
        username: { contains: search, mode: 'insensitive' }
      }
    } : {},
    include: {
      user: { select: { username: true } },
      orderItems: { include: { product: true } }
    },
    orderBy: { id: 'desc' }
  });
};

const createOrder = async (data) => {
  return await prisma.order.create({
    data: {
      totalPrice: parseFloat(data.totalPrice),
      payMet: data.payMet,
      status: data.status ?? false,
      userId: data.userId
    }
  });
};

const updateOrder = async (id, data) => {
  return await prisma.order.update({
    where: { id: Number(id) },
    data: {
      totalPrice: parseFloat(data.totalPrice),
      payMet: data.payMet,
      status: data.status
    }
  });
};

const deleteOrder = async (id) => {
  return await prisma.order.delete({
    where: { id: Number(id) }
  });
};

module.exports = {
  getOrders,
  createOrder,
  updateOrder,
  deleteOrder
};