import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunchbox_buddy/core/data/models/models.dart';
import 'package:lunchbox_buddy/core/data/providers.dart';
import 'package:lunchbox_buddy/features/kids/data/kids_repository_impl.dart';
import 'package:lunchbox_buddy/features/kids/domain/kids_repository.dart';

/// Provider for KidsRepository
final kidsRepositoryProvider = Provider<KidsRepository>((ref) {
  final dao = ref.watch(kidProfilesDaoProvider);
  return KidsRepositoryImpl(dao);
});

/// Notifier managing the list of KidProfiles
class KidsListNotifier extends AsyncNotifier<List<KidProfile>> {
  @override
  FutureOr<List<KidProfile>> build() async {
    final repo = ref.watch(kidsRepositoryProvider);
    return repo.getKids();
  }

  Future<void> addKid(KidProfile kid) async {
    final repo = ref.read(kidsRepositoryProvider);
    await repo.saveKid(kid);
    ref.invalidateSelf();
    await future;
  }

  Future<void> updateKid(KidProfile kid) async {
    final repo = ref.read(kidsRepositoryProvider);
    await repo.saveKid(kid);
    ref.invalidateSelf();
    await future;
  }

  Future<void> deleteKid(String id) async {
    final repo = ref.read(kidsRepositoryProvider);
    await repo.deleteKid(id);
    ref.invalidateSelf();
    await future;
  }

  Future<void> restoreKid(KidProfile kid) async {
    final repo = ref.read(kidsRepositoryProvider);
    await repo.saveKid(kid);
    ref.invalidateSelf();
    await future;
  }
}

final kidsListNotifierProvider =
    AsyncNotifierProvider<KidsListNotifier, List<KidProfile>>(
      KidsListNotifier.new,
    );

/// Active/selected child ID notifier for filtering meal recommendations
class ActiveKidIdNotifier extends Notifier<String?> {
  @override
  String? build() {
    final kidsAsync = ref.watch(kidsListNotifierProvider);
    return kidsAsync.asData?.value.firstOrNull?.id;
  }

  void selectKid(String id) {
    state = id;
  }
}

final activeKidIdProvider = NotifierProvider<ActiveKidIdNotifier, String?>(
  ActiveKidIdNotifier.new,
);
