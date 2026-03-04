# Relstone Backend Server Startup Script
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Relstone Backend Server" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Navigate to backend directory
$BackendPath = "C:\Users\Dianne\StudioProjects\relstone-mobile\backend"
Set-Location $BackendPath

# Kill existing Node processes
Write-Host "Stopping any existing Node.js processes..." -ForegroundColor Yellow
Stop-Process -Name node -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# Start the server
Write-Host "`nStarting backend server..." -ForegroundColor Green
Write-Host "Server will be available at: http://localhost:5000`n" -ForegroundColor Green

npm run dev

