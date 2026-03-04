# Backend API Endpoints - All Implemented ✅

## Status
- ✅ Backend running on port 5000
- ✅ MongoDB connected
- ✅ All auth endpoints implemented (mock mode for development)

---

## Authentication Endpoints

### 1. **POST /api/v1/auth/login**
Login with email and password

**Request:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response (200):**
```json
{
  "message": "Login successful",
  "token": "mock_jwt_token_1234567890",
  "user": {
    "id": "123456789",
    "email": "user@example.com",
    "firstName": "user",
    "lastName": "User",
    "createdAt": "2026-03-04T11:00:00.000Z"
  }
}
```

---

### 2. **POST /api/v1/auth/register**
Create a new account

**Request:**
```json
{
  "firstName": "John",
  "lastName": "Doe",
  "email": "john@example.com",
  "password": "password123"
}
```

**Response (201):**
```json
{
  "message": "Account created successfully. Please verify your email.",
  "userId": "user_1772621231292",
  "email": "john@example.com"
}
```

---

### 3. **POST /api/v1/auth/verify-email**
Verify email with verification code

**Request:**
```json
{
  "userId": "user_1772621231292",
  "code": "000000"
}
```

**Response (200):**
```json
{
  "message": "Email verified successfully",
  "token": "mock_jwt_token_1234567890",
  "user": {
    "id": "user_1772621231292",
    "email": "john@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "verified": true
  }
}
```

---

### 4. **POST /api/v1/auth/resend-code**
Resend verification code to email

**Request:**
```json
{
  "userId": "user_1772621231292",
  "email": "john@example.com"
}
```

**Response (200):**
```json
{
  "message": "Verification code sent to your email",
  "email": "john@example.com",
  "expiresIn": 300
}
```

---

### 5. **POST /api/v1/auth/logout**
Logout current user

**Request:**
```json
{}
```

**Response (200):**
```json
{
  "message": "Logout successful"
}
```

---

### 6. **POST /api/v1/auth/forgot-password**
Request password reset

**Request:**
```json
{
  "email": "user@example.com"
}
```

**Response (200):**
```json
{
  "message": "Password reset link sent to your email",
  "email": "user@example.com"
}
```

---

### 7. **POST /api/v1/auth/reset-password**
Reset password with code

**Request:**
```json
{
  "email": "user@example.com",
  "code": "000000",
  "newPassword": "newpassword123"
}
```

**Response (200):**
```json
{
  "message": "Password reset successful",
  "email": "user@example.com"
}
```

---

## Health Check Endpoint

### **GET /api/v1/health**
Check backend status

**Response (200):**
```json
{
  "message": "Backend Health Check",
  "status": "healthy",
  "timestamp": "2026-03-04T11:00:00.000Z",
  "databases": {
    "admin": {
      "connected": true
    },
    "web": {
      "connected": true
    }
  }
}
```

---

## Testing Endpoints

### In PowerShell:

**Test Login:**
```powershell
$body = @{'email'='test@example.com';'password'='password123'} | ConvertTo-Json
Invoke-WebRequest -Uri http://localhost:5000/api/v1/auth/login -Method POST -Headers @{'Content-Type'='application/json'} -Body $body -UseBasicParsing
```

**Test Resend Code:**
```powershell
$body = @{'userId'='test_user_123';'email'='test@example.com'} | ConvertTo-Json
Invoke-WebRequest -Uri http://localhost:5000/api/v1/auth/resend-code -Method POST -Headers @{'Content-Type'='application/json'} -Body $body -UseBasicParsing
```

**Test Health:**
```powershell
Invoke-WebRequest -Uri http://localhost:5000/api/v1/health -UseBasicParsing
```

---

## Important Notes

1. **Mock Mode**: All endpoints use mock data for development/testing
2. **No Database Queries**: In production, these would connect to MongoDB
3. **Verification Code**: Currently accepts any 6-digit code or "000000"
4. **Auto-Detection**: Flutter app automatically selects correct API URL based on platform
5. **CORS Enabled**: All origins allowed in development

---

## What's Next

To make these production-ready:
1. Connect endpoints to MongoDB Admin and Web databases
2. Implement real email sending for verification codes
3. Add JWT token validation and refresh logic
4. Hash and salt passwords with bcryptjs
5. Add rate limiting and security headers
6. Implement actual database queries instead of mocks

