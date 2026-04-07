const prisma = require('../config/db.js');

const getProducts = async (category, search) => {
  const where = {};
  if (category && category !== 'All') {
    where.category = category;
  }
  if (search) {
    where.name = { contains: search, mode: 'insensitive' };
  }
  return await prisma.product.findMany({
    where,
    orderBy: { id: 'desc' }
  });
};

const createProduct = async (data) => {
  return await prisma.product.create({
    data: {
      name: data.name,
      price: parseFloat(data.price),
      category: data.category,
      image: data.image || '',     
      quantity: data.quantity || 0, 
      status: data.status ?? true   
    }
  });
};

const updateProduct = async (id, data) => {
  return await prisma.product.update({
    where: { id: Number(id) },
    data: {
      name: data.name,
      price: parseFloat(data.price),
      category: data.category,
      image: data.image || '',
      quantity: data.quantity,
      status: data.status
    }
  });
};

const deleteProduct = async (id) => {
  return await prisma.product.delete({
    where: { id: Number(id) }
  });
};

module.exports = {
  getProducts,
  createProduct,
  updateProduct,
  deleteProduct
};