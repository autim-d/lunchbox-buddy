import 'package:firebase_ai/firebase_ai.dart';
import 'package:lunchbox_buddy/core/data/models/ingredient.dart';
import 'package:lunchbox_buddy/core/data/models/kid_profile.dart';
import 'package:lunchbox_buddy/core/data/models/meal_feedback.dart';
import 'package:lunchbox_buddy/core/data/models/recipe.dart';

/// Centralized prompts and JSON Schemas for Firebase AI Logic
class AiPrompts {
  AiPrompts._();

  // ===========================================================================
  // Feature A: parseRequest Schema & Prompt
  // ===========================================================================

  static final Schema parseRequestSchema = Schema.object(
    properties: {
      'mealType': Schema.string(
        description: 'One of: breakfast, lunchbox, dinner, snack',
      ),
      'maxMinutes': Schema.integer(
        description: 'Maximum preparation time in minutes if specified',
      ),
      'moodTags': Schema.array(
        items: Schema.string(),
        description: 'Matching tags from: quick, picky, fun, hidden-veggies',
      ),
      'availableIngredientIds': Schema.array(
        items: Schema.string(),
        description:
            'List of matching canonical ingredient IDs available on hand',
      ),
      'excludedIngredientIds': Schema.array(
        items: Schema.string(),
        description:
            'List of matching canonical ingredient IDs user wants to avoid or exclude',
      ),
      'unresolvedIngredients': Schema.array(
        items: Schema.string(),
        description:
            'Any food items or ingredients mentioned that could not be matched to canonical IDs',
      ),
      'confidenceReason': Schema.string(
        description: 'Brief explanation in Arabic of how request was understood',
      ),
    },
  );

  static const String parseRequestSystemInstruction = '''
أنتِ "لانش بوكس بادي"، مساعدة ذكية متخصصة في مساعدة الأمهات على تنظيم وجبات الأطفال.
مهمتك: تحليل طلب الأم الصوتي أو المكتوب بمختلف اللهجات العربية (خاصة الخليجية كـ: "أبغى"، "ولدي"، "ما يحب"، "تصبيرة"، "سريع") وكذلك باللغة العربية الفصحى والإنجليزية.
القواعد الصارمة:
1. استخرجي نوع الوجبة (mealType) من الخيارات: "breakfast" (فطور)، "lunchbox" (لانش بوكس/مدرسة)، "dinner" (عشاء)، "snack" (تصبيرة/سناك).
2. استخرجي الوقت بالدقائق (maxMinutes) إن ذُكر صراحة أو ضمناً (مثل: "ما عندي وقت" أو "سريعة" -> 15 أو 20 دقيقة).
3. استخرجي وسوم المزاج (moodTags) من بين: ["quick", "picky", "fun", "hidden-veggies"].
4. قارني المكونات المتوفرة حصراً بقائمة معرّفات المكونات القياسية المرفقة وضعي معرّفاتها في (availableIngredientIds).
5. إذا طلبت الأم استبعاد مكون أو ذكرت أن طفلها لا يحبه أو يتحسس منه (مثل: "بدون جبن" أو "ولدي ما يحب الخضار")، ضعي معرّفات تلك المكونات في (excludedIngredientIds).
6. أي صنف طعام أو مكون ذُكر ولم تجدي له معرّفاً قياسياً مطابقاً في القائمة، ضعيه كما هو في مصفوفة (unresolvedIngredients). لا تختلقي معرّفات غير موجودة.
7. أرجعي النتيجة بصيغة JSON تطابق المخطط بدقة تامة.
''';

  static String buildParseRequestPrompt({
    required String rawUserInput,
    required List<Ingredient> canonicalIngredients,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('طلب الأم:');
    buffer.writeln('"$rawUserInput"');
    buffer.writeln();
    buffer.writeln('قائمة المكونات القياسية المعتمدة في التطبيق (معرّف: الاسم العربي):');
    for (final ing in canonicalIngredients) {
      buffer.writeln('- ${ing.id}: ${ing.nameAr}');
    }
    return buffer.toString();
  }

  // ===========================================================================
  // Feature B: rankAndAdapt Schema & Prompt
  // ===========================================================================

  static final Schema rankingSchema = Schema.object(
    properties: {
      'items': Schema.array(
        items: Schema.object(
          properties: {
            'recipeId': Schema.string(
              description:
                  'The exact recipe ID selected from the candidate list',
            ),
            'reasonAr': Schema.string(
              description:
                  'Warm, friendly one-sentence Arabic explanation for why this meal fits',
            ),
            'substitutionTip': Schema.string(
              description:
                  'Optional practical kitchen substitution tip in Arabic',
            ),
          },
        ),
        description: 'Top 3 selected and adapted recipes',
      ),
    },
  );

  static const String rankingSystemInstruction = '''
أنتِ "لانش بوكس بادي"، طاهية ذكية ومستشارة وجبات منزلية للأمهات.
مهمتك: اختيار أفضل 3 وصفات للأطفال من بين قائمة الـ 10 وصفات المرشحة المعطاة فقط.

القواعد الصارمة:
1. اختاري حصراً من قائمة معرّفات الوصفات (recipeId) المعطاة لك. يُمنع منعاً باتاً اختراع أي معرّف جديد أو اختيار وصفة خارج القائمة.
2. لكل وصفة من الثلاث، اكتبي سبباً دافئاً وموجزاً في جملة واحدة فقط باللغة العربية الفصيحة الودودة (reasonAr) تشرح للأم لماذا هذه الوجبة مناسبة لأطفالها وسياقها الحالي.
3. يمكنكِ تقديم نصيحة استبدال اختيارية ذكية وعملية (substitutionTip) إذا كان هناك مكون يمكن استبداله بما يتناسب مع رغبة الأطفال، مثل "يمكنكِ استبدال الزبادي باللبنة إذا فضل طفلكِ ذلك".
4. راعي أعمار الأطفال وتفضيلاتهم وتجاربهم السابقة دون ذكر أسماء شخصية.
5. أرجعي النتيجة بصيغة JSON تطابق المخطط المحدد بدقة.
''';

  static String buildRankingPrompt({
    required List<Recipe> candidates,
    required List<KidProfile> selectedKids,
    required List<MealFeedback> recentFeedbacks,
    String? motherNote,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('=== ملخص ملفات الأطفال (للمحافظة على الخصوصية لا تُذكر أسماء) ===');
    for (int i = 0; i < selectedKids.length; i++) {
      final kid = selectedKids[i];
      final ageYears = DateTime.now().difference(kid.birthDate).inDays ~/ 365;
      final ageMonths = (DateTime.now().difference(kid.birthDate).inDays % 365) ~/ 30;
      buffer.writeln('الطفل رقم ${i + 1}:');
      buffer.writeln('- العمر: $ageYears سنة و $ageMonths شهر');
      buffer.writeln('- الحساسية: ${kid.allergies.isEmpty ? "لا يوجد" : kid.allergies.join(", ")}');
      buffer.writeln('- الأطعمة غير المفضلة: ${kid.dislikes.isEmpty ? "لا يوجد" : kid.dislikes.join(", ")}');
      buffer.writeln('- الأطعمة المفضلة: ${kid.likes.isEmpty ? "لا يوجد" : kid.likes.join(", ")}');
      buffer.writeln('- مستوى الصعوبة في الأكل (0-3): ${kid.pickyLevel}');
    }
    buffer.writeln();

    if (recentFeedbacks.isNotEmpty) {
      buffer.writeln('=== سجل التغذية الراجعة الأخير للأطفال ===');
      for (final fb in recentFeedbacks.take(5)) {
        buffer.writeln('- الوصفة: ${fb.recipeId} -> التفاعل: ${fb.reaction}${fb.reasonTag != null ? " (السبب: ${fb.reasonTag})" : ""}');
      }
      buffer.writeln();
    }

    if (motherNote != null && motherNote.trim().isNotEmpty) {
      buffer.writeln('=== ملاحظة الأم الخاصة لهذا اليوم ===');
      buffer.writeln('"$motherNote"');
      buffer.writeln();
    }

    buffer.writeln('=== قائمة الوصفات المرشحة (اختاري أفضل 3 فقط من معرّفاتها) ===');
    for (final recipe in candidates) {
      final totalMin = recipe.prepMinutes + recipe.cookMinutes;
      final ingIds = recipe.ingredients.map((e) => e.ingredientId).join(", ");
      buffer.writeln('- معرّف: "${recipe.id}" | العنوان: ${recipe.title} | الوقت الإجمالي: $totalMin دقيقة | الوسوم: ${recipe.tags.join(", ")} | المكونات: $ingIds');
    }

    return buffer.toString();
  }
}
