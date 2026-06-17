import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import 'dart:async';

final battleServiceProvider = Provider((ref) {
  return BattleService();
});

class BattleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Matchmaking: Returns a live_battles document ID
  Future<String> joinMatchmaking(String userId, String displayName) async {
    final snapshot = await _firestore
        .collection('live_battles')
        .where('status', isEqualTo: 'waiting')
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Join as player 2
      final doc = snapshot.docs.first;
      await doc.reference.update({
        'player2Id': userId,
        'player2Name': displayName,
        'status': 'active',
        'startTime': FieldValue.serverTimestamp(),
      });
      return doc.id;
    } else {
      // Create as player 1
      final docRef = await _firestore.collection('live_battles').add({
        'player1Id': userId,
        'player1Name': displayName,
        'player1Score': 0,
        'player2Id': null,
        'player2Name': null,
        'player2Score': 0,
        'status': 'waiting',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    }
  }

  // Stream a live battle document
  Stream<DocumentSnapshot> getBattleStream(String battleId) {
    return _firestore.collection('live_battles').doc(battleId).snapshots();
  }

  // Increment live score
  Future<void> incrementScore(String battleId, bool isPlayer1) async {
    final field = isPlayer1 ? 'player1Score' : 'player2Score';
    await _firestore.collection('live_battles').doc(battleId).update({
      field: FieldValue.increment(1),
    });
  }

  // End live battle
  Future<void> endBattle(String battleId, String userId, bool won) async {
    await _firestore.collection('live_battles').doc(battleId).update({
      'status': 'finished',
    });
    
    final xpReward = won ? 50 : 10;
    await _firestore.collection('users').doc(userId).update({
      'xpPoints': FieldValue.increment(xpReward),
    });
  }

  // Cancel matchmaking if timeout
  Future<void> cancelMatchmaking(String battleId) async {
    await _firestore.collection('live_battles').doc(battleId).delete();
  }

  // ----------------------------------------------------
  // GHOST BATTLE FALLBACK
  // ----------------------------------------------------
  Future<Map<String, dynamic>> findGhostOpponent() async {
    final randomScore = 5 + Random().nextInt(15); 
    return {
      'uid': 'ghost_${Random().nextInt(1000)}',
      'displayName': 'Ghost Player',
      'finalScore': randomScore,
    };
  }

  Future<void> submitGhostBattleResult({
    required String userId,
    required int myScore,
    required int opponentScore,
    required String opponentId,
  }) async {
    final won = myScore > opponentScore;
    final xpReward = won ? 50 : 10;
    await _firestore.collection('users').doc(userId).update({
      'xpPoints': FieldValue.increment(xpReward),
    });
  }
}
