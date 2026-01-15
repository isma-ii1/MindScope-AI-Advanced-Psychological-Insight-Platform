"""
Download all required AI models before running the application
Run this once: python download_models.py
"""

from transformers import AutoTokenizer, AutoModelForSequenceClassification, ViTImageProcessor, ViTForImageClassification
import torch

print("Starting model downloads...")
print("This will take several minutes depending on your internet connection.\n")

# 1. Emotion Model
print("1/3 Downloading emotion model (j-hartmann/emotion-english-distilroberta-base)...")
try:
    emotion_tokenizer = AutoTokenizer.from_pretrained("j-hartmann/emotion-english-distilroberta-base")
    emotion_model = AutoModelForSequenceClassification.from_pretrained("j-hartmann/emotion-english-distilroberta-base")
    print("✓ Emotion model downloaded successfully\n")
except Exception as e:
    print(f"✗ Error downloading emotion model: {e}\n")

# 2. Sentiment Model
print("2/3 Downloading sentiment model (cardiffnlp/twitter-roberta-base-sentiment-latest)...")
try:
    sentiment_tokenizer = AutoTokenizer.from_pretrained("cardiffnlp/twitter-roberta-base-sentiment-latest")
    sentiment_model = AutoModelForSequenceClassification.from_pretrained("cardiffnlp/twitter-roberta-base-sentiment-latest")
    print("✓ Sentiment model downloaded successfully\n")
except Exception as e:
    print(f"✗ Error downloading sentiment model: {e}\n")

# 3. Vision Model
print("3/3 Downloading vision model (google/vit-base-patch16-224)...")
try:
    vision_processor = ViTImageProcessor.from_pretrained("google/vit-base-patch16-224")
    vision_model = ViTForImageClassification.from_pretrained("google/vit-base-patch16-224")
    print("✓ Vision model downloaded successfully\n")
except Exception as e:
    print(f"✗ Error downloading vision model: {e}\n")

print("=" * 60)
print("All models downloaded successfully!")
print("You can now run the application.")
print("=" * 60)
