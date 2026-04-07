const prisma = require('../config/db.js');

const getOrditem = async () => {
  return await prisma.orditem.findMany({
    include: {
      order: true,
      product: true
    },
    orderBy: { id: 'desc' }
  });
};

const createOrditem = async (data) => {
  return await prisma.orditem.create({
    data: {
      quantity: parseInt(data.quantity),
      price: parseFloat(data.price),
      orderId: parseInt(data.orderId),
      productId: parseInt(data.productId)
    }
  });
};

const updateOrditem = async (id, data) => {
  return await prisma.orditem.update({
    where: { id: Number(id) },
    data: {
      quantity: parseInt(data.quantity),
      price: parseFloat(data.price)
    }
  });
};

const deleteOrditem = async (id) => {
  return await prisma.orditem.delete({
    where: { id: Number(id) }
  });
};

module.exports = {
  getOrditem,
  createOrditem,
  updateOrditem,
  deleteOrditem
};
