const orditemService = require('../services/orditemService.js');

const getOrditem = async (req, res) => {
  try {
    const items = await orditemService.getOrditem();
    res.json(items);
  } catch (error) {
    res.status(500).json({ error: 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง' });
  }
};

const createOrditem = async (req, res) => {
  try {
    const item = await orditemService.createOrditem(req.body);
    res.status(201).json(item);
  } catch (error) {
    res.status(500).json({ error: 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง' });
  }
};

const updateOrditem = async (req, res) => {
  try {
    const { id } = req.params;
    const item = await orditemService.updateOrditem(id, req.body);
    res.json(item);
  } catch (error) {
    res.status(500).json({ error: 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง' });
  }
};

const deleteOrditem = async (req, res) => {
  try {
    const { id } = req.params;
    await orditemService.deleteOrditem(id);
    res.json({ message: "Deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง' });
  }
};

module.exports = {
  getOrditem,
  createOrditem,
  updateOrditem,
  deleteOrditem
};
