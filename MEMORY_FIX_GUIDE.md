# Memory Issue Fix Guide

## Problem
Your system ran out of memory when loading the Vision model. Error: "Le fichier de pagination est insuffisant pour terminer cette opération"

## Solution 1: Increase Windows Virtual Memory (Paging File)

### Steps:

1. **Open System Properties**
   - Press `Win + Pause/Break` OR
   - Right-click "This PC" → Properties → Advanced system settings

2. **Go to Performance Settings**
   - Click "Settings" under Performance section
   - Go to "Advanced" tab
   - Click "Change" under Virtual Memory

3. **Increase Paging File Size**
   - Uncheck "Automatically manage paging file size"
   - Select your C: drive
   - Choose "Custom size"
   - Set **Initial size**: `8192` MB (8GB)
   - Set **Maximum size**: `16384` MB (16GB)
   - Click "Set"
   - Click "OK" on all dialogs

4. **Restart Computer**
   - This is required for changes to take effect

---

## Solution 2: Analyze Text Only (Without Images)

If you just want to test quickly:

1. Remove the uploaded images from the frontend
2. Just type text in the text area
3. Click "ANALYZE PSYCHOLOGICAL STATE"
4. This will only use emotion + sentiment models (no vision model)

---

## Solution 3: Reduce Model Memory Usage

Edit the vision service to use a smaller model or optimize memory usage.

### Option A: Use CPU-only mode (already set)
The models are already using CPU. This is fine.

### Option B: Clear model cache and reload
In PowerShell:
```powershell
Remove-Item -Recurse -Force "$env:USERPROFILE\.cache\huggingface"
```

Then restart backend.

---

## Solution 4: Upgrade System RAM

If you frequently work with AI models:
- Consider upgrading to 16GB or 32GB RAM
- Current requirement: ~8GB RAM minimum for all 3 models

---

## Quick Workaround (RIGHT NOW)

1. **Close the backend** (Ctrl+C)
2. **Close unnecessary apps**
3. **Restart backend**: `python backend/app.py`
4. **Test with TEXT ONLY first** (no images)

Once text analysis works, try adding ONE image (not two).
