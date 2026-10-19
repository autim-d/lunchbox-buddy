import 'package:lunchbox_buddy/core/data/models/models.dart';

abstract interface class KidsRepository {
  Future<List<KidProfile>> getKids();
  Future<KidProfile?> getKidById(String id);
  Future<void> saveKid(KidProfile kid);
  Future<void> deleteKid(String id);
}
