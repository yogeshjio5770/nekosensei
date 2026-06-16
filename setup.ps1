# Setup Script — Run after installing Flutter SDK
# This generates Android/iOS platform folders while preserving lib/ source code.

Write-Host "Nihongo Master Setup" -ForegroundColor Cyan
Write-Host "====================" -ForegroundColor Cyan

# Check Flutter
$flutter = Get-Command flutter -ErrorAction SilentlyContinue
if (-not $flutter) {
    Write-Host "ERROR: Flutter SDK not found. Install from https://flutter.dev" -ForegroundColor Red
    exit 1
}

Write-Host "`n[1/5] Generating platform folders..." -ForegroundColor Yellow
flutter create --project-name nihongo_master --org com.nihongomaster .

Write-Host "`n[2/5] Installing dependencies..." -ForegroundColor Yellow
flutter pub get

Write-Host "`n[3/5] Setting up environment..." -ForegroundColor Yellow
if (-not (Test-Path ".env")) {
    Copy-Item ".env.example" ".env"
    Write-Host "Created .env — add your GROQ_API_KEY" -ForegroundColor Green
}

Write-Host "`n[4/5] Firebase setup (manual step required):" -ForegroundColor Yellow
Write-Host "  Run: dart pub global activate flutterfire_cli"
Write-Host "  Run: flutterfire configure"
Write-Host "  Enable Auth, Firestore, Storage, FCM in Firebase Console"

Write-Host "`n[5/5] Deploy Firestore rules:" -ForegroundColor Yellow
Write-Host "  Run: firebase deploy --only firestore:rules"

Write-Host "`nSetup complete! Run: flutter run" -ForegroundColor Green
