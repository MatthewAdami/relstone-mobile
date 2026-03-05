# Why SRV Connection String Doesn't Work in Node.js

## The Issue

You're seeing this error:
```
✗ Database connection error: querySrv ECONNREFUSED _mongodb._tcp.relstone-database.5uveelx.mongodb.net
```

## Why This Happens

### SRV vs Standard Connection Strings

**SRV Format (works in Compass, fails in Node.js):**
```
mongodb+srv://user:pass@relstone-database.5uveelx.mongodb.net/database
```

**Standard Format (works everywhere):**
```
mongodb://user:pass@ac-urgcpb5-shard-00-00.5uveelx.mongodb.net:27017,ac-urgcpb5-shard-00-01.5uveelx.mongodb.net:27017,ac-urgcpb5-shard-00-02.5uveelx.mongodb.net:27017/database
```

### The Technical Reason

1. **SRV Format**: Uses DNS SRV records for service discovery
   - MongoDB Compass uses the system DNS resolver (works)
   - Node.js uses its own DNS resolver (has issues on some systems)
   - Your Windows system's Node.js can't resolve SRV records properly

2. **Standard Format**: Uses direct hostnames
   - No DNS SRV lookup needed
   - Works reliably across all environments
   - This is what we're using now

## Current Status ✅

Your `.env` file now uses the **standard connection format** that works:

```env
ADMIN_DB_URI=mongodb://rels_db_ADMIN1:U6rru1Sq3uilaESO@ac-urgcpb5-shard-00-00.5uveelx.mongodb.net:27017,ac-urgcpb5-shard-00-01.5uveelx.mongodb.net:27017,ac-urgcpb5-shard-00-02.5uveelx.mongodb.net:27017/relstone-admin?ssl=true&authSource=admin&retryWrites=true&w=majority
```

## Test Results ✅

```
✅ Successfully connected to Admin Database (326ms)
✅ Server ping successful: { ok: 1 }
✅ Server version: 8.0.19

✅ Successfully connected to Web Database (330ms)
✅ Server ping successful: { ok: 1 }
✅ Server version: 8.0.19
```

**Both databases are working perfectly!**

---

## How to Start Your Server

### Method 1: PowerShell (Recommended)
```powershell
cd C:\Users\Dianne\StudioProjects\relstone-mobile\backend
.\start-server.ps1
```

### Method 2: Standard npm
```powershell
cd C:\Users\Dianne\StudioProjects\relstone-mobile\backend

# Make sure no other server is running
Stop-Process -Name node -Force

# Start the server
npm run dev
```

### Method 3: Batch File
```powershell
cd C:\Users\Dianne\StudioProjects\relstone-mobile\backend
.\start-server.bat
```

---

## Expected Output

When you start the server, you should see:

```
[nodemon] starting `node server.js`

📡 Connecting to databases...
✓ Connected to MongoDB Admin Database
✓ Connected to MongoDB Web Database

✓ Server is running on http://localhost:5000
📚 API Documentation available at http://localhost:5000/
🏥 Health check: http://localhost:5000/api/v1/health
```

---

## If Port 5000 is in Use

You saw this error:
```
Error: listen EADDRINUSE: address already in use :::5000
```

**Solution:**
```powershell
# Kill all Node processes
Stop-Process -Name node -Force

# Wait a moment
Start-Sleep -Seconds 2

# Start again
npm run dev
```

Or use the startup scripts which do this automatically!

---

## Summary

✅ **Connection Works** - Test passed with flying colors
✅ **Using Standard Format** - Bypasses Node.js DNS SRV issues
✅ **Same Credentials** - Same username/password as Compass
✅ **Same Data** - Connects to exact same databases

**The connection string format is different, but connects to the same MongoDB cluster!**

---

## Quick Start

1. **Open PowerShell**
2. **Navigate to backend:**
   ```powershell
   cd C:\Users\Dianne\StudioProjects\relstone-mobile\backend
   ```
3. **Stop any existing servers:**
   ```powershell
   Stop-Process -Name node -Force
   ```
4. **Start the server:**
   ```powershell
   npm run dev
   ```

5. **Test in browser:**
   - http://localhost:5000/api/v1/health

You should see both databases connected: ✅

---

## Technical Note

This is a known issue with Node.js on Windows:
- The Node.js DNS resolver sometimes can't query SRV records
- This is NOT a problem with your setup
- This is NOT a problem with MongoDB Atlas
- The solution is to use standard connection strings instead
- Both formats connect to the exact same database cluster

**Your backend is working correctly now!** 🎉

