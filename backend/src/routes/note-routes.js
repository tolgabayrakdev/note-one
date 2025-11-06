import express from 'express';
import db from '../database/db.js';
import { authenticateToken } from '../middleware/auth.js';

const router = express.Router();

// Tüm route'lar authentication gerektirir
router.use(authenticateToken);

// Get all notes for the authenticated user
router.get('/', (req, res) => {
  try {
    const userId = req.user.userId;
    const notes = db.prepare('SELECT * FROM notes WHERE user_id = ? ORDER BY updated_at DESC').all(userId);
    res.json(notes);
  } catch (error) {
    console.error('Get notes error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get a single note by ID
router.get('/:id', (req, res) => {
  try {
    const userId = req.user.userId;
    const noteId = req.params.id;
    
    const note = db.prepare('SELECT * FROM notes WHERE id = ? AND user_id = ?').get(noteId, userId);
    
    if (!note) {
      return res.status(404).json({ error: 'Note not found' });
    }
    
    res.json(note);
  } catch (error) {
    console.error('Get note error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Create a new note
router.post('/', (req, res) => {
  try {
    const userId = req.user.userId;
    const { title, content } = req.body;

    if (!title) {
      return res.status(400).json({ error: 'Title is required' });
    }

    const result = db.prepare('INSERT INTO notes (user_id, title, content) VALUES (?, ?, ?)').run(
      userId,
      title,
      content || ''
    );

    const note = db.prepare('SELECT * FROM notes WHERE id = ?').get(result.lastInsertRowid);
    res.status(201).json(note);
  } catch (error) {
    console.error('Create note error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Update a note
router.put('/:id', (req, res) => {
  try {
    const userId = req.user.userId;
    const noteId = req.params.id;
    const { title, content } = req.body;

    // Check if note exists and belongs to user
    const existingNote = db.prepare('SELECT * FROM notes WHERE id = ? AND user_id = ?').get(noteId, userId);
    if (!existingNote) {
      return res.status(404).json({ error: 'Note not found' });
    }

    if (!title) {
      return res.status(400).json({ error: 'Title is required' });
    }

    db.prepare('UPDATE notes SET title = ?, content = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ? AND user_id = ?').run(
      title,
      content || '',
      noteId,
      userId
    );

    const updatedNote = db.prepare('SELECT * FROM notes WHERE id = ?').get(noteId);
    res.json(updatedNote);
  } catch (error) {
    console.error('Update note error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Delete a note
router.delete('/:id', (req, res) => {
  try {
    const userId = req.user.userId;
    const noteId = req.params.id;

    // Check if note exists and belongs to user
    const existingNote = db.prepare('SELECT * FROM notes WHERE id = ? AND user_id = ?').get(noteId, userId);
    if (!existingNote) {
      return res.status(404).json({ error: 'Note not found' });
    }

    db.prepare('DELETE FROM notes WHERE id = ? AND user_id = ?').run(noteId, userId);
    res.json({ message: 'Note deleted successfully' });
  } catch (error) {
    console.error('Delete note error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

export default router;

