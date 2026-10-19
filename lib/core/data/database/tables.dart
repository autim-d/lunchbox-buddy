import 'package:drift/drift.dart';

@DataClassName('IngredientEntry')
class IngredientsTable extends Table {
  TextColumn get id => text()();
  TextColumn get nameAr => text()();
  TextColumn get nameEn => text()();
  TextColumn get category => text()();
  TextColumn get allergens => text()(); // Stored as JSON array string
  BoolColumn get commonInRegion =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('RecipeEntry')
class RecipesTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get steps => text()(); // Stored as JSON array string
  IntColumn get prepMinutes => integer()();
  IntColumn get cookMinutes => integer()();
  IntColumn get servings => integer().withDefault(const Constant(1))();
  TextColumn get tags => text()(); // Stored as JSON array string
  TextColumn get source => text().withDefault(const Constant('curated'))();
  IntColumn get ageMinMonths => integer().withDefault(const Constant(12))();
  TextColumn get imagePath => text().nullable()();
  IntColumn get safetyVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('RecipeIngredientEntry')
class RecipeIngredientsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get recipeId => text()();
  TextColumn get ingredientId => text()();
  RealColumn get quantity => real().nullable()();
  TextColumn get unit => text().nullable()();
  TextColumn get displayText => text().nullable()();
  BoolColumn get optional => boolean().withDefault(const Constant(false))();
}

@DataClassName('KidProfileEntry')
class KidProfilesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  DateTimeColumn get birthDate => dateTime()();
  TextColumn get allergies => text()(); // JSON string
  TextColumn get dislikes => text()(); // JSON string
  TextColumn get likes => text()(); // JSON string
  IntColumn get pickyLevel => integer().withDefault(const Constant(0))();
  TextColumn get lunchboxType => text().withDefault(const Constant('none'))();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MealFeedbackEntry')
class MealFeedbacksTable extends Table {
  TextColumn get id => text()();
  TextColumn get recipeId => text()();
  TextColumn get kidId => text().nullable()();
  TextColumn get reaction => text()();
  TextColumn get reasonTag => text().nullable()();
  DateTimeColumn get date => dateTime()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('GroceryItemEntry')
class GroceryItemsTable extends Table {
  TextColumn get id => text()();
  TextColumn get ingredientId => text()();
  TextColumn get nameAr => text()();
  TextColumn get nameEn => text()();
  TextColumn get aisle => text()();
  RealColumn get quantity => real().nullable()();
  TextColumn get unit => text().nullable()();
  BoolColumn get isChecked => boolean().withDefault(const Constant(false))();
  TextColumn get recipeId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AppMetadataEntry')
class AppMetadataTable extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
