const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

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
      imagePath: data.imagePath || null
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
      imagePath: data.imagePath || null
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