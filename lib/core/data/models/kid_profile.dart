import 'package:freezed_annotation/freezed_annotation.dart';

part 'kid_profile.freezed.dart';
part 'kid_profile.g.dart';

@freezed
abstract class KidProfile with _$KidProfile {
  const factory KidProfile({
    required String id,
    required String name,
    required DateTime birthDate,
    @Default(<String>[]) List<String> allergies,
    @Default(<String>[]) List<String> dislikes,
    @Default(<String>[]) List<String> likes,
    @Default(0) int pickyLevel,
    @Default('none') String lunchboxType,
    String? notes,
  }) = _KidProfile;

  factory KidProfile.fromJson(Map<String, dynamic> json) =>
      _$KidProfileFromJson(json);
}
