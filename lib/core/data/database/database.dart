import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:lunchbox_buddy/core/data/database/tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    IngredientsTable,
    RecipesTable,
    RecipeIngredientsTable,
    KidProfilesTable,
    MealFeedbacksTable,
    GroceryItemsTable,
    AppMetadataTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'lunchbox_buddy'));

  @override
  int get schemaVersion => 1;
}
