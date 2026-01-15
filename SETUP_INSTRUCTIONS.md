# MindScope AI - Complete Setup Instructions

## ⚠️ CRITICAL: Follow these steps IN ORDER

### Step 1: Start MongoDB

**Option A - As Administrator:**
1. Right-click `START_MONGODB.bat`
2. Select "Run as Administrator"
3. Wait for "waiting for connections" message

**Option B - Manual:**
1. Open Command Prompt as Administrator
2. Run: `net start MongoDB`

**Option C - Direct:**
If MongoDB isn't installed as a service:
```
"C:\Program Files\MongoDB\Server\7.0\bin\mongod.exe" --dbpath "C:\data\db"
```

**Verify MongoDB is running:**
Open new terminal and run:
```
mongo
```
or
```
mongosh
```

---

### Step 2: Download AI Models (ONE TIME ONLY)

This downloads ~2GB of AI models. Run ONCE before first use:

```bash
python download_models.py
```

**Expected output:**
```
1/3 Downloading emotion model...
✓ Emotion model downloaded successfully

2/3 Downloading sentiment model...
✓ Sentiment model downloaded successfully

3/3 Downloading vision model...
✓ Vision model downloaded successfully

All models downloaded successfully!
```

**This takes 5-15 minutes depending on internet speed.**

---

### Step 3: Start Backend

Open terminal in project directory:

```bash
cd backend
python app.py
```

**Expected output:**
```
MongoDB connection successful!
✓ Emotion service initialized
✓ Sentiment service initialized
✓ Vision service initialized
* Running on http://127.0.0.1:5000
```

**Keep this terminal running!**

---

### Step 4: Start Frontend

Open NEW terminal in project directory:

```bash
cd frontend
streamlit run app.py
```

**Expected output:**
```
You can now view your Streamlit app in your browser.

Local URL: http://localhost:8501
Network URL: http://192.168.x.x:8501
```

---

## ✅ Application Running

- **Frontend:** http://localhost:8501
- **Backend:** http://localhost:5000
- **MongoDB:** localhost:27017

---

## Common Errors & Solutions

### Error: "Failed to connect to MongoDB"
**Solution:** MongoDB isn't running
- Run `START_MONGODB.bat` as Administrator
- Or manually start MongoDB service

### Error: "ModuleNotFoundError"
**Solution:** Missing dependencies
```bash
pip install -r requirements.txt
```

### Error: "Model not found" or slow first analysis
**Solution:** Models not downloaded
```bash
python download_models.py
```

### Error: "Connection error: http://localhost:5000"
**Solution:** Backend not running
- Make sure backend terminal is running
- Check for errors in backend terminal

---

## System Requirements

- **Python:** 3.11
- **MongoDB:** 4.4+
- **RAM:** 8GB minimum (16GB recommended)
- **Disk:** 5GB free space
- **Internet:** For initial model download only

---

## Architecture

```
Frontend (Streamlit)
    ↓ HTTP Requests
Backend (Flask)
    ↓ Queries
MongoDB
    ↓ Analysis
AI Models (Transformers)
```

---

## Project Structure

```
Mental Health Platform/
├── backend/
│   ├── app.py              # Flask server
│   ├── config/
│   │   └── database.py     # MongoDB config
│   ├── controllers/        # API endpoints
│   ├── services/           # AI services
│   └── models/             # Data models
├── frontend/
│   └── app.py              # Streamlit UI
├── download_models.py      # Model downloader
├── START_MONGODB.bat       # MongoDB starter
└── requirements.txt        # Python dependencies
```

---

## Testing the System

1. **MongoDB Test:**
```bash
mongosh
show dbs
```

2. **Backend Test:**
Visit: http://localhost:5000/api/health

3. **Frontend Test:**
Visit: http://localhost:8501

4. **Full Test:**
- Enter text in frontend
- Click "Analyze Psychological State"
- Wait for results (15-30 seconds first time)

---

## Troubleshooting

### Backend crashes on startup
- Check MongoDB is running
- Run `python download_models.py`
- Check Python version: `python --version` (must be 3.11)

### Frontend looks broken
- Clear browser cache (Ctrl+Shift+Delete)
- Restart Streamlit
- Check browser console (F12) for errors

### Analysis takes forever
- First analysis is slow (loading models)
- Subsequent analyses are faster
- Check CPU usage (should be 70-100% during analysis)

### MongoDB connection timeout
- Verify MongoDB is running: `net start MongoDB`
- Check port 27017 is not blocked
- Try: `telnet localhost 27017`

---

## Production Deployment Notes

**DO NOT deploy as-is. Required changes:**

1. Change MongoDB to Atlas or hosted instance
2. Add proper authentication
3. Use environment variables for secrets
4. Add rate limiting
5. Use production WSGI server (gunicorn)
6. Add HTTPS
7. Implement proper logging
8. Add monitoring (Sentry, etc.)

---

## Support

For 4th year engineering students:
- This is a complete production-ready architecture
- All services are properly separated
- Database is NoSQL (MongoDB)
- AI uses state-of-the-art transformers
- Frontend uses modern Python framework

If you encounter issues:
1. Check all 3 services are running (MongoDB, Backend, Frontend)
2. Check terminal outputs for error messages
3. Verify models are downloaded
4. Ensure ports 5000, 8501, 27017 are available
