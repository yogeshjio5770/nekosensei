# Publishing NekoSensei

## Is demo mode needed for the Play Store / App Store?

**Yes — keep demo mode in production.**

| Reason | Why |
|--------|-----|
| App review | Google/Apple reviewers must try the app without creating an account |
| Conversion | Users try lessons before signing up → higher installs |
| Offline / no Firebase | Works when Firebase is down or user has no network at first launch |

**Production setup:**
- Demo mode = local progress (`SharedPreferences`) — no server needed
- Real users = Firebase Auth (email + Google) for cloud sync, leaderboard, certificates
- Label the button **"Try Demo"** when Firebase is configured (already done in login screen)

---

## Pre-publish checklist

### 1. One-time setup (this machine)

```powershell
cd c:\duolingo
.\setup.ps1
```

This generates `android/` and `ios/` folders and copies Firebase template files.

### 2. Firebase (required for production)

```powershell
dart pub global activate flutterfire_cli
flutterfire configure
```

Enable in [Firebase Console](https://console.firebase.google.com):
- Authentication → Email + Google
- Firestore Database
- Storage (optional, for audio uploads)
- Cloud Messaging (optional, for streak reminders)

Deploy rules:
```powershell
firebase deploy --only firestore:rules
```

### 3. Environment

```powershell
Copy-Item .env.example .env
# Edit .env → set GROQ_API_KEY=your_key
```

### 4. App identity (before store upload)

| Item | File | Current |
|------|------|---------|
| Package name | `android/app/build.gradle` | `com.nihongomaster` |
| App name | `android/app/src/main/AndroidManifest.xml` | NekoSensei |
| Version | `pubspec.yaml` | `1.0.0+1` |

Consider changing org to `com.nekosensei` before first publish (harder to change later).

### 5. Signing (Android)

```powershell
keytool -genkey -v -keystore nekosensei-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias nekosensei
```

Create `android/key.properties`:
```properties
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=nekosensei
storeFile=../nekosensei-release.jks
```

Update `android/app/build.gradle` for release signing (see Flutter [Android deployment docs](https://docs.flutter.dev/deployment/android)).

### 6. Build release APK / AAB

```powershell
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab` → upload to **Google Play Console**.

For APK sideload:
```powershell
flutter build apk --release
```

### 7. iOS (Mac required)

```bash
flutter build ipa --release
```

Upload via Xcode → App Store Connect.

### 8. Store listing assets

Prepare:
- App icon 512×512 (PNG)
- Feature graphic 1024×500 (Play Store)
- 4–8 screenshots (phone + tablet)
- Short description (80 chars) + full description
- Privacy policy URL (required if you collect email via Firebase)

Suggested short description:
> Learn Japanese with speaking, listening & JLPT prep. Your cat sensei NekoSensei!

### 9. Permissions (already used)

- **Microphone** — speaking practice (declare in store listing)
- **Internet** — Firebase + AI tutor

### 10. Optional: native audio

Drop MP3 files in `assets/audio/native/` named by word, e.g. `こんにちは.mp3` or `konnichiwa.mp3`. App uses TTS when file is missing.

Generate clips with `tools/generate_sfx.py` or record native speaker audio.

---

## What’s ready vs still growing

| Area | Publish-ready? |
|------|----------------|
| Lesson flow (Learn→Listen→Speak→Quiz) | ✅ |
| Tap-to-match + type-in quizzes | ✅ |
| Animated mascot (no PNG needed) | ✅ |
| Demo mode with saved progress | ✅ |
| Firebase auth + progress | ✅ (after configure) |
| ~200 N5 vocabulary words | ✅ MVP |
| Full Duolingo-scale content (800+ N5 words) | 🔜 Content sprint |
| Native voice for all words | 🔜 Add audio files |
| Certificate QR verification server | 🔜 Deploy `nekosensei.app/verify` |

---

## Google Play — first upload steps

1. Create [Google Play Developer](https://play.google.com/console) account ($25 one-time)
2. Create app → **NekoSensei**
3. Upload `app-release.aab`
4. Complete content rating questionnaire
5. Add privacy policy
6. Submit for review — mention **demo mode** in review notes:
   > "Tap 'Try Demo' on login screen to access all lessons without account."

---

## Honest goal: beat Duolingo

Publishing v1.0 is achievable now. Beating Duolingo **100%** requires ongoing content production (not just code). Ship v1, then iterate:

1. **v1.0** — Publish with N5 content + speaking + demo
2. **v1.1** — Native audio pack + 400 more words
3. **v1.2** — N4 module + certificate verification live
4. **v2.0** — Leagues, friends, offline lessons
