import 'package:lunchbox_buddy/core/data/database/daos.dart';
import 'package:lunchbox_buddy/core/data/models/models.dart';
import 'package:lunchbox_buddy/features/kids/domain/kids_repository.dart';

class KidsRepositoryImpl implements KidsRepository {
  KidsRepositoryImpl(this._dao);

  final KidProfilesDao _dao;

  @override
  Future<List<KidProfile>> getKids() async {
    return _dao.getAllProfiles();
  }

  @override
  Future<KidProfile?> getKidById(String id) async {
    final all = await _dao.getAllProfiles();
    return all.cast<KidProfile?>().firstWhere(
      (k) => k?.id == id,
      orElse: () => null,
    );
  }

  @override
  Future<void> saveKid(KidProfile kid) async {
    await _dao.insertProfile(kid);
  }

  @override
  Future<void> deleteKid(String id) async {
    await _dao.deleteProfile(id);
  }
}
