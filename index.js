const express = require('express');
const path = require('path');
const app = express();
const morgan = require('morgan');
const port = 3000;

// Serve static files from the public directory
app.use(express.static('public'));
app.use(morgan('combined'));
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(port, () => {
  console.log(`Portfolio app listening at http://localhost:${port}`);
});