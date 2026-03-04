# Developer Setup Guide

## ✨ Auto-Detection Feature

The Flutter app **automatically detects your platform** and uses the correct API URL!

**No manual configuration needed for:**
- ✅ Windows Desktop
- ✅ Android Emulator  
- ✅ iOS Simulator

Just run the app and it will connect to the correct backend address.

---

## 🔧 Setup Instructions by Platform

### ✅ Android Emulator (AUTO-DETECTED)
**No changes needed!** The app automatically uses `http://10.0.2.2:5000/api/v1`

**Steps:**
1. Start Android Emulator
2. Make sure backend is running: `cd backend && npm run dev`
3. Run Flutter app: `flutter run -d emulator-5554`
4. Login should work automatically ✅

---

### ✅ Windows Desktop (AUTO-DETECTED)
**No changes needed!** The app automatically uses `http://localhost:5000/api/v1`

**Steps:**
1. Make sure backend is running on Windows: `cd backend && npm run dev`
2. Run Flutter app on Windows: `flutter run -d windows`
3. Login should work automatically ✅

---

### ✅ iOS Simulator (AUTO-DETECTED)
**No changes needed!** The app automatically uses `http://localhost:5000/api/v1`

**Steps:**
1. Make sure backend is running: `cd backend && npm run dev`
2. Run Flutter app: `flutter run -d ios`
3. Login should work automatically ✅

---

### 📱 Real Android/iOS Device (MANUAL CONFIG NEEDED)
For devices on the same WiFi, you need to add your PC's IP address.

**Find your PC's IP:**
```powershell
# On Windows, in PowerShell:
ipconfig
# Look for IPv4 Address (e.g., 192.168.1.100)
```

**Edit `lib/login_screen.dart` line ~20:**
Change the fallback return value:
```dart
return 'http://192.168.1.100:5000/api/v1'; // Replace 192.168.1.100 with your IP
```

**Steps:**
1. Ensure your phone and PC are on the same WiFi
2. Make sure backend is running: `cd backend && npm run dev`
3. Run Flutter app: `flutter run`
4. Login should work

---

## 🎯 How It Works

The app uses `defaultTargetPlatform` to detect the platform and automatically select the correct URL:

```dart
static String get baseUrl {
  if (defaultTargetPlatform == TargetPlatform.windows) {
    return 'http://localhost:5000/api/v1';  // Windows
  } else if (defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2:5000/api/v1';   // Android Emulator
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    return 'http://localhost:5000/api/v1';  // iOS
  }
  return 'http://localhost:5000/api/v1';    // Fallback
}
```

---

## ⚠️ Important Notes

1. **No code changes needed** for Windows or Android Emulator - just run the app!
2. **Backend must be running** before attempting login
   - Check: `curl http://localhost:5000/api/v1/health`

3. **Common errors:**
   - "Cannot connect to server" = Backend not running
   - "Login endpoint not yet implemented" = Backend is running but endpoint not coded yet

---

## Backend Status

- **Default Port**: 5000
- **API Prefix**: /api/v1
- **Health Check**: `GET /api/v1/health`
- **Login**: `POST /api/v1/auth/login` (body: {email, password})
- **Register**: `POST /api/v1/auth/register` (body: {firstName, lastName, email, password})

To start backend:
```powershell
cd C:\Users\Dianne\StudioProjects\relstone-mobile\backend
npm run dev
```

---

## Quick Reference

| Platform | API URL | Command | Auto-Detect? |
|----------|---------|---------|--------------|
| Android Emulator | `http://10.0.2.2:5000/api/v1` | `flutter run -d emulator-5554` | ✅ Yes |
| Windows | `http://localhost:5000/api/v1` | `flutter run -d windows` | ✅ Yes |
| iOS Simulator | `http://localhost:5000/api/v1` | `flutter run -d ios` | ✅ Yes |
| Real Device | `http://192.168.x.x:5000/api/v1` | `flutter run` | ❌ Manual |

