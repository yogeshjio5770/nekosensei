import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io' show Platform;
import '../models/user_model.dart';
import 'app_bootstrap.dart';

class AuthService {
  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn? _googleSignIn;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  GoogleSignIn? _getGoogleSignIn() {
    if (_googleSignIn != null) return _googleSignIn;
    if (!AppBootstrap.firebaseReady) return null;
    try {
      return GoogleSignIn.instance;
    } catch (e) {
      debugPrint('GoogleSignIn initialization failed: $e');
      return null;
    }
  }

  Future<UserModel?> getCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      return UserModel.fromMap(user.uid, doc.data()!);
    }
    final userModel = UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? user.email?.split('@').first ?? 'Learner',
      photoUrl: user.photoURL,
      createdAt: DateTime.now(),
    );
    await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
    return userModel;
  }

  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user!.updateDisplayName(displayName);

    final userModel = UserModel(
      uid: credential.user!.uid,
      email: email,
      displayName: displayName,
      createdAt: DateTime.now(),
    );
    await _firestore.collection('users').doc(userModel.uid).set(userModel.toMap());
    return userModel;
  }

  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final doc = await _firestore
        .collection('users')
        .doc(credential.user!.uid)
        .get();
    if (!doc.exists) {
      final userModel = UserModel(
        uid: credential.user!.uid,
        email: email,
        displayName: credential.user!.displayName ?? email.split('@').first,
        createdAt: DateTime.now(),
      );
      await _firestore.collection('users').doc(userModel.uid).set(userModel.toMap());
      return userModel;
    }
    return UserModel.fromMap(credential.user!.uid, doc.data()!);
  }

  Future<UserModel> signInWithGoogle() async {
    try {
      debugPrint('Attempting Google sign-in...');
      
      UserCredential userCredential;
      
      if (kIsWeb) {
        // Use Firebase Auth directly for Web
        final provider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(provider);
      } else {
        // Use google_sign_in package for mobile
        final googleSignIn = GoogleSignIn.instance;
        
        String? clientId;
        if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
          clientId = dotenv.env['GOOGLE_DESKTOP_CLIENT_ID'];
        }
        if (clientId != null) {
          await googleSignIn.initialize(clientId: clientId);
        } else {
          await googleSignIn.initialize(
            serverClientId: '301384322009-8bg83tro4d4e2j8447p2bm4fd2dt21ra.apps.googleusercontent.com',
          );
        }

        // Authenticate the user (new API replaces signIn())
        final googleUser = await googleSignIn.authenticate();

        final googleAuth = googleUser.authentication;
        final idToken = googleAuth.idToken;

        final List<String> scopes = ['email', 'profile'];
        final clientAuth = await googleUser.authorizationClient.authorizeScopes(scopes);
        final accessToken = clientAuth.accessToken;

        final credential = GoogleAuthProvider.credential(
          accessToken: accessToken,
          idToken: idToken,
        );
        userCredential = await _auth.signInWithCredential(credential);
      }
      
      final uid = userCredential.user!.uid;
      debugPrint('Firebase sign-in successful, uid: $uid');

      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(uid, doc.data()!);
      }

      final userModel = UserModel(
        uid: uid,
        email: userCredential.user!.email ?? '',
        displayName: userCredential.user!.displayName,
        photoUrl: userCredential.user!.photoURL,
        createdAt: DateTime.now(),
      );
      await _firestore.collection('users').doc(uid).set(userModel.toMap());
      return userModel;
    } catch (e, stackTrace) {
      debugPrint('Google sign-in error: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Google sign-in failed: $e');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    final googleSignIn = _getGoogleSignIn();
    if (googleSignIn != null && !kIsWeb) {
      try {
        String? clientId;
        if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
          clientId = dotenv.env['GOOGLE_DESKTOP_CLIENT_ID'];
        }
        if (clientId != null) {
          await googleSignIn.initialize(clientId: clientId);
        } else {
          await googleSignIn.initialize(
            serverClientId: '301384322009-8bg83tro4d4e2j8447p2bm4fd2dt21ra.apps.googleusercontent.com',
          );
        }
        await googleSignIn.signOut();
      } catch (_) {}
    }
    await _auth.signOut();
  }

  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    final user = _auth.currentUser;
    if (user == null) return;

    if (displayName != null) await user.updateDisplayName(displayName);
    if (photoUrl != null) await user.updatePhotoURL(photoUrl);

    await _firestore.collection('users').doc(user.uid).update({
      if (displayName != null) 'displayName': displayName,
      if (photoUrl != null) 'photoUrl': photoUrl,
    });
  }
}
