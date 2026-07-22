import { useState, useEffect } from 'react';

function App() {
  const [tasks, setTasks] = useState([]);
  const [newTask, setNewTask] = useState('');
  const [status, setStatus] = useState('Connecting to backend...');

  // Fallback to localhost if the environment variable isn't set
  const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:5000';

  // Fetch tasks and check connection on load
  useEffect(() => {
    fetch(`${API_URL}/api/tasks`)
      .then(res => {
        if (!res.ok) throw new Error('Server error');
        return res.json();
      })
      .then(data => {
        setTasks(data);
        setStatus('Connected to Backend ✓');
      })
      .catch(err => {
        console.error(err);
        setStatus('Failed to connect to backend ✗');
      });
  }, [API_URL]);

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!newTask.trim()) return;

    fetch(`${API_URL}/api/tasks`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ title: newTask })
    })
      .then(res => res.json())
      .then(data => {
        setTasks([...tasks, data]);
        setNewTask('');
      });
  };

  return (
    <div style={{ padding: '40px', fontFamily: 'sans-serif', maxWidth: '500px', margin: '0 auto' }}>
      <h1>DevOps Practice App</h1>
      
      {/* Visual indicator to quickly test if your networking/ports are working */}
      <div style={{
        padding: '10px', 
        marginBottom: '20px', 
        backgroundColor: status.includes('✓') ? '#d4edda' : '#f8d7da',
        color: status.includes('✓') ? '#155724' : '#721c24',
        borderRadius: '4px'
      }}>
        <strong>Status:</strong> {status}
      </div>

      <form onSubmit={handleSubmit} style={{ display: 'flex', gap: '10px', marginBottom: '20px' }}>
        <input 
          type="text" 
          value={newTask} 
          onChange={(e) => setNewTask(e.target.value)}
          placeholder="Add a new DevOps task..." 
          style={{ flexGrow: 1, padding: '8px' }}
        />
        <button type="submit" style={{ padding: '8px 16px', cursor: 'pointer' }}>Add</button>
      </form>

      <ul style={{ paddingLeft: '20px' }}>
        {tasks.map(task => (
          <li key={task.id} style={{ marginBottom: '8px', textDecoration: task.completed ? 'line-through' : 'none' }}>
            {task.title}
          </li>
        ))}
      </ul>
    </div>
  );
}

export default App;