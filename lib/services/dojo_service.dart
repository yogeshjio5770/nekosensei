import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dojo_model.dart';
import '../providers/app_providers.dart';
import 'dart:math';

final dojoServiceProvider = Provider((ref) {
  return DojoService();
});

class DojoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createDojo(String name, String icon, String creatorId) async {
    final dojoId = 'dojo_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
    final dojo = DojoModel(
      id: dojoId,
      name: name,
      icon: icon,
      totalXp: 0,
      memberIds: [creatorId],
    );

    await _firestore.collection('dojos').doc(dojoId).set(dojo.toMap());
    
    // Update user's current dojo
    await _firestore.collection('users').doc(creatorId).update({
      'dojoId': dojoId,
    });
  }

  Future<void> joinDojo(String dojoId, String userId) async {
    await _firestore.collection('dojos').doc(dojoId).update({
      'memberIds': FieldValue.arrayUnion([userId]),
    });
    
    // Update user's current dojo
    await _firestore.collection('users').doc(userId).update({
      'dojoId': dojoId,
    });
  }

  Future<void> leaveDojo(String dojoId, String userId) async {
    await _firestore.collection('dojos').doc(dojoId).update({
      'memberIds': FieldValue.arrayRemove([userId]),
    });
    
    await _firestore.collection('users').doc(userId).update({
      'dojoId': FieldValue.delete(),
    });
  }

  Future<void> contributeXp(String dojoId, int xp) async {
    await _firestore.collection('dojos').doc(dojoId).update({
      'totalXp': FieldValue.increment(xp),
    });
  }

  Future<List<DojoModel>> getTopDojos() async {
    final snapshot = await _firestore
        .collection('dojos')
        .orderBy('totalXp', descending: true)
        .limit(20)
        .get();

    return snapshot.docs.map((doc) => DojoModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<DojoModel?> getDojo(String dojoId) async {
    final doc = await _firestore.collection('dojos').doc(dojoId).get();
    if (doc.exists) {
      return DojoModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }
}
