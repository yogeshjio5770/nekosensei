import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import 'auth_service.dart';
import 'progress_service.dart';

final petServiceProvider = Provider<PetService>((ref) => PetService(ref));

class PetService {
  PetService(this._ref);

  final Ref _ref;

  Future<void> feedPet() async {
    final user = await _ref.read(authServiceProvider).getCurrentUserProfile();
    if (user == null) return;

    final newHealth = (user.petHealth + 10).clamp(0, 100);
    final newHunger = (user.petHunger + 20).clamp(0, 100);
    await _ref.read(progressServiceProvider).updatePetStatus(
          user.uid,
          newHealth,
          newHunger,
        );
  }

  Future<void> processDailyDecay() async {
    final user = await _ref.read(authServiceProvider).getCurrentUserProfile();
    if (user == null) return;

    final now = DateTime.now();
    final lastActive = user.lastActiveDate ?? now;
    final difference = now.difference(lastActive).inDays;

    if (difference > 0) {
      final decayAmount = difference * 20;
      final newHealth = (user.petHealth - decayAmount).clamp(0, 100);
      final newHunger = (user.petHunger - decayAmount).clamp(0, 100);
      await _ref.read(progressServiceProvider).updatePetStatus(
            user.uid,
            newHealth,
            newHunger,
          );
    }
  }
}
