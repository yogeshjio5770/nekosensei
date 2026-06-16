# Nihongo Master — Firestore Database Schema

## Collections

### `users/{userId}`
| Field | Type | Description |
|-------|------|-------------|
| email | string | User email |
| displayName | string | Display name |
| photoUrl | string? | Profile photo URL |
| currentLevel | int | Gamification level (1-10) |
| xpPoints | int | Total XP earned |
| dailyStreak | int | Consecutive days active |
| lastActiveDate | string (ISO) | Last activity date |
| completedLessons | string[] | Lesson IDs completed |
| completedModules | string[] | Module IDs completed |
| earnedBadges | string[] | Badge IDs earned |
| certificateLevels | string[] | Earned cert levels: N5, N4, N3 |
| isAdmin | bool | Admin flag |
| createdAt | string (ISO) | Account creation date |

#### Subcollection: `users/{userId}/progress/{lessonId}`
| Field | Type | Description |
|-------|------|-------------|
| lessonId | string | Lesson reference |
| moduleId | string | Module reference |
| quizScore | int | Quiz score 0-100 |
| xpEarned | int | XP from this lesson |
| completedAt | string (ISO) | Completion timestamp |

---

### `modules/{moduleId}`
| Field | Type | Description |
|-------|------|-------------|
| title | string | Module title |
| description | string | Module description |
| order | int | Display order (1-7) |
| lessonIds | string[] | Ordered lesson IDs |

---

### `lessons/{lessonId}`
| Field | Type | Description |
|-------|------|-------------|
| moduleId | string | Parent module |
| title | string | Lesson title |
| description | string | Lesson description |
| order | int | Order within module |
| content | map | Lesson-specific content |
| quizIds | string[] | Associated quiz IDs |
| xpReward | int | XP on completion |
| estimatedMinutes | int | Duration estimate |

---

### `quizzes/{quizId}`
| Field | Type | Description |
|-------|------|-------------|
| lessonId | string | Parent lesson |
| title | string | Quiz title |
| questions | array | Question objects |
| timeLimitSeconds | int? | Optional timer |
| passingScore | int | Min score to pass (default 70) |

#### Question Object
```json
{
  "id": "q1",
  "type": "multipleChoice | matchWord | fillInBlank | listening",
  "question": "Question text",
  "correctAnswer": "Answer",
  "options": ["A", "B", "C", "D"],
  "explanation": "Why this is correct",
  "audioUrl": "storage path (listening only)"
}
```

---

### `exams/{examId}`
| Field | Type | Description |
|-------|------|-------------|
| levelId | string | N5, N4, N3 |
| title | string | Exam title |
| totalMarks | int | 100 |
| passingScore | int | 70 |
| timeLimitMinutes | int | 60 |
| sections | array | Exam sections |

#### Section Object
```json
{
  "id": "vocabulary",
  "title": "Vocabulary",
  "maxMarks": 20,
  "questions": [...]
}
```

---

### `exam_results/{resultId}`
| Field | Type | Description |
|-------|------|-------------|
| examId | string | Exam reference |
| levelId | string | Certificate level |
| userId | string | User reference |
| totalScore | int | 0-100 |
| sectionScores | map | { vocabulary: 18, grammar: 15, ... } |
| passed | bool | score >= 70 |
| completedAt | string (ISO) | Timestamp |

---

### `certificates/{certId}`
| Field | Type | Description |
|-------|------|-------------|
| userId | string | Certificate owner |
| studentName | string | Name on certificate |
| levelId | string | N5, N4, N3 |
| levelTitle | string | "N5 Beginner", etc. |
| finalScore | int | Exam score |
| issuedAt | string (ISO) | Issue date |
| verificationCode | string (UUID) | QR verification |

---

## Certificate Level Progression

| Level | Title | Required Modules | Prerequisite |
|-------|-------|------------------|--------------|
| N5 | N5 Beginner | hiragana, katakana, vocabulary, grammar | None |
| N4 | N4 Elementary | conversations, reading_writing | N5 certificate |
| N3 | N3 Intermediate | jlpt_prep | N4 certificate |

Each level has its own 100-mark exam (5 sections × 20 marks). Passing score: 70/100.
