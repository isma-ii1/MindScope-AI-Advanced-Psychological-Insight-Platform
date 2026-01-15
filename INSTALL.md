# Installation Guide - MindScope AI

## Hugging Face Setup (Proper)

### Why Warnings Happen

**Hugging Face Xet Storage Warning:**
- `hf_xet` is an optional acceleration package for faster downloads from Hugging Face Hub
- NOT required for functionality
- Only useful for very large model downloads (>10GB)
- Safe to ignore for this project

**Fix (Optional):**
```bash
pip install hf_xet
```

### Proper Installation Order

Dependencies must be installed in this order to avoid conflicts:

```bash
# 1. PyTorch first (CPU version for compatibility)
pip install torch==2.1.2+cpu torchvision==0.16.2+cpu --extra-index-url https://download.pytorch.org/whl/cpu

# 2. Hugging Face ecosystem (specific order matters)
pip install huggingface-hub==0.20.2
pip install tokenizers==0.15.0
pip install safetensors==0.4.1
pip install transformers==4.36.2

# 3. Everything else
pip install -r requirements.txt
```

### Why This Order Matters

1. **PyTorch First**: Base framework for all ML models
2. **HF Hub**: Authentication and model downloading
3. **Tokenizers**: Text processing (compiled C++ bindings need specific versions)
4. **Safetensors**: Safe model loading format
5. **Transformers**: High-level API (depends on all above)

## Complete Clean Installation

### Windows

```powershell
# Remove old environment
Remove-Item -Recurse -Force venv

# Create new environment
python -m venv venv
.\venv\Scripts\activate

# Install in correct order
pip install --upgrade pip setuptools wheel

# PyTorch CPU
pip install torch==2.1.2+cpu torchvision==0.16.2+cpu --extra-index-url https://download.pytorch.org/whl/cpu

# Hugging Face stack
pip install huggingface-hub==0.20.2 tokenizers==0.15.0 safetensors==0.4.1 transformers==4.36.2

# Flask & database
pip install flask==3.0.0 flask-cors==4.0.0 pymongo==4.6.1 python-dotenv==1.0.0

# LangChain stack
pip install langchain==0.1.0 langchain-community==0.0.10 langgraph==0.0.20

# ML utilities
pip install faiss-cpu==1.7.4 sentence-transformers==2.2.2 scikit-learn==1.4.0

# Frontend
pip install streamlit==1.29.0 plotly==5.18.0

# Image processing
pip install pillow==10.2.0 opencv-python==4.9.0.80

# Data
pip install numpy==1.26.3 pandas==2.1.4

# HTTP
pip install requests==2.31.0 pydantic==2.5.3
```

### Verify Installation

```python
# test_dependencies.py
import torch
import transformers
import langchain
import langgraph
import streamlit
import pymongo

print("✓ All critical dependencies installed")
print(f"PyTorch: {torch.__version__}")
print(f"Transformers: {transformers.__version__}")
print(f"LangChain: {langchain.__version__}")
```

## Model Download Strategy

Models download automatically on first run. To pre-download:

```python
from transformers import pipeline

# Emotion model (~250MB)
pipeline("text-classification", model="j-hartmann/emotion-english-distilroberta-base")

# Sentiment model (~500MB)
pipeline("text-classification", model="cardiffnlp/twitter-roberta-base-sentiment-latest")

# Vision model (~350MB)
from transformers import ViTImageProcessor, ViTForImageClassification
ViTImageProcessor.from_pretrained("google/vit-base-patch16-224")
ViTForImageClassification.from_pretrained("google/vit-base-patch16-224")
```

## Backend Startup Checklist

Backend starts cleanly when:

✓ MongoDB running on port 27017
✓ PyTorch installed correctly
✓ Transformers installed correctly
✓ LangGraph installed correctly
✓ Models cached in `~/.cache/huggingface/`

Expected first startup:
```
INFO:backend.config.database:Connected to MongoDB: Mental_Platform_db
INFO:backend.services.emotion_service:Emotion model loaded
INFO:backend.services.sentiment_service:Sentiment model loaded
INFO:backend.services.vision_service:Vision model loaded
 * Running on http://127.0.0.1:5000
```

No warnings = properly configured.

## Common Issues

### Issue: "No module named 'torch'"
**Cause:** PyTorch not installed or wrong order
**Fix:**
```bash
pip install torch==2.1.2+cpu --extra-index-url https://download.pytorch.org/whl/cpu
```

### Issue: "Xet storage not available"
**Cause:** Optional package missing (safe to ignore)
**Fix (optional):**
```bash
pip install hf_xet
```

### Issue: Models download every time
**Cause:** Cache not being used
**Fix:** Check `~/.cache/huggingface/` exists and is writable

### Issue: Slow model loading
**Cause:** CPU inference (normal)
**Fix:** Use GPU build of PyTorch (advanced)

## Production Deployment

For production without warnings:

```bash
# requirements-prod.txt
torch==2.1.2+cpu
torchvision==0.16.2+cpu
huggingface-hub==0.20.2
tokenizers==0.15.0
safetensors==0.4.1
transformers==4.36.2
hf_xet==0.3.4  # Eliminates warning
# ... rest of dependencies
```

```bash
pip install -r requirements-prod.txt --no-cache-dir
```

---

**Senior AI Engineering Standard:**
- Explicit dependency ordering
- Version pinning
- CPU-optimized builds
- No missing packages
- Clean startup logs
