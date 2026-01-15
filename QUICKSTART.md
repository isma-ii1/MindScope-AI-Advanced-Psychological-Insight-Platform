# MindScope AI - Quick Start Guide

Get MindScope AI running in 5 minutes.

## Prerequisites Check

Before starting, ensure you have:
- [ ] Python 3.11 or higher installed
- [ ] MongoDB installed and accessible
- [ ] 8GB+ RAM available
- [ ] 3GB+ free disk space (for AI models)

## Installation Steps

### 1. Run Setup Script (Windows)

```bash
# Double-click setup.bat
# OR run from terminal:
setup.bat
```

This will:
- Create a virtual environment
- Install all Python dependencies
- Create a .env configuration file

### 2. Start MongoDB

```bash
# Windows (if MongoDB is a service):
net start MongoDB

# OR run MongoDB manually:
mongod --dbpath C:\data\db
```

Verify MongoDB is running on `localhost:27017`

### 3. Start the Backend

```bash
# Double-click run_backend.bat
# OR:
cd backend
python app.py
```

Wait for:
```
* Running on http://127.0.0.1:5000
* Model loaded: emotion-english-distilroberta-base
* Model loaded: twitter-roberta-base-sentiment-latest
```

Note: First startup downloads AI models (~2-3GB), takes 5-10 minutes.

### 4. Start the Frontend

In a NEW terminal:

```bash
# Double-click run_frontend.bat
# OR:
cd frontend
streamlit run app.py
```

Browser will auto-open to `http://localhost:8501`

## Verify Installation

### Test 1: Health Check

```bash
curl http://localhost:5000/api/health/ping
# Expected: {"status": "ok", "message": "MindScope AI is running"}

curl http://localhost:5000/api/health/db
# Expected: {"status": "ok", "database": "connected"}
```

### Test 2: Simple Analysis

```bash
curl -X POST http://localhost:5000/api/analysis/text \
  -H "Content-Type: application/json" \
  -d "{\"text\": \"I feel anxious today\", \"user_id\": \"test\"}"
```

Expected: JSON response with emotions, risk assessment, etc.

### Test 3: Frontend

1. Open http://localhost:8501
2. Type: "I'm feeling stressed and overwhelmed"
3. Click "Analyze My Mental State"
4. View results (emotions, patterns, recommendations)

## Quick Usage Examples

### Text Analysis via UI

1. Select "Text Only"
2. Enter your thoughts
3. Click "Analyze"
4. Explore:
   - Emotion breakdown
   - Cognitive patterns
   - Risk assessment
   - Grounding techniques
   - Book recommendations

### Image Analysis via UI

1. Select "Image Only"
2. Upload a selfie or scene photo
3. Click "Analyze"
4. View:
   - Detected facial emotions
   - Scene interpretation
   - Psychological insights

### API Usage (Python)

```python
import requests

data = {
    "text": "I can't stop worrying about everything",
    "user_id": "user123"
}

response = requests.post(
    "http://localhost:5000/api/analysis/text",
    json=data
)

result = response.json()
print(f"Primary emotion: {result['emotions'][0]['emotion']}")
print(f"Risk level: {result['risk_assessment']['overall_risk_level']}")
```

### API Usage (curl)

```bash
# Text analysis
curl -X POST http://localhost:5000/api/analysis/text \
  -H "Content-Type: application/json" \
  -d '{"text": "I feel hopeless", "user_id": "user1"}'

# Get user history
curl http://localhost:5000/api/analysis/history/user1?limit=5
```

## Understanding the Results

### Emotion Scores
- **Score**: 0.0 - 1.0 (confidence)
- **Intensity**: mild (< 0.4), moderate (0.4-0.7), strong (> 0.7)
- Higher scores = stronger emotional presence

### Risk Levels
- **Minimal**: No significant concerns
- **Low**: Minor distress indicators
- **Moderate**: Concerning patterns, support recommended
- **Elevated**: Significant distress, crisis resources provided

### Cognitive Distortions
- **All-or-Nothing**: Black-and-white thinking
- **Catastrophizing**: Expecting worst outcomes
- **Mind Reading**: Assuming others' thoughts
- **Should Statements**: Rigid rules/expectations

### Disorder Patterns
Note: These are **linguistic patterns**, NOT diagnoses.
- Confidence > 0.7: Strong pattern alignment
- Confidence 0.5-0.7: Moderate indicators
- Confidence < 0.5: Weak/uncertain

## Common Issues

### Issue: "Connection refused" error

**Solution**:
```bash
# Check if backend is running
netstat -an | findstr :5000

# Restart backend
cd backend
python app.py
```

### Issue: MongoDB connection failed

**Solution**:
```bash
# Check MongoDB status
net start MongoDB

# Or start manually:
mongod --dbpath C:\data\db
```

### Issue: Models not downloading

**Solution**:
```bash
# Manually download models
python
>>> from transformers import pipeline
>>> pipeline("text-classification", model="j-hartmann/emotion-english-distilroberta-base")
>>> pipeline("text-classification", model="cardiffnlp/twitter-roberta-base-sentiment-latest")
```

### Issue: Slow performance

**Solutions**:
- Use GPU if available (automatic detection)
- Reduce text length (keep under 300 words)
- Close other applications
- Consider model quantization (advanced)

## Running Tests

```bash
# Run all tests
python -m unittest discover tests/

# Run specific test
python -m unittest tests.test_services

# Run with verbose output
python -m unittest discover tests/ -v
```

## Next Steps

### Explore Advanced Features
1. **Multimodal Analysis**: Upload text + image together
2. **Grounding Tools**: Try the breathing exercise in sidebar
3. **History**: Track analyses over time (use consistent user_id)
4. **API Integration**: Build your own client app

### Customize Settings
Edit `.env` file to change:
- MongoDB URI
- Flask port
- AI model choices

### Read Documentation
- [README.md](README.md) - Full documentation
- [ARCHITECTURE.md](ARCHITECTURE.md) - System design
- [examples/](examples/) - Code examples

## Getting Help

### Check Logs
- Backend logs: Terminal running Flask
- Frontend logs: Terminal running Streamlit
- MongoDB logs: MongoDB terminal/service

### Troubleshooting Checklist
- [ ] MongoDB is running on port 27017
- [ ] Backend is running on port 5000
- [ ] Frontend is running on port 8501
- [ ] Virtual environment is activated
- [ ] All dependencies installed (`pip list`)
- [ ] .env file exists and is configured

### Example Workflow

```bash
# Terminal 1: MongoDB
mongod --dbpath C:\data\db

# Terminal 2: Backend
cd "Mental Health Platform"
venv\Scripts\activate
cd backend
python app.py

# Terminal 3: Frontend
cd "Mental Health Platform"
venv\Scripts\activate
cd frontend
streamlit run app.py

# Terminal 4: Testing (optional)
cd "Mental Health Platform"
venv\Scripts\activate
python examples/example_requests.py
```

## Important Reminders

### Ethical Use
- This is NOT a replacement for professional mental health care
- Always encourage users to seek licensed professionals
- Crisis resources are provided for elevated risk situations

### Privacy
- No data is sent to external APIs
- All AI processing happens locally
- User IDs are arbitrary strings (not tied to real identity)
- MongoDB data is local (not cloud-synced by default)

### Performance Expectations
- **Text Analysis**: 2-5 seconds (CPU), < 1 second (GPU)
- **Image Analysis**: 3-7 seconds (CPU), 1-2 seconds (GPU)
- **First Analysis**: Slower due to model loading

---

**You're ready!** Start analyzing psychological patterns with AI.

For detailed documentation, see [README.md](README.md)
