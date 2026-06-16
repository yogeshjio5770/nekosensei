import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/main_shell.dart';
import '../screens/course/course_screen.dart';
import '../screens/course/module_detail_screen.dart';
import '../screens/course/lesson_flow_screen.dart';
import '../screens/course/kana_screen.dart';
import '../screens/course/vocabulary_screen.dart';
import '../screens/course/grammar_screen.dart';
import '../screens/course/conversation_screen.dart';
import '../screens/quiz/quiz_screen.dart';
import '../screens/quiz/quiz_result_screen.dart';
import '../screens/exam/exam_screen.dart';
import '../screens/exam/exam_result_screen.dart';
import '../screens/exam/certificates_screen.dart';
import '../screens/exam/certificate_detail_screen.dart';
import '../screens/tutor/ai_tutor_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/progress_screen.dart';
import '../screens/profile/leaderboard_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/admin_lessons_screen.dart';
import '../screens/admin/admin_users_screen.dart';
import '../screens/admin/admin_analytics_screen.dart';
import '../screens/practice/daily_boost_screen.dart';
import '../screens/practice/quick_review_screen.dart';
import '../config/page_transitions.dart';
import '../screens/practice/conversation_practice_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/about/why_nekosensei_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/why-nekosensei',
        builder: (_, __) => const WhyNekoSenseiScreen(),
      ),
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (_, __) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (_, __) => const ForgotPasswordScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (_, __, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (_, __) => AppPageTransitions.slideUp(
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/course',
            builder: (_, __) => const CourseScreen(),
          ),
          GoRoute(
            path: '/tutor',
            builder: (_, __) => const AiTutorScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (_, __) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/module/:moduleId',
        builder: (_, state) => ModuleDetailScreen(
          moduleId: state.pathParameters['moduleId']!,
        ),
      ),
      GoRoute(
        path: '/lesson/:lessonId',
        pageBuilder: (_, state) => AppPageTransitions.slideUp(
          key: state.pageKey,
          child: LessonFlowScreen(
            lessonId: state.pathParameters['lessonId']!,
          ),
        ),
      ),
      GoRoute(
        path: '/daily-boost',
        builder: (_, __) => const DailyBoostScreen(),
      ),
      GoRoute(
        path: '/quick-review',
        builder: (_, __) => const QuickReviewScreen(),
      ),
      GoRoute(
        path: '/conversation-practice',
        builder: (_, __) => const ConversationPracticeScreen(),
      ),
      GoRoute(
        path: '/conversation-practice/:scenarioId',
        builder: (_, state) => ConversationPracticeScreen(
          scenarioId: state.pathParameters['scenarioId'],
        ),
      ),
      GoRoute(
        path: '/kana/:type',
        builder: (_, state) => KanaScreen(
          type: state.pathParameters['type']!,
        ),
      ),
      GoRoute(
        path: '/vocabulary/:category',
        builder: (_, state) => VocabularyScreen(
          category: state.pathParameters['category']!,
        ),
      ),
      GoRoute(
        path: '/grammar/:topicId',
        builder: (_, state) => GrammarScreen(
          topicId: state.pathParameters['topicId']!,
        ),
      ),
      GoRoute(
        path: '/conversation/:topicId',
        builder: (_, state) => ConversationScreen(
          topicId: state.pathParameters['topicId']!,
        ),
      ),
      GoRoute(
        path: '/quiz/:lessonId',
        pageBuilder: (_, state) => AppPageTransitions.slideUp(
          key: state.pageKey,
          child: QuizScreen(
            lessonId: state.pathParameters['lessonId']!,
          ),
        ),
      ),
      GoRoute(
        path: '/quiz-result',
        builder: (_, state) => QuizResultScreen(
          extra: state.extra as Map<String, dynamic>,
        ),
      ),
      GoRoute(
        path: '/exam/:levelId',
        builder: (_, state) => ExamScreen(
          levelId: state.pathParameters['levelId']!,
        ),
      ),
      GoRoute(
        path: '/exam-result',
        builder: (_, state) => ExamResultScreen(
          extra: state.extra as Map<String, dynamic>,
        ),
      ),
      GoRoute(
        path: '/certificates',
        builder: (_, __) => const CertificatesScreen(),
      ),
      GoRoute(
        path: '/certificate/:certId',
        builder: (_, state) => CertificateDetailScreen(
          certId: state.pathParameters['certId']!,
        ),
      ),
      GoRoute(
        path: '/progress',
        builder: (_, __) => const ProgressScreen(),
      ),
      GoRoute(
        path: '/leaderboard',
        builder: (_, __) => const LeaderboardScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (_, __) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/lessons',
        builder: (_, __) => const AdminLessonsScreen(),
      ),
      GoRoute(
        path: '/admin/users',
        builder: (_, __) => const AdminUsersScreen(),
      ),
      GoRoute(
        path: '/admin/analytics',
        builder: (_, __) => const AdminAnalyticsScreen(),
      ),
    ],
  );
}
