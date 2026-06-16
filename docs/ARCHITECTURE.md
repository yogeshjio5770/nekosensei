# Nihongo Master — Architecture

## Overview

Nihongo Master is a Flutter mobile app for learning Japanese from beginner to JLPT certification, backed by Firebase and powered by Groq AI.

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter App (UI)                      │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌───────────────┐  │
│  │  Auth   │ │ Course  │ │  Quiz   │ │  AI Tutor     │  │
│  │ Screens │ │ Modules │ │  Exam   │ │  (Groq API)   │  │
│  └────┬────┘ └────┬────┘ └────┬────┘ └──────┬────────┘  │
│       │           │           │              │           │
│  ┌────┴───────────┴───────────┴──────────────┴────────┐  │
│  │              Riverpod Providers / Services          │  │
│  └────┬───────────┬───────────┬──────────────┬────────┘  │
└───────┼───────────┼───────────┼──────────────┼───────────┘
        │           │           │              │
   ┌────┴────┐ ┌────┴────┐ ┌───┴────┐    ┌────┴─────┐
   │Firebase │ │Firestore│ │Storage │    │ Groq API │
   │  Auth   │ │   DB    │ │ (audio)│    │  Llama   │
   └─────────┘ └─────────┘ └────────┘    └──────────┘
```

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter 3.x, Material 3 |
| State | Riverpod |
| Navigation | go_router |
| Backend | Firebase |
| Database | Cloud Firestore |
| Auth | Firebase Auth (Email + Google) |
| Storage | Firebase Storage (audio/assets) |
| AI | Groq API (llama-3.3-70b-versatile) |
| Push | Firebase Cloud Messaging |
| Charts | fl_chart |
| PDF | pdf + printing packages |

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase config (generated)
├── config/
│   ├── constants.dart        # App constants, cert levels
│   ├── theme.dart            # Light/dark themes
│   └── routes.dart           # go_router navigation
├── models/
│   ├── user_model.dart       # User profile model
│   └── lesson_models.dart    # Course, quiz, exam models
├── services/
│   ├── auth_service.dart     # Firebase Auth
│   ├── progress_service.dart # XP, streaks, badges
│   ├── groq_service.dart     # AI tutor API
│   ├── exam_service.dart     # Certification exams
│   ├── certificate_service.dart # PDF generation
│   └── notification_service.dart # FCM
├── providers/
│   └── app_providers.dart    # Riverpod providers
├── data/
│   └── course_repository.dart # Local course content
├── screens/
│   ├── auth/                 # Login, signup, forgot password
│   ├── home/                 # Dashboard, main shell
│   ├── course/               # Modules, lessons, kana, vocab
│   ├── quiz/                 # Quiz flow + results
│   ├── exam/                 # Certification exams + certs
│   ├── tutor/                # AI chat tutor
│   ├── profile/              # Profile, progress, leaderboard
│   └── admin/                # Admin dashboard
└── widgets/
    ├── common/               # Reusable UI components
    └── home/                 # Dashboard widgets
```

## Navigation Flow

```
Splash → Login/Signup → Main Shell (Bottom Nav)
                          ├── Home (dashboard)
                          ├── Course (module list)
                          │     └── Module Detail → Lesson → Quiz → Result
                          ├── AI Tutor (chat)
                          └── Profile
                                ├── Progress Analytics
                                ├── Certificates → Level Exam → PDF
                                └── Leaderboard

Admin (profile, isAdmin=true) → Admin Dashboard
                                  ├── Manage Lessons
                                  ├── Manage Users
                                  └── Analytics
```

## Gamification System

- **XP**: Earned from lessons (25), perfect quizzes (+50), daily streak (+10), exam pass (+200)
- **Levels**: 10 levels based on XP thresholds
- **Streaks**: Daily activity tracking
- **Badges**: first_100_xp, week_streak, month_streak, hiragana_master, n5_certified
- **Leaderboard**: Top 20 users by XP

## Certificate System (Level-Based)

Instead of a single completion certificate, users earn level-specific certificates:

1. Complete required modules for a level
2. Pass the level exam (70/100)
3. Receive downloadable PDF with QR verification
4. Unlock next level (N5 → N4 → N3)

## API Integration — Groq

```
POST https://api.groq.com/openai/v1/chat/completions
Authorization: Bearer {GROQ_API_KEY}

{
  "model": "llama-3.3-70b-versatile",
  "messages": [
    { "role": "system", "content": "Yuki tutor prompt..." },
    { "role": "user", "content": "Explain particle は" }
  ]
}
```

Set `GROQ_API_KEY` in `.env` file. Falls back to mock responses when not configured.
