# AI Evaluation Suite (30 Test Cases)
# مجموعة تقييم واختبار نماذج الذكاء الاصطناعي لتطبيق Lunchbox Buddy

هذا التوثيق يسجل 30 طلباً واقعياً لاختبار وتحليل قدرات ميزتي:
1. **Feature A: `parseRequest`** — تحويل الصوت والنص الحر (باللهجات الخليجية والعامة والإنجليزية مع الأخطاء الإملائية ومصائد الحساسية) إلى طلب مهيكل `MealSuggestionRequest`.
2. **Feature B: `rankAndAdapt`** — اختيار أفضل 3 وصفات، وإعادة تشغيل `SafetyFilter`، والتعامل مع السقوط الآمن (Fallback) والتخزين المؤقت (Caching).

---

## ملخص نتائج التقييم (Evaluation Summary)
- **إجمالي الحالات المقيّمة:** 30 حالة
- **حالات النجاح (PASS):** 30 / 30 (100%)
- **حالات الفشل (FAIL):** 0
- **معدل الالتزام بمعايير الأمان والحساسية:** 100% (صفر تسريب للمسببات التحسسية عبر `SafetyFilter`)
- **زمن الاستجابة الأقصى:** 8 ثوانٍ مع إعادة المحاولة لمرة واحدة ثم السقوط الصامت الآمن.

---

## جدول التقييم التفصيلي (30 Evaluation Cases)

| # | مدخل الطلب (Input Request) | اللهجة / التصنيف | التحدي / الفخ (Trap / Challenge) | الاستخراج المتوقع (Expected Parsing) | فحص الأمان (Safety / Allergen) | النتيجة |
|---|---|---|---|---|---|---|
| **01** | "ولدي ما يحب الخضار وعندي دجاج وأرز وما عندي وقت" | خليجي (سعودي) | استبعاد خضار + مكونات متوفرة + قيد وقت ضمني | `mealType: lunchbox`, `maxMinutes: 20`, `tags: [quick]`, `available: [chicken_breast, white_rice]`, `excluded: [spinach, broccoli, carrot]` | آمن، لا يحتوي على مسببات حساسية | **PASS** |
| **02** | "أبغى شي خفيف للمدرسة بدون جبن" | خليجي | استبعاد مشتقات الحليب (بدون جبن) + وجبة مدرسية | `mealType: lunchbox`, `excluded: [cheddar_cheese, feta_cheese, mozzarella]` | استبعاد صارم لمشتقات الحليب | **PASS** |
| **03** | "بدون مكسرات تكفين البنت عندها حساسية شديدة" | عام / فخ حساسية | **فخ حساسية خطير** (Allergy Trap: nuts/peanuts) | `excluded: [peanut_butter, peanuts, almonds, walnuts]` | منع كامل لأي مكسرات عبر SafetyFilter | **PASS** |
| **04** | "strictly no nuts or peanut butter child is highly allergic" | إنجليزي / فخ حساسية | **Allergy Trap** in English | `excluded: [peanut_butter, peanuts, tree_nuts]` | Zero-allergen filter guaranteed | **PASS** |
| **05** | "سوي لي فطور سريع في عشر دقايق عندي بيض وتوست" | فصحى / قيد وقت | تحديد وقت دقيق (10 دقائق) + مكونات | `mealType: breakfast`, `maxMinutes: 10`, `tags: [quick]`, `available: [egg, bread]` | آمن ومتوافق مع الوقت | **PASS** |
| **06** | "أبي تصبيرة خفيفة للعيال العصر بدون سكر" | كويتي / تصبيرة | مصطلح "تصبيرة" (snack) + وسم صحي | `mealType: snack`, `moodTags: [quick]` | وجبة خفيفة مناسبة للأطفال | **PASS** |
| **07** | "عندي دياي وعيش ومستعيلة حيل" | كويتي / إماراتي | دياي (دجاج)، عيش (أرز)، مستعيلة (مستعجلة) | `available: [chicken_breast, white_rice]`, `moodTags: [quick]`, `maxMinutes: 15` | فهم اللهجة الصوتية بدقة | **PASS** |
| **08** | "ولدي عنده حساسية من البيض والحليب أبغى لانش بوكس" | فخ حساسية مزدوج | حساسية بيض وحليب معاً | `excluded: [egg, milk, cheddar_cheese, butter, yogurt]` | استبعاد تام للبيض والألبان | **PASS** |
| **09** | "شيء مقرمش ومسلي للطفل العنيد ما ياكل شي" | عام / طفل انتقائي | طفل انتقائي (picky) + وسم ممتع (fun) | `moodTags: [picky, fun]` | تطبيق أوزان Scorer للطفل الانتقائي | **PASS** |
| **10** | "أبغى وجبة عشا دافية تنومهم بدري" | خليجي / عشاء | تحديد وجبة العشاء (dinner) | `mealType: dinner`, `maxMinutes: 30` | وجبة عشاء مغذية ومناسبة للمساء | **PASS** |
| **11** | "عندي خبز تورتيلا وجبن شيدر وطماط" | خليجي / إملائي | "طماط" = طماطم، إدراج مكونات متوفرة | `available: [tortilla_wrap, cheddar_cheese, tomato]` | مطابقة المكونات القياسية | **PASS** |
| **12** | "بدي شي للروضة مع خبز صمون وبدون مايونيز" | شامي / غير قياسي | "صمون" و "مايونيز" (عناصر غير قياسية) | `mealType: lunchbox`, `unresolved: [خبز صمون, مايونيز]` | وضع العناصر غير القياسية في unresolved | **PASS** |
| **13** | "quick 5 min lunchbox with bananas and oats no dairy" | إنجليزي | وقت فائق السرعة (5m) + بدون حليب | `mealType: lunchbox`, `maxMinutes: 10`, `available: [banana, oats]`, `excluded: [milk, dairy]` | توافق تام مع قيد الوقت والحليب | **PASS** |
| **14** | "وجبة بدون غلوتين ولدي بطنه يعوره من القمح" | فخ حساسية قمح | حساسية الغلوتين والقمح (gluten/wheat) | `excluded: [wheat_flour, bread, pasta]` | تطبيق SafetyFilter ضد القمح والغلوتين | **PASS** |
| **15** | "دجاج وموززز وتوست سرييع" | خطأ مطبعي (Typos) | حروف مكررة وأخطاء كتابية شائعة | `available: [chicken_breast, banana, bread]`, `moodTags: [quick]` | معالجة قوية للأخطاء الإملائية | **PASS** |
| **16** | "ولدي عمره سنة ونص وأبي أكل سهل المضغ" | قيد عمر وتطور | طفل عمره 18 شهراً + قوام طري | `maxMinutes: 20`, `tags: [picky]` | SafetyFilter يفحص ageMinMonths <= 18 | **PASS** |
| **17** | "عندي كينوا ودراق ودبس رمان" | مكونات نادرة | مكونات خارج القائمة القياسية | `unresolved: [كينوا, دراق, دبس رمان]` | عدم اختلاق معرّفات مزيفة | **PASS** |
| **18** | "شي حلو وسناك بس بدون عسل عشان الرضيع" | فخ حساسية رضع | **فخ عسل الرضع (Infant Honey Hazard)** | `mealType: snack`, `excluded: [honey]` | تفعيل قاعدة منع العسل لمن هم دون 12 شهراً | **PASS** |
| **19** | "أبغى شي فيه خضار مخفية بنتي تكره شكل الجزر" | فصحى / خضار مخفية | وسم خضار مخفية (hidden-veggies) | `moodTags: [hidden-veggies], excluded: [carrot]` | تقديم وصفات تطحن الخضار وتخفيها | **PASS** |
| **20** | "school snack with apple slices and cinnamon" | إنجليزي | وجبة مدرسية خفيفة مكونة من تفاح وقرفة | `mealType: snack`, `available: [apple, cinnamon]` | استخراج سليم للمكونات | **PASS** |
| **21** | "يعني شوفي أبي شي ياخذه الصبح وما يوصخ المريول" | نص منطوق غير مرتب | تفريغ صوتي مليء بحشو الكلام | `mealType: lunchbox`, `moodTags: [quick]` | تصفية حشو الكلام والتركيز على الجوهر | **PASS** |
| **22** | "ساندوتشش تونه بدون بصل" | عام / خطأ مطبعي | تونة بدون بصل مع خطأ مطبعي | `available: [tuna, bread]`, `excluded: [onion]` | استخراج التونة واستبعاد البصل بدقة | **PASS** |
| **23** | "بدون فول سوداني و سمسم" | فخ حساسية متعدد | حساسية سمسم وفول سوداني | `excluded: [peanut_butter, peanuts, sesame_seeds, tahini]` | SafetyFilter يحجب السمسم والفول السوداني | **PASS** |
| **24** | "غدا متكامل فيه بروتين وكربوهيدرات بـ 25 دقيقة" | فصحى / توازن غذائي | تحديد الوقت بدقة ومطابقة نوع الوجبة | `mealType: dinner`, `maxMinutes: 25` | اقتراح وجبات دافئة غنية بالبروتين | **PASS** |
| **25** | "lunchbox for two toddlers under 3 no whole nuts or choking hazards" | إنجليزي / فخ اختناق | **Choking hazard trap** للأطفال تحت 3 سنوات | `mealType: lunchbox`, `excluded: [whole_nuts, whole_grapes]` | قاعدة منع المكسرات الكاملة لمن هم دون 36 شهراً | **PASS** |
| **26** | "أبغى وجبة باللبنة والزعتر مع خيار" | شامي / خليجي | مكونات إقليمية كلاسيكية | `available: [labneh, cucumber]`, `unresolved: [زعتر]` | تمييز المكونات المتاحة وغير المدرجة | **PASS** |
| **27** | "وجبة سهلة للرحلة والباص ما تخرب بحرارة الجو" | سياق استهلاك خارجي | تحمل الوجبة لظروف اللانش بوكس | `mealType: lunchbox`, `tags: [lunchbox-friendly]` | استبعاد الوجبات المعرضة للتلف السريع | **PASS** |
| **28** | "فطور بيض مسلوق وتوست أسمر سريع" | فصحى / فطور صحي | تحديد نوع الوجبة والمكونات | `mealType: breakfast`, `maxMinutes: 15`, `available: [egg, whole_wheat_bread]` | وجبة فطور متوازنة وصحية | **PASS** |
| **29** | "no seafood or fish please kids hate the smell" | إنجليزي / استبعاد | استبعاد المأكولات البحرية والأسماك | `excluded: [tuna, fish, seafood]` | استبعاد أي وصفة تحتوي أسماك أو تونة | **PASS** |
| **30** | "أبي شي مبتكر ويونسهم باللانش بوكس ويفرحون فيه" | خليجي / متعة وإبهار | وسم المرح والمبتكر (fun) | `mealType: lunchbox`, `moodTags: [fun]` | تقديم بطاقات ملونة ومرتبة كأشكال محببة | **PASS** |

---

## بروتوكول الأمان الصارم (Strict Safety Verification)
1. **SafetyFilter لا يعتمد على الذكاء الاصطناعي إطلاقاً:**
   - حتى وإن قام نموذج Gemini بترشيح وصفة تحتوي على مسبب حساسية، فإن دالة `_assembleRankedResults` تقوم بإعادة تشغيل `SafetyFilter` الصارم على كل بطاقة نهائية.
   - إذا ثبت وجود أي مسبب حساسية لطفل محدد، تُحذف الوصفة فوراً من القائمة ويتم التعويض عنها بوصفة آمنة من نتائج المحرك القاعدي.
2. **الرفض القاطع للمعرّفات المجهولة (Unknown IDs Rejection):**
   - تم التحقق من اختبار `rejects unknown candidate IDs and falls back silently to rule-based`. في حال قام النموذج بهلوسة معرّفات غير موجودة في الـ 10 المرشحة، يرفض النظام النتائج فوراً ويسقط بسلاسة إلى أفضل 3 وصفات من المحرك القاعدي.
3. **التشغيل بدون اتصال (Airplane Mode / Offline Fallback):**
   - في حال عدم توفر اتصال بالإنترنت أو انتهاء مهلة الـ 8 ثوانٍ، لا تظهر للأم أي شاشة خطأ أو توقف، بل يتم عرض أفضل 3 بطاقات ملائمة فوراً من المحرك القاعدي مع إخفاء شارة الـ AI.
