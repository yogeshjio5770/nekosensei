<p align="center">
  <img src="assets/images/nekosensei_logo.png" alt="NekoSensei" width="180"/>
</p>

<h1 align="center">NekoSensei ねこ先生</h1>

<p align="center">
  <strong>The #1 Japanese learning app — built to beat Duolingo at Japanese.</strong><br/>
  Speak · Listen · Understand · Certify (JLPT N5 → N3)
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.2+-02569B?logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Firebase-Backend-FFCA28?logo=firebase&logoColor=black" alt="Firebase"/>
  <img src="https://img.shields.io/badge/JLPT-N5%20N4%20N3-E53935" alt="JLPT"/>
  <img src="https://img.shields.io/badge/License-MIT-green" alt="MIT"/>
</p>

---

## Why NekoSensei beats Duolingo

| Feature | Duolingo | **NekoSensei** |
|---------|----------|----------------|
| Focus | 40+ languages | **Japanese only** |
| Lesson flow | Tap quizzes | **Learn → Listen → Speak → Quiz** |
| Speaking | Limited / paid | **Free mic practice every lesson** |
| Listening | Basic | **TTS on every word + drills** |
| Romaji | Hidden early | **Always for beginners** |
| AI tutor | Paid (Max) | **NekoSensei AI included** |
| Certificates | Streak badges | **JLPT PDF certificates + QR** |
| Daily learning | Streak | **5-min Daily Boost + SRS review** |

> **Duolingo teaches you to tap. NekoSensei teaches you to speak.**

---

## Features

- **Skill tree path** — Duolingo-style nodes with lock / current / complete states
- **4-step lessons** — Learn, Listen, Speak, Quiz
- **Animated mascot** — NekoSensei reacts to every answer
- **Sound + haptics** — correct / wrong / success feedback
- **Confetti + level-up** — celebrations on pass
- **Daily Boost** — 5 essential phrases in 5 minutes
- **Quick Review** — spaced repetition (SRS)
- **Conversation role-play** — speak real dialogues
- **AI tutor** — Groq-powered NekoSensei chat
- **JLPT certificates** — N5, N4, N3 with downloadable PDF
- **Demo mode** — try without Firebase setup
- **Dark mode** — full theme support

---

## Screenshots

_Add screenshots after first `flutter run` on device._

---

## Quick start

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) 3.2+
- Android Studio / Xcode (for mobile)
- Optional: Firebase project, Groq API key

### Run in 2 minutes (Demo mode)

```bash
git clone https://github.com/YOUR_USERNAME/nekosensei.git
cd nekosensei
cp lib/firebase_options.example.dart lib/firebase_options.dart
flutter pub get
flutter run
```

On login → tap **"Try Demo — No Account Needed"**

### Full setup

```bash
# Platform folders
flutter create --project-name nihongo_master --org com.nekosensei .

# Firebase
dart pub global activate flutterfire_cli
flutterfire configure

# Environment
cp .env.example .env
# Add GROQ_API_KEY to .env

flutter run
```

---

## Project structure

```
lib/
├── config/          # Theme, routes, constants
├── data/            # Course content, phrases
├── models/          # User, lesson, quiz models
├── services/        # Auth, audio, TTS, speech, AI, progress
├── screens/         # UI screens
├── widgets/         # Reusable components
└── providers/       # Riverpod state
```

---

## Tech stack

| Layer | Technology |
|-------|------------|
| Frontend | Flutter, Riverpod, go_router |
| Backend | Firebase Auth, Firestore, Storage, FCM |
| AI | Groq API (Llama 3.3) |
| Speech | flutter_tts, speech_to_text |
| Charts | fl_chart |
| PDF | pdf, printing |

---

## Certificate levels

| Level | Title | Modules |
|-------|-------|---------|
| N5 | Beginner | Hiragana, Katakana, Vocab, Grammar |
| N4 | Elementary | Conversations, Reading & Writing |
| N3 | Intermediate | JLPT Prep |

Pass exam (70/100) → earn downloadable certificate with QR verification.

---

## Contributing

Contributions welcome! Please open an issue first for large changes.

1. Fork the repo
2. Create a feature branch
3. Commit changes
4. Open a Pull Request

---

## License

MIT License — see [LICENSE](LICENSE)

---

<p align="center">
  Made with ❤️ and にゃん by the NekoSensei team<br/>
  <strong>Learn Japanese. Speak Japanese. Master Japanese.</strong>
</p>
