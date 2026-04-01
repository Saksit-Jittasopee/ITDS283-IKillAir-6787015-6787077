const express = require('express');
const cors = require('cors');
const app = express();
const port = 3000;

app.use(cors());
app.use(express.json());

const mockProducts = [
    {'id': 1, 'name': 'HealthPro 101', 'price': 1000.00, 'category': 'Room Air Purify'},
    {'id': 2, 'name': 'Super Series', 'price': 1500.00, 'category': 'Room Air Purify'},
    {'id': 3, 'name': 'AT-500', 'price': 5900.00, 'category': 'Personal Air Purify'},
    {'id': 4, 'name': 'RZD-Airclean', 'price': 9990.50, 'category': 'Room Air Purify'},
    {'id': 5, 'name': 'Air Monitor X', 'price': 2500.00, 'category': 'Air Quality Monitor'},
    {'id': 6, 'name': 'N95 Mask Pro', 'price': 150.00, 'category': 'Mask'},
    {'id': 7, 'name': 'Car Air Purify V1', 'price': 1200.00, 'category': 'Car Air Purify'},
];

app.get('/api/search', (req, res) => {
  const keyword = req.query.q?.toLowerCase() || '';
  
  if (!keyword) {
    return res.json(mockProducts);
  }

  const results = mockProducts.filter(p => 
    p.name.toLowerCase().includes(keyword) || 
    p.category.toLowerCase().includes(keyword)
  );
  
  res.json(results);
});

app.listen(port, () => {
  console.log(`Server running at port:${port}`);
});