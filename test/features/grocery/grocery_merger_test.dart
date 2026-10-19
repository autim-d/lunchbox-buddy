import 'package:flutter_test/flutter_test.dart';
import 'package:lunchbox_buddy/core/data/models/grocery_item.dart';
import 'package:lunchbox_buddy/core/data/models/ingredient.dart';
import 'package:lunchbox_buddy/core/data/models/recipe.dart';
import 'package:lunchbox_buddy/core/data/models/recipe_ingredient.dart';
import 'package:lunchbox_buddy/features/grocery/domain/grocery_merger.dart';
import 'package:lunchbox_buddy/features/grocery/domain/grocery_share_formatter.dart';

void main() {
  group('UnitConverter', () {
    test('sums identical mass units (grams)', () {
      final res = UnitConverter.sumCompatible(
        q1: 150.0,
        u1: 'g',
        q2: 250.0,
        u2: 'g',
      );
      expect(res, isNotNull);
      expect(res!.quantity, 400.0);
      expect(res.unit, 'g');
    });

    test('sums grams and kilograms into kg when >= 1000g', () {
      final res = UnitConverter.sumCompatible(
        q1: 500.0,
        u1: 'g',
        q2: 1.0,
        u2: 'kg',
      );
      expect(res, isNotNull);
      expect(res!.quantity, 1.5);
      expect(res.unit, 'kg');
    });

    test('sums grams that cross 1000g threshold into kg', () {
      final res = UnitConverter.sumCompatible(
        q1: 600.0,
        u1: 'grams',
        q2: 600.0,
        u2: 'g',
      );
      expect(res, isNotNull);
      expect(res!.quantity, 1.2);
      expect(res.unit, 'kg');
    });

    test('sums metric volume units (ml and l)', () {
      final res = UnitConverter.sumCompatible(
        q1: 250.0,
        u1: 'ml',
        q2: 1.0,
        u2: 'l',
      );
      expect(res, isNotNull);
      expect(res!.quantity, 1.25);
      expect(res.unit, 'l');
    });

    test('sums culinary volume (tbsp and tbsp)', () {
      final res = UnitConverter.sumCompatible(
        q1: 2.0,
        u1: 'tbsp',
        q2: 1.0,
        u2: 'tbsp',
      );
      expect(res, isNotNull);
      expect(res!.quantity, 3.0);
      expect(res.unit, 'tbsp');
    });

    test('sums spoons: 1 tbsp + 1 tsp = 4 tsp or clean tbsp conversion', () {
      // 1 tbsp = 3 tsp, + 3 tsp = 6 tsp = 2 tbsp
      final res = UnitConverter.sumCompatible(
        q1: 1.0,
        u1: 'tbsp',
        q2: 3.0,
        u2: 'tsp',
      );
      expect(res, isNotNull);
      expect(res!.quantity, 2.0);
      expect(res.unit, 'tbsp');
    });

    test('sums count units: piece and pieces', () {
      final res = UnitConverter.sumCompatible(
        q1: 0.5,
        u1: 'piece',
        q2: 1.5,
        u2: 'pieces',
      );
      expect(res, isNotNull);
      expect(res!.quantity, 2.0);
      expect(res.unit, 'piece');
    });

    test('sums slices count', () {
      final res = UnitConverter.sumCompatible(
        q1: 2.0,
        u1: 'slices',
        q2: 2.0,
        u2: 'slices',
      );
      expect(res, isNotNull);
      expect(res!.quantity, 4.0);
      expect(res.unit, 'slices');
    });

    test('rejects incompatible units (e.g. piece vs grams)', () {
      final res = UnitConverter.sumCompatible(
        q1: 1.0,
        u1: 'piece',
        q2: 100.0,
        u2: 'g',
      );
      expect(res, isNull);
    });

    test('rejects incompatible count types (e.g. slices vs piece)', () {
      final res = UnitConverter.sumCompatible(
        q1: 2.0,
        u1: 'slices',
        q2: 1.0,
        u2: 'piece',
      );
      expect(res, isNull);
    });

    test('formats unit names to Arabic', () {
      expect(UnitConverter.formatUnitAr('g'), 'جرام');
      expect(UnitConverter.formatUnitAr('kg'), 'كجم');
      expect(UnitConverter.formatUnitAr('tbsp'), 'ملعقة كبيرة');
      expect(UnitConverter.formatUnitAr('tsp'), 'ملعقة صغيرة');
      expect(UnitConverter.formatUnitAr('piece'), 'حبة');
      expect(UnitConverter.formatUnitAr('slices'), 'شرائح');
      expect(UnitConverter.formatUnitAr('cup'), 'كوب');
    });
  });

  group('GroceryMerger', () {
    final canonicalMap = {
      'toast_brown': const Ingredient(
        id: 'toast_brown',
        nameAr: 'توست أسمر',
        nameEn: 'Brown Toast',
        category: 'bakery',
        allergens: ['gluten'],
        commonInRegion: true,
      ),
      'labneh': const Ingredient(
        id: 'labneh',
        nameAr: 'لبنة طازجة',
        nameEn: 'Fresh Labneh',
        category: 'dairy',
        allergens: ['milk'],
        commonInRegion: true,
      ),
      'cucumber': const Ingredient(
        id: 'cucumber',
        nameAr: 'خيار صغير طازج',
        nameEn: 'Fresh Mini Cucumber',
        category: 'produce',
        allergens: [],
        commonInRegion: true,
      ),
      'chicken': const Ingredient(
        id: 'chicken',
        nameAr: 'صدر دجاج طازج',
        nameEn: 'Chicken Breast',
        category: 'protein',
        allergens: [],
        commonInRegion: true,
      ),
    };

    const recipe1 = Recipe(
      id: 'rec_1',
      title: 'ساندوتش لبنة',
      description: 'وصفة 1',
      servings: 1,
      prepMinutes: 5,
      cookMinutes: 0,
      steps: ['خطوة 1'],
      ingredients: [
        RecipeIngredient(
          ingredientId: 'toast_brown',
          quantity: 2.0,
          unit: 'slices',
        ),
        RecipeIngredient(ingredientId: 'labneh', quantity: 2.0, unit: 'tbsp'),
        RecipeIngredient(
          ingredientId: 'cucumber',
          quantity: 0.5,
          unit: 'piece',
        ),
      ],
    );

    const recipe2 = Recipe(
      id: 'rec_2',
      title: 'رول خيار ولبنة',
      description: 'وصفة 2',
      servings: 1,
      prepMinutes: 5,
      cookMinutes: 0,
      steps: ['خطوة 1'],
      ingredients: [
        RecipeIngredient(ingredientId: 'labneh', quantity: 1.0, unit: 'tbsp'),
        RecipeIngredient(
          ingredientId: 'cucumber',
          quantity: 1.0,
          unit: 'piece',
        ),
        RecipeIngredient(ingredientId: 'chicken', quantity: 100.0, unit: 'g'),
      ],
    );

    test('adds only ingredients the user has not ticked', () {
      // User already has 'labneh' (ticked)
      final items = GroceryMerger.buildItemsFromRecipe(
        recipe: recipe1,
        targetServings: 1,
        tickedIngredientIds: {'labneh'},
        ingredientMasterMap: canonicalMap,
      );

      // Should only contain toast_brown and cucumber
      expect(items.length, 2);
      expect(items.any((it) => it.ingredientId == 'labneh'), isFalse);
      expect(items.any((it) => it.ingredientId == 'toast_brown'), isTrue);
      expect(items.any((it) => it.ingredientId == 'cucumber'), isTrue);
    });

    test('scales ingredient quantities correctly with servings stepper', () {
      // Scaling recipe1 from 1 serving to 3 servings
      final items = GroceryMerger.buildItemsFromRecipe(
        recipe: recipe1,
        targetServings: 3,
        tickedIngredientIds: {},
        ingredientMasterMap: canonicalMap,
      );

      final toast = items.firstWhere((it) => it.ingredientId == 'toast_brown');
      final labneh = items.firstWhere((it) => it.ingredientId == 'labneh');
      final cucumber = items.firstWhere((it) => it.ingredientId == 'cucumber');

      expect(toast.quantity, 6.0); // 2 * 3
      expect(labneh.quantity, 6.0); // 2 * 3
      expect(cucumber.quantity, 1.5); // 0.5 * 3
    });

    test('merges duplicates across additions and sums quantities with compatible units', () {
      final items1 = GroceryMerger.buildItemsFromRecipe(
        recipe: recipe1,
        targetServings: 1,
        tickedIngredientIds: {},
        ingredientMasterMap: canonicalMap,
      );

      final items2 = GroceryMerger.buildItemsFromRecipe(
        recipe: recipe2,
        targetServings: 1,
        tickedIngredientIds: {},
        ingredientMasterMap: canonicalMap,
      );

      // Merge items2 into items1
      final merged = GroceryMerger.mergeItems(
        existing: items1,
        incoming: items2,
      );

      // Unique ingredients: toast_brown, labneh, cucumber, chicken -> 4 total
      expect(merged.length, 4);

      final labneh = merged.firstWhere((it) => it.ingredientId == 'labneh');
      // 2 tbsp + 1 tbsp = 3 tbsp
      expect(labneh.quantity, 3.0);
      expect(labneh.unit, 'tbsp');
      expect(labneh.aisle, 'dairy');

      final cucumber = merged.firstWhere((it) => it.ingredientId == 'cucumber');
      // 0.5 piece + 1.0 piece = 1.5 piece
      expect(cucumber.quantity, 1.5);
      expect(cucumber.unit, 'piece');
      expect(cucumber.aisle, 'produce');

      final toast = merged.firstWhere((it) => it.ingredientId == 'toast_brown');
      expect(toast.quantity, 2.0);
      expect(toast.unit, 'slices');
      expect(toast.aisle, 'bakery');

      final chicken = merged.firstWhere((it) => it.ingredientId == 'chicken');
      expect(chicken.quantity, 100.0);
      expect(chicken.unit, 'g');
      expect(chicken.aisle, 'protein');
    });

    test('unchecks an existing item when new quantity is added', () {
      const initialItem = GroceryItem(
        id: 'toast_1',
        ingredientId: 'toast_brown',
        nameAr: 'توست أسمر',
        nameEn: 'Brown Toast',
        aisle: 'bakery',
        quantity: 2.0,
        unit: 'slices',
        isChecked: true, // Mother had previously checked it off
      );

      const newItem = GroceryItem(
        id: 'toast_2',
        ingredientId: 'toast_brown',
        nameAr: 'توست أسمر',
        nameEn: 'Brown Toast',
        aisle: 'bakery',
        quantity: 2.0,
        unit: 'slices',
        isChecked: false,
      );

      final merged = GroceryMerger.mergeItems(
        existing: [initialItem],
        incoming: [newItem],
      );

      expect(merged.length, 1);
      expect(merged.first.quantity, 4.0);
      // isChecked must be reset to false so mother buys the newly needed amount
      expect(merged.first.isChecked, isFalse);
    });
  });

  group('GroceryShareFormatter', () {
    test('formats plain text grouped by aisle for WhatsApp', () {
      final items = [
        const GroceryItem(
          id: '1',
          ingredientId: 'cucumber',
          nameAr: 'خيار صغير طازج',
          nameEn: 'Cucumber',
          aisle: 'produce',
          quantity: 1.5,
          unit: 'piece',
          isChecked: false,
        ),
        const GroceryItem(
          id: '2',
          ingredientId: 'toast_brown',
          nameAr: 'توست أسمر',
          nameEn: 'Toast',
          aisle: 'bakery',
          quantity: 4.0,
          unit: 'slices',
          isChecked: false,
        ),
        const GroceryItem(
          id: '3',
          ingredientId: 'labneh',
          nameAr: 'لبنة طازجة',
          nameEn: 'Labneh',
          aisle: 'dairy',
          quantity: 3.0,
          unit: 'tbsp',
          isChecked: true, // checked
        ),
      ];

      final output = GroceryShareFormatter.formatForWhatsApp(
        items,
        headerTitle: '🛒 قائمة التسوق - لانش بوكس بادي',
      );

      // Verify header and structure
      expect(output, contains('🛒 قائمة التسوق - لانش بوكس بادي'));
      expect(output, contains('🥬 الخضار والفواكه:'));
      expect(output, contains('• خيار صغير طازج (1 1/2 حبة)'));
      expect(output, contains('🍞 المخبوزات:'));
      expect(output, contains('• توست أسمر (4 شرائح)'));
      expect(output, contains('✅ تم شراؤها:'));
      expect(output, contains('• لبنة طازجة (3 ملعقة كبيرة)'));
    });
  });

  group('Acceptance Criteria', () {
    test('add two recipes with overlapping ingredients, the list merges them correctly and shares as clean text', () {
      final canonicalMap = {
        'toast_brown': const Ingredient(
          id: 'toast_brown',
          nameAr: 'توست أسمر',
          nameEn: 'Brown Toast',
          category: 'bakery',
          allergens: ['gluten'],
          commonInRegion: true,
        ),
        'labneh': const Ingredient(
          id: 'labneh',
          nameAr: 'لبنة طازجة',
          nameEn: 'Fresh Labneh',
          category: 'dairy',
          allergens: ['milk'],
          commonInRegion: true,
        ),
        'cucumber': const Ingredient(
          id: 'cucumber',
          nameAr: 'خيار صغير طازج',
          nameEn: 'Fresh Mini Cucumber',
          category: 'produce',
          allergens: [],
          commonInRegion: true,
        ),
      };

      // Recipe 1: 2 slices toast, 2 tbsp labneh, 0.5 piece cucumber
      const recipe1 = Recipe(
        id: 'rec_1',
        title: 'ساندوتش لبنة وخيار',
        description: 'وجبة 1',
        servings: 1,
        prepMinutes: 5,
        cookMinutes: 0,
        steps: ['خطوة 1'],
        ingredients: [
          RecipeIngredient(
            ingredientId: 'toast_brown',
            quantity: 2.0,
            unit: 'slices',
          ),
          RecipeIngredient(ingredientId: 'labneh', quantity: 2.0, unit: 'tbsp'),
          RecipeIngredient(
            ingredientId: 'cucumber',
            quantity: 0.5,
            unit: 'piece',
          ),
        ],
      );

      // Recipe 2: 2 slices toast, 1 tbsp labneh, 1 piece cucumber
      const recipe2 = Recipe(
        id: 'rec_2',
        title: 'لفائف اللبنة بالخيار',
        description: 'وجبة 2',
        servings: 1,
        prepMinutes: 5,
        cookMinutes: 0,
        steps: ['خطوة 1'],
        ingredients: [
          RecipeIngredient(
            ingredientId: 'toast_brown',
            quantity: 2.0,
            unit: 'slices',
          ),
          RecipeIngredient(ingredientId: 'labneh', quantity: 1.0, unit: 'tbsp'),
          RecipeIngredient(
            ingredientId: 'cucumber',
            quantity: 1.0,
            unit: 'piece',
          ),
        ],
      );

      // Step 1: Add Recipe 1 (user has no ingredients ticked)
      final listAfterRecipe1 = GroceryMerger.buildItemsFromRecipe(
        recipe: recipe1,
        targetServings: 1,
        tickedIngredientIds: {},
        ingredientMasterMap: canonicalMap,
      );

      // Step 2: Add Recipe 2
      final incomingFromRecipe2 = GroceryMerger.buildItemsFromRecipe(
        recipe: recipe2,
        targetServings: 1,
        tickedIngredientIds: {},
        ingredientMasterMap: canonicalMap,
      );

      final mergedList = GroceryMerger.mergeItems(
        existing: listAfterRecipe1,
        incoming: incomingFromRecipe2,
      );

      // Acceptance: Merged correctly
      expect(mergedList.length, 3);

      final toast = mergedList.firstWhere(
        (it) => it.ingredientId == 'toast_brown',
      );
      final labneh = mergedList.firstWhere((it) => it.ingredientId == 'labneh');
      final cucumber = mergedList.firstWhere(
        (it) => it.ingredientId == 'cucumber',
      );

      expect(toast.quantity, 4.0); // 2 + 2 = 4 slices
      expect(toast.unit, 'slices');
      expect(labneh.quantity, 3.0); // 2 + 1 = 3 tbsp
      expect(labneh.unit, 'tbsp');
      expect(cucumber.quantity, 1.5); // 0.5 + 1.0 = 1.5 piece
      expect(cucumber.unit, 'piece');

      // Acceptance: Shares as clean text
      final shareText = GroceryShareFormatter.formatForWhatsApp(
        mergedList,
        headerTitle: '🛒 قائمة التسوق - لانش بوكس بادي',
      );

      expect(shareText, contains('🛒 قائمة التسوق - لانش بوكس بادي'));
      expect(shareText, contains('🥬 الخضار والفواكه:'));
      expect(shareText, contains('• خيار صغير طازج (1 1/2 حبة)'));
      expect(shareText, contains('🧀 الألبان والأجبان:'));
      expect(shareText, contains('• لبنة طازجة (3 ملعقة كبيرة)'));
      expect(shareText, contains('🍞 المخبوزات:'));
      expect(shareText, contains('• توست أسمر (4 شرائح)'));
    });
  });
}
