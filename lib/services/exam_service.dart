import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/lesson_models.dart';
import '../models/user_model.dart';
import '../config/constants.dart';
import 'certificate_service.dart';
import 'package:uuid/uuid.dart';

class ExamService {
  ExamService({
    FirebaseFirestore? firestore,
    CertificateService? certificateService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _certificateService = certificateService ?? CertificateService();

  final FirebaseFirestore _firestore;
  final CertificateService _certificateService;
  final _uuid = const Uuid();

  Future<CertificationExam?> getExamForLevel(String levelId) async {
    final levelInfo = AppConstants.certificateLevels[levelId];
    if (levelInfo == null) return null;

    final doc = await _firestore
        .collection('exams')
        .doc(levelInfo.examId)
        .get();
    if (!doc.exists) {
      return _getLocalExam(levelId);
    }
    return _parseExam(doc.data()!);
  }

  CertificationExam _getLocalExam(String levelId) {
    return CertificationExam(
      id: 'exam_$levelId',
      levelId: levelId,
      title: '${AppConstants.certificateLevels[levelId]?.title ?? levelId} Certification Exam',
      sections: [
        ExamSection(
          id: 'vocabulary',
          title: 'Vocabulary',
          maxMarks: 20,
          questions: _sampleQuestions('vocabulary', 5),
        ),
        ExamSection(
          id: 'grammar',
          title: 'Grammar',
          maxMarks: 20,
          questions: _sampleQuestions('grammar', 5),
        ),
        ExamSection(
          id: 'reading',
          title: 'Reading',
          maxMarks: 20,
          questions: _sampleQuestions('reading', 5),
        ),
        ExamSection(
          id: 'listening',
          title: 'Listening',
          maxMarks: 20,
          questions: _sampleQuestions('listening', 5),
        ),
        ExamSection(
          id: 'conversation',
          title: 'Conversation',
          maxMarks: 20,
          questions: _sampleQuestions('conversation', 5),
        ),
      ],
    );
  }

  List<QuizQuestion> _sampleQuestions(String section, int count) {
    final questions = <QuizQuestion>[];
    final templates = _questionTemplates[section] ?? _questionTemplates['vocabulary']!;

    for (var i = 0; i < count; i++) {
      final t = templates[i % templates.length];
      questions.add(QuizQuestion(
        id: '${section}_q$i',
        type: QuestionType.multipleChoice,
        question: t['question'] as String,
        correctAnswer: t['answer'] as String,
        options: List<String>.from(t['options'] as List),
        explanation: t['explanation'] as String?,
      ));
    }
    return questions;
  }

  static const _questionTemplates = {
    'vocabulary': [
      {
        'question': 'What does 水 (mizu) mean?',
        'answer': 'Water',
        'options': ['Fire', 'Water', 'Earth', 'Air'],
        'explanation': '水 (mizu) means water.',
      },
      {
        'question': 'What is the Japanese word for "book"?',
        'answer': '本 (hon)',
        'options': ['本 (hon)', '紙 (kami)', '机 (tsukue)', 'ペン (pen)'],
        'explanation': '本 (hon) means book.',
      },
    ],
    'grammar': [
      {
        'question': 'Which particle marks the topic?',
        'answer': 'は (wa)',
        'options': ['を (wo)', 'は (wa)', 'に (ni)', 'で (de)'],
        'explanation': 'は (wa) marks the topic of a sentence.',
      },
      {
        'question': 'How do you say "I am a student"?',
        'answer': '私は学生です',
        'options': ['私は学生です', '私を学生です', '私が学生です', '私に学生です'],
        'explanation': '私は学生です (watashi wa gakusei desu).',
      },
    ],
    'reading': [
      {
        'question': '田中さんは学生です。What is Tanaka?',
        'answer': 'A student',
        'options': ['A teacher', 'A student', 'A doctor', 'A worker'],
        'explanation': '学生 (gakusei) means student.',
      },
    ],
    'listening': [
      {
        'question': 'What greeting did you hear? (こんにちは)',
        'answer': 'Hello (Good afternoon)',
        'options': ['Good morning', 'Hello (Good afternoon)', 'Good night', 'Goodbye'],
        'explanation': 'こんにちは (konnichiwa) is a daytime greeting.',
      },
    ],
    'conversation': [
      {
        'question': 'How do you respond to はじめまして?',
        'answer': 'はじめまして。よろしくお願いします。',
        'options': [
          'さようなら',
          'はじめまして。よろしくお願いします。',
          'お疲れ様です',
          'いただきます',
        ],
        'explanation': 'Respond with the same greeting plus よろしくお願いします.',
      },
    ],
  };

  CertificationExam _parseExam(Map<String, dynamic> data) {
    final sections = (data['sections'] as List).map((s) {
      final questions = (s['questions'] as List).map((q) {
        return QuizQuestion(
          id: q['id'] as String,
          type: QuestionType.values.firstWhere(
            (t) => t.name == q['type'],
            orElse: () => QuestionType.multipleChoice,
          ),
          question: q['question'] as String,
          correctAnswer: q['correctAnswer'] as String,
          options: List<String>.from(q['options'] ?? []),
          explanation: q['explanation'] as String?,
        );
      }).toList();
      return ExamSection(
        id: s['id'] as String,
        title: s['title'] as String,
        maxMarks: s['maxMarks'] as int,
        questions: questions,
      );
    }).toList();

    return CertificationExam(
      id: data['id'] as String,
      levelId: data['levelId'] as String,
      title: data['title'] as String,
      sections: sections,
      totalMarks: data['totalMarks'] as int? ?? 100,
      passingScore: data['passingScore'] as int? ?? 70,
    );
  }

  ExamResult calculateResult({
    required CertificationExam exam,
    required Map<String, Map<String, String>> answers,
    required String userId,
  }) {
    final sectionScores = <String, int>{};
    var totalScore = 0;

    for (final section in exam.sections) {
      var sectionScore = 0;
      final marksPerQuestion = section.maxMarks ~/ section.questions.length;

      for (final question in section.questions) {
        final userAnswer = answers[section.id]?[question.id];
        if (userAnswer?.trim().toLowerCase() ==
            question.correctAnswer.trim().toLowerCase()) {
          sectionScore += marksPerQuestion;
        }
      }
      sectionScores[section.id] = sectionScore;
      totalScore += sectionScore;
    }

    return ExamResult(
      examId: exam.id,
      levelId: exam.levelId,
      userId: userId,
      totalScore: totalScore,
      sectionScores: sectionScores,
      passed: totalScore >= exam.passingScore,
      completedAt: DateTime.now(),
    );
  }

  Future<CertificateModel?> submitExam({
    required UserModel user,
    required CertificationExam exam,
    required Map<String, Map<String, String>> answers,
  }) async {
    final result = calculateResult(
      exam: exam,
      answers: answers,
      userId: user.uid,
    );

    await _firestore.collection('exam_results').add({
      'examId': result.examId,
      'levelId': result.levelId,
      'userId': result.userId,
      'totalScore': result.totalScore,
      'sectionScores': result.sectionScores,
      'passed': result.passed,
      'completedAt': result.completedAt.toIso8601String(),
    });

    if (!result.passed) return null;

    final levelInfo = AppConstants.certificateLevels[result.levelId]!;
    final certId = _uuid.v4().substring(0, 8).toUpperCase();
    final verificationCode = _uuid.v4();

    final certificate = CertificateModel(
      id: certId,
      userId: user.uid,
      studentName: user.name,
      levelId: result.levelId,
      levelTitle: levelInfo.title,
      finalScore: result.totalScore,
      issuedAt: DateTime.now(),
      verificationCode: verificationCode,
    );

    await _firestore.collection('certificates').doc(certId).set({
      'userId': user.uid,
      'studentName': user.name,
      'levelId': result.levelId,
      'levelTitle': levelInfo.title,
      'finalScore': result.totalScore,
      'issuedAt': certificate.issuedAt.toIso8601String(),
      'verificationCode': verificationCode,
    });

    await _firestore.collection('users').doc(user.uid).update({
      'certificateLevels': FieldValue.arrayUnion([result.levelId]),
      'earnedBadges': FieldValue.arrayUnion(['${result.levelId.toLowerCase()}_certified']),
      'xpPoints': FieldValue.increment(AppConstants.xpExamPass),
    });

    return certificate;
  }

  Future<bool> canTakeExam(UserModel user, String levelId) async {
    final levelInfo = AppConstants.certificateLevels[levelId];
    if (levelInfo == null) return false;

    if (user.certificateLevels.contains(levelId)) return false;

    if (levelInfo.prerequisiteLevel != null &&
        !user.certificateLevels.contains(levelInfo.prerequisiteLevel)) {
      return false;
    }

    return levelInfo.requiredModuleIds
        .every((m) => user.completedModules.contains(m));
  }

  Future<CertificateModel?> verifyCertificate(String certId) async {
    final doc = await _firestore.collection('certificates').doc(certId).get();
    if (!doc.exists) return null;
    final data = doc.data()!;
    return CertificateModel(
      id: certId,
      userId: data['userId'] as String,
      studentName: data['studentName'] as String,
      levelId: data['levelId'] as String,
      levelTitle: data['levelTitle'] as String,
      finalScore: data['finalScore'] as int,
      issuedAt: DateTime.parse(data['issuedAt'] as String),
      verificationCode: data['verificationCode'] as String,
    );
  }
}
