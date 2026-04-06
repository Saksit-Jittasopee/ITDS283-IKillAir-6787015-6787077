const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const getOrders = async (search) => {
  const where = search ? {
    OR: [
      { orderId: { contains: search, mode: 'insensitive' } },
      { username: { contains: search, mode: 'insensitive' } },
      { product: { contains: search, mode: 'insensitive' } }
    ]
  } : {};
  return await prisma.order.findMany({
    where,
    orderBy: { id: 'desc' }
  });
};

const createOrder = async (data) => {
  return await prisma.order.create({
    data: {
      orderId: data.orderId,
      username: data.username || 'Guest',
      product: data.product,
      totalPrice: parseFloat(data.totalPrice),
      paymentMethod: data.paymentMethod
    }
  });
};

const updateOrder = async (id, data) => {
  return await prisma.order.update({
    where: { id: Number(id) },
    data: {
      username: data.username,
      product: data.product,
      orderId: data.orderId,
      totalPrice: parseFloat(data.totalPrice),
      paymentMethod: data.paymentMethod
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