const express = require('express');
const cors = require('cors');
const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

let tasks = [
  { id: 1, title: "Configure Dockerfile", completed: true },
  { id: 2, title: "Set up CI/CD Pipeline", completed: false },
  { id: 3, title: "Deploy to Production", completed: false }
];


app.get('/health', (req, res) => {
  res.status(200).json({ status: "healthy", timestamp: new Date() });
});

app.get('/api/tasks', (req, res) => {
  res.json(tasks);
});


app.post('/api/tasks', (req, res) => {
  const newTask = {
    id: Date.now(),
    title: req.body.title,
    completed: false
  };
  tasks.push(newTask);
  res.status(201).json(newTask);
});

app.listen(PORT, () => {
  console.log(`Backend server running on port ${PORT}`);
});