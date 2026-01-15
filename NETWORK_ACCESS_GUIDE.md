# Network Access Guide for MindScope AI

## Problem
When accessing the MindScope AI frontend from a network IP address (e.g., `http://192.168.2.134:8501`), the frontend cannot connect to the backend at `localhost:5000` because "localhost" refers to the client machine, not the server.

## Solution
The frontend now dynamically detects the backend URL. You have two options:

---

## Option 1: Quick Start with Batch File (Recommended)

### Step 1: Start Backend
```batch
cd backend
python app.py
```
The backend will listen on `0.0.0.0:5000` (all network interfaces).

### Step 2: Start Frontend with Network Access
Double-click: `START_FRONTEND_NETWORK.bat`

This script will:
- Auto-detect your local IP address
- Set the `BACKEND_HOST` environment variable
- Start Streamlit on `0.0.0.0:8501` (accessible from network)

### Step 3: Access from Any Device
- **From same machine**: `http://localhost:8501`
- **From network**: `http://192.168.2.134:8501` (use your actual IP)

---

## Option 2: Manual Configuration

### For Localhost Access Only
```batch
# Terminal 1: Start Backend
cd backend
python app.py

# Terminal 2: Start Frontend
cd frontend
streamlit run app.py
```
Access at: `http://localhost:8501`

### For Network Access
```batch
# Terminal 1: Start Backend
cd backend
python app.py

# Terminal 2: Start Frontend with Network Config
cd frontend

# Windows:
set BACKEND_HOST=192.168.2.134
streamlit run app.py --server.address 0.0.0.0

# Linux/Mac:
export BACKEND_HOST=192.168.2.134
streamlit run app.py --server.address 0.0.0.0
```
Replace `192.168.2.134` with your actual local IP address.

Access from network: `http://192.168.2.134:8501`

---

## Finding Your Local IP Address

### Windows
```batch
ipconfig
```
Look for "IPv4 Address" under your active network adapter (usually starts with 192.168.x.x or 10.x.x.x)

### Linux/Mac
```bash
ifconfig
# or
ip addr show
```

---

## Troubleshooting

### Backend Not Connected Error
If you see "Backend Not Connected" in the frontend:

1. **Check MongoDB is running**:
   ```batch
   net start MongoDB
   ```
   (Run as Administrator)

2. **Check backend is running**:
   - Look for: `MongoDB connection successful!`
   - Look for: `Running on http://0.0.0.0:5000`

3. **Check firewall** (if accessing from another device):
   - Windows Firewall may block incoming connections on port 5000 and 8501
   - Add rules to allow Python.exe through the firewall

4. **Verify BACKEND_HOST is set correctly**:
   - The frontend will show the current backend URL in the error message
   - Make sure it matches the IP where your backend is running

### Camera/Microphone Blocked
If browser blocks camera/microphone:

1. Click the blocked icon in the address bar (🚫)
2. Change dropdowns from "Bloquer" to "Autoriser" (Block → Allow)
3. Click "Réinitialiser les autorisations" (Reset permissions)
4. Refresh the page (F5)

---

## Architecture

```
┌─────────────────┐         ┌─────────────────┐
│   Client PC     │         │   Server PC     │
│   (Browser)     │         │  (Your Machine) │
├─────────────────┤         ├─────────────────┤
│                 │  HTTP   │                 │
│  Frontend UI    ├────────>│  Streamlit      │
│  192.168.2.134  │  :8501  │  0.0.0.0:8501   │
│                 │         │        │        │
│                 │  HTTP   │        ▼        │
│  API Requests   ├────────>│  Flask Backend  │
│  192.168.2.134  │  :5000  │  0.0.0.0:5000   │
│                 │         │        │        │
│                 │         │        ▼        │
│                 │         │    MongoDB      │
│                 │         │   localhost     │
└─────────────────┘         └─────────────────┘
```

**Key Points**:
- Backend listens on `0.0.0.0:5000` (all network interfaces)
- Frontend listens on `0.0.0.0:8501` (all network interfaces)
- MongoDB only needs to be accessible from localhost
- Client browsers connect to both frontend and backend on server's IP
- `BACKEND_HOST` environment variable tells frontend where to find backend

---

## Security Notes

1. **Network Access**: Both services are accessible from your local network. Make sure you trust devices on your network.

2. **Firewall**: You may need to configure Windows Firewall to allow incoming connections on ports 5000 and 8501.

3. **Production**: For production deployment, use:
   - HTTPS/SSL certificates
   - Authentication middleware
   - Reverse proxy (nginx/Apache)
   - Proper CORS configuration
   - Environment-based configuration

---

## Quick Reference

| Scenario | Backend Command | Frontend Command | Access URL |
|----------|----------------|------------------|------------|
| Localhost only | `python app.py` | `streamlit run app.py` | `http://localhost:8501` |
| Network access | `python app.py` | Use `START_FRONTEND_NETWORK.bat` | `http://YOUR_IP:8501` |
| Custom IP | `python app.py` | `set BACKEND_HOST=X.X.X.X && streamlit run app.py --server.address 0.0.0.0` | `http://X.X.X.X:8501` |

---

## Environment Variables

| Variable | Purpose | Example |
|----------|---------|---------|
| `BACKEND_HOST` | Backend server hostname/IP | `192.168.2.134` or `localhost` |
| `FLASK_PORT` | Backend port (default: 5000) | `5000` |
| `STREAMLIT_SERVER_ADDRESS` | Auto-set by Streamlit | (internal use) |

---

## Files Modified

1. **frontend/app.py**: Dynamic backend URL detection
2. **START_FRONTEND_NETWORK.bat**: Auto-configuration script
3. **NETWORK_ACCESS_GUIDE.md**: This documentation

Backend already configured with `host='0.0.0.0'` in `backend/app.py:45`.
