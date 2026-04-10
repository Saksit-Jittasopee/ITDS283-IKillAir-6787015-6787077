const orderService = require('../services/orderService.js');

const getOrders = async (req, res) => {
  try {
    const { q } = req.query;
    const orders = await orderService.getOrders(q);
    res.json(orders);
  } catch (error) {
    res.status(500).json({ error: 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง' });
  }
};

const createOrder = async (req, res) => {
  try {
    const order = await orderService.createOrder(req.body);
    res.status(201).json(order);
  } catch (error) {
    res.status(500).json({ error: 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง' });
  }
};

const updateOrder = async (req, res) => {
  try {
    const { id } = req.params;
    const order = await orderService.updateOrder(id, req.body);
    res.json(order);
  } catch (error) {
    res.status(500).json({ error: 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง' });
  }
};

const deleteOrder = async (req, res) => {
  try {
    const { id } = req.params;
    await orderService.deleteOrder(id);
    res.json({ message: "Deleted" });
  } catch (error) {
    res.status(500).json({ error: 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง' });
  }
};

module.exports = {
  getOrders,
  createOrder,
  updateOrder,
  deleteOrder
};