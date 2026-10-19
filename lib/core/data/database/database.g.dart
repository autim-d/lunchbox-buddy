// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $IngredientsTableTable extends IngredientsTable
    with TableInfo<$IngredientsTableTable, IngredientEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _allergensMeta = const VerificationMeta(
    'allergens',
  );
  @override
  late final GeneratedColumn<String> allergens = GeneratedColumn<String>(
    'allergens',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _commonInRegionMeta = const VerificationMeta(
    'commonInRegion',
  );
  @override
  late final GeneratedColumn<bool> commonInRegion = GeneratedColumn<bool>(
    'common_in_region',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("common_in_region" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nameAr,
    nameEn,
    category,
    allergens,
    commonInRegion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredients_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<IngredientEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('allergens')) {
      context.handle(
        _allergensMeta,
        allergens.isAcceptableOrUnknown(data['allergens']!, _allergensMeta),
      );
    } else if (isInserting) {
      context.missing(_allergensMeta);
    }
    if (data.containsKey('common_in_region')) {
      context.handle(
        _commonInRegionMeta,
        commonInRegion.isAcceptableOrUnknown(
          data['common_in_region']!,
          _commonInRegionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IngredientEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IngredientEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      allergens: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allergens'],
      )!,
      commonInRegion: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}common_in_region'],
      )!,
    );
  }

  @override
  $IngredientsTableTable createAlias(String alias) {
    return $IngredientsTableTable(attachedDatabase, alias);
  }
}

class IngredientEntry extends DataClass implements Insertable<IngredientEntry> {
  final String id;
  final String nameAr;
  final String nameEn;
  final String category;
  final String allergens;
  final bool commonInRegion;
  const IngredientEntry({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.category,
    required this.allergens,
    required this.commonInRegion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name_ar'] = Variable<String>(nameAr);
    map['name_en'] = Variable<String>(nameEn);
    map['category'] = Variable<String>(category);
    map['allergens'] = Variable<String>(allergens);
    map['common_in_region'] = Variable<bool>(commonInRegion);
    return map;
  }

  IngredientsTableCompanion toCompanion(bool nullToAbsent) {
    return IngredientsTableCompanion(
      id: Value(id),
      nameAr: Value(nameAr),
      nameEn: Value(nameEn),
      category: Value(category),
      allergens: Value(allergens),
      commonInRegion: Value(commonInRegion),
    );
  }

  factory IngredientEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IngredientEntry(
      id: serializer.fromJson<String>(json['id']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      category: serializer.fromJson<String>(json['category']),
      allergens: serializer.fromJson<String>(json['allergens']),
      commonInRegion: serializer.fromJson<bool>(json['commonInRegion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nameAr': serializer.toJson<String>(nameAr),
      'nameEn': serializer.toJson<String>(nameEn),
      'category': serializer.toJson<String>(category),
      'allergens': serializer.toJson<String>(allergens),
      'commonInRegion': serializer.toJson<bool>(commonInRegion),
    };
  }

  IngredientEntry copyWith({
    String? id,
    String? nameAr,
    String? nameEn,
    String? category,
    String? allergens,
    bool? commonInRegion,
  }) => IngredientEntry(
    id: id ?? this.id,
    nameAr: nameAr ?? this.nameAr,
    nameEn: nameEn ?? this.nameEn,
    category: category ?? this.category,
    allergens: allergens ?? this.allergens,
    commonInRegion: commonInRegion ?? this.commonInRegion,
  );
  IngredientEntry copyWithCompanion(IngredientsTableCompanion data) {
    return IngredientEntry(
      id: data.id.present ? data.id.value : this.id,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      category: data.category.present ? data.category.value : this.category,
      allergens: data.allergens.present ? data.allergens.value : this.allergens,
      commonInRegion: data.commonInRegion.present
          ? data.commonInRegion.value
          : this.commonInRegion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IngredientEntry(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn, ')
          ..write('category: $category, ')
          ..write('allergens: $allergens, ')
          ..write('commonInRegion: $commonInRegion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nameAr, nameEn, category, allergens, commonInRegion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IngredientEntry &&
          other.id == this.id &&
          other.nameAr == this.nameAr &&
          other.nameEn == this.nameEn &&
          other.category == this.category &&
          other.allergens == this.allergens &&
          other.commonInRegion == this.commonInRegion);
}

class IngredientsTableCompanion extends UpdateCompanion<IngredientEntry> {
  final Value<String> id;
  final Value<String> nameAr;
  final Value<String> nameEn;
  final Value<String> category;
  final Value<String> allergens;
  final Value<bool> commonInRegion;
  final Value<int> rowid;
  const IngredientsTableCompanion({
    this.id = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.category = const Value.absent(),
    this.allergens = const Value.absent(),
    this.commonInRegion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IngredientsTableCompanion.insert({
    required String id,
    required String nameAr,
    required String nameEn,
    required String category,
    required String allergens,
    this.commonInRegion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nameAr = Value(nameAr),
       nameEn = Value(nameEn),
       category = Value(category),
       allergens = Value(allergens);
  static Insertable<IngredientEntry> custom({
    Expression<String>? id,
    Expression<String>? nameAr,
    Expression<String>? nameEn,
    Expression<String>? category,
    Expression<String>? allergens,
    Expression<bool>? commonInRegion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
      if (category != null) 'category': category,
      if (allergens != null) 'allergens': allergens,
      if (commonInRegion != null) 'common_in_region': commonInRegion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IngredientsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? nameAr,
    Value<String>? nameEn,
    Value<String>? category,
    Value<String>? allergens,
    Value<bool>? commonInRegion,
    Value<int>? rowid,
  }) {
    return IngredientsTableCompanion(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      category: category ?? this.category,
      allergens: allergens ?? this.allergens,
      commonInRegion: commonInRegion ?? this.commonInRegion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (allergens.present) {
      map['allergens'] = Variable<String>(allergens.value);
    }
    if (commonInRegion.present) {
      map['common_in_region'] = Variable<bool>(commonInRegion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientsTableCompanion(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn, ')
          ..write('category: $category, ')
          ..write('allergens: $allergens, ')
          ..write('commonInRegion: $commonInRegion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipesTableTable extends RecipesTable
    with TableInfo<$RecipesTableTable, RecipeEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<String> steps = GeneratedColumn<String>(
    'steps',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prepMinutesMeta = const VerificationMeta(
    'prepMinutes',
  );
  @override
  late final GeneratedColumn<int> prepMinutes = GeneratedColumn<int>(
    'prep_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cookMinutesMeta = const VerificationMeta(
    'cookMinutes',
  );
  @override
  late final GeneratedColumn<int> cookMinutes = GeneratedColumn<int>(
    'cook_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _servingsMeta = const VerificationMeta(
    'servings',
  );
  @override
  late final GeneratedColumn<int> servings = GeneratedColumn<int>(
    'servings',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('curated'),
  );
  static const VerificationMeta _ageMinMonthsMeta = const VerificationMeta(
    'ageMinMonths',
  );
  @override
  late final GeneratedColumn<int> ageMinMonths = GeneratedColumn<int>(
    'age_min_months',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(12),
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _safetyVersionMeta = const VerificationMeta(
    'safetyVersion',
  );
  @override
  late final GeneratedColumn<int> safetyVersion = GeneratedColumn<int>(
    'safety_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    steps,
    prepMinutes,
    cookMinutes,
    servings,
    tags,
    source,
    ageMinMonths,
    imagePath,
    safetyVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('steps')) {
      context.handle(
        _stepsMeta,
        steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta),
      );
    } else if (isInserting) {
      context.missing(_stepsMeta);
    }
    if (data.containsKey('prep_minutes')) {
      context.handle(
        _prepMinutesMeta,
        prepMinutes.isAcceptableOrUnknown(
          data['prep_minutes']!,
          _prepMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_prepMinutesMeta);
    }
    if (data.containsKey('cook_minutes')) {
      context.handle(
        _cookMinutesMeta,
        cookMinutes.isAcceptableOrUnknown(
          data['cook_minutes']!,
          _cookMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cookMinutesMeta);
    }
    if (data.containsKey('servings')) {
      context.handle(
        _servingsMeta,
        servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    } else if (isInserting) {
      context.missing(_tagsMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('age_min_months')) {
      context.handle(
        _ageMinMonthsMeta,
        ageMinMonths.isAcceptableOrUnknown(
          data['age_min_months']!,
          _ageMinMonthsMeta,
        ),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('safety_version')) {
      context.handle(
        _safetyVersionMeta,
        safetyVersion.isAcceptableOrUnknown(
          data['safety_version']!,
          _safetyVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      steps: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}steps'],
      )!,
      prepMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prep_minutes'],
      )!,
      cookMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cook_minutes'],
      )!,
      servings: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}servings'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      ageMinMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age_min_months'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      safetyVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}safety_version'],
      )!,
    );
  }

  @override
  $RecipesTableTable createAlias(String alias) {
    return $RecipesTableTable(attachedDatabase, alias);
  }
}

class RecipeEntry extends DataClass implements Insertable<RecipeEntry> {
  final String id;
  final String title;
  final String description;
  final String steps;
  final int prepMinutes;
  final int cookMinutes;
  final int servings;
  final String tags;
  final String source;
  final int ageMinMonths;
  final String? imagePath;
  final int safetyVersion;
  const RecipeEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.steps,
    required this.prepMinutes,
    required this.cookMinutes,
    required this.servings,
    required this.tags,
    required this.source,
    required this.ageMinMonths,
    this.imagePath,
    required this.safetyVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['steps'] = Variable<String>(steps);
    map['prep_minutes'] = Variable<int>(prepMinutes);
    map['cook_minutes'] = Variable<int>(cookMinutes);
    map['servings'] = Variable<int>(servings);
    map['tags'] = Variable<String>(tags);
    map['source'] = Variable<String>(source);
    map['age_min_months'] = Variable<int>(ageMinMonths);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['safety_version'] = Variable<int>(safetyVersion);
    return map;
  }

  RecipesTableCompanion toCompanion(bool nullToAbsent) {
    return RecipesTableCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      steps: Value(steps),
      prepMinutes: Value(prepMinutes),
      cookMinutes: Value(cookMinutes),
      servings: Value(servings),
      tags: Value(tags),
      source: Value(source),
      ageMinMonths: Value(ageMinMonths),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      safetyVersion: Value(safetyVersion),
    );
  }

  factory RecipeEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeEntry(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      steps: serializer.fromJson<String>(json['steps']),
      prepMinutes: serializer.fromJson<int>(json['prepMinutes']),
      cookMinutes: serializer.fromJson<int>(json['cookMinutes']),
      servings: serializer.fromJson<int>(json['servings']),
      tags: serializer.fromJson<String>(json['tags']),
      source: serializer.fromJson<String>(json['source']),
      ageMinMonths: serializer.fromJson<int>(json['ageMinMonths']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      safetyVersion: serializer.fromJson<int>(json['safetyVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'steps': serializer.toJson<String>(steps),
      'prepMinutes': serializer.toJson<int>(prepMinutes),
      'cookMinutes': serializer.toJson<int>(cookMinutes),
      'servings': serializer.toJson<int>(servings),
      'tags': serializer.toJson<String>(tags),
      'source': serializer.toJson<String>(source),
      'ageMinMonths': serializer.toJson<int>(ageMinMonths),
      'imagePath': serializer.toJson<String?>(imagePath),
      'safetyVersion': serializer.toJson<int>(safetyVersion),
    };
  }

  RecipeEntry copyWith({
    String? id,
    String? title,
    String? description,
    String? steps,
    int? prepMinutes,
    int? cookMinutes,
    int? servings,
    String? tags,
    String? source,
    int? ageMinMonths,
    Value<String?> imagePath = const Value.absent(),
    int? safetyVersion,
  }) => RecipeEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    steps: steps ?? this.steps,
    prepMinutes: prepMinutes ?? this.prepMinutes,
    cookMinutes: cookMinutes ?? this.cookMinutes,
    servings: servings ?? this.servings,
    tags: tags ?? this.tags,
    source: source ?? this.source,
    ageMinMonths: ageMinMonths ?? this.ageMinMonths,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    safetyVersion: safetyVersion ?? this.safetyVersion,
  );
  RecipeEntry copyWithCompanion(RecipesTableCompanion data) {
    return RecipeEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      steps: data.steps.present ? data.steps.value : this.steps,
      prepMinutes: data.prepMinutes.present
          ? data.prepMinutes.value
          : this.prepMinutes,
      cookMinutes: data.cookMinutes.present
          ? data.cookMinutes.value
          : this.cookMinutes,
      servings: data.servings.present ? data.servings.value : this.servings,
      tags: data.tags.present ? data.tags.value : this.tags,
      source: data.source.present ? data.source.value : this.source,
      ageMinMonths: data.ageMinMonths.present
          ? data.ageMinMonths.value
          : this.ageMinMonths,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      safetyVersion: data.safetyVersion.present
          ? data.safetyVersion.value
          : this.safetyVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('steps: $steps, ')
          ..write('prepMinutes: $prepMinutes, ')
          ..write('cookMinutes: $cookMinutes, ')
          ..write('servings: $servings, ')
          ..write('tags: $tags, ')
          ..write('source: $source, ')
          ..write('ageMinMonths: $ageMinMonths, ')
          ..write('imagePath: $imagePath, ')
          ..write('safetyVersion: $safetyVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    steps,
    prepMinutes,
    cookMinutes,
    servings,
    tags,
    source,
    ageMinMonths,
    imagePath,
    safetyVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.steps == this.steps &&
          other.prepMinutes == this.prepMinutes &&
          other.cookMinutes == this.cookMinutes &&
          other.servings == this.servings &&
          other.tags == this.tags &&
          other.source == this.source &&
          other.ageMinMonths == this.ageMinMonths &&
          other.imagePath == this.imagePath &&
          other.safetyVersion == this.safetyVersion);
}

class RecipesTableCompanion extends UpdateCompanion<RecipeEntry> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> steps;
  final Value<int> prepMinutes;
  final Value<int> cookMinutes;
  final Value<int> servings;
  final Value<String> tags;
  final Value<String> source;
  final Value<int> ageMinMonths;
  final Value<String?> imagePath;
  final Value<int> safetyVersion;
  final Value<int> rowid;
  const RecipesTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.steps = const Value.absent(),
    this.prepMinutes = const Value.absent(),
    this.cookMinutes = const Value.absent(),
    this.servings = const Value.absent(),
    this.tags = const Value.absent(),
    this.source = const Value.absent(),
    this.ageMinMonths = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.safetyVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipesTableCompanion.insert({
    required String id,
    required String title,
    required String description,
    required String steps,
    required int prepMinutes,
    required int cookMinutes,
    this.servings = const Value.absent(),
    required String tags,
    this.source = const Value.absent(),
    this.ageMinMonths = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.safetyVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       description = Value(description),
       steps = Value(steps),
       prepMinutes = Value(prepMinutes),
       cookMinutes = Value(cookMinutes),
       tags = Value(tags);
  static Insertable<RecipeEntry> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? steps,
    Expression<int>? prepMinutes,
    Expression<int>? cookMinutes,
    Expression<int>? servings,
    Expression<String>? tags,
    Expression<String>? source,
    Expression<int>? ageMinMonths,
    Expression<String>? imagePath,
    Expression<int>? safetyVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (steps != null) 'steps': steps,
      if (prepMinutes != null) 'prep_minutes': prepMinutes,
      if (cookMinutes != null) 'cook_minutes': cookMinutes,
      if (servings != null) 'servings': servings,
      if (tags != null) 'tags': tags,
      if (source != null) 'source': source,
      if (ageMinMonths != null) 'age_min_months': ageMinMonths,
      if (imagePath != null) 'image_path': imagePath,
      if (safetyVersion != null) 'safety_version': safetyVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? description,
    Value<String>? steps,
    Value<int>? prepMinutes,
    Value<int>? cookMinutes,
    Value<int>? servings,
    Value<String>? tags,
    Value<String>? source,
    Value<int>? ageMinMonths,
    Value<String?>? imagePath,
    Value<int>? safetyVersion,
    Value<int>? rowid,
  }) {
    return RecipesTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      steps: steps ?? this.steps,
      prepMinutes: prepMinutes ?? this.prepMinutes,
      cookMinutes: cookMinutes ?? this.cookMinutes,
      servings: servings ?? this.servings,
      tags: tags ?? this.tags,
      source: source ?? this.source,
      ageMinMonths: ageMinMonths ?? this.ageMinMonths,
      imagePath: imagePath ?? this.imagePath,
      safetyVersion: safetyVersion ?? this.safetyVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (steps.present) {
      map['steps'] = Variable<String>(steps.value);
    }
    if (prepMinutes.present) {
      map['prep_minutes'] = Variable<int>(prepMinutes.value);
    }
    if (cookMinutes.present) {
      map['cook_minutes'] = Variable<int>(cookMinutes.value);
    }
    if (servings.present) {
      map['servings'] = Variable<int>(servings.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (ageMinMonths.present) {
      map['age_min_months'] = Variable<int>(ageMinMonths.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (safetyVersion.present) {
      map['safety_version'] = Variable<int>(safetyVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('steps: $steps, ')
          ..write('prepMinutes: $prepMinutes, ')
          ..write('cookMinutes: $cookMinutes, ')
          ..write('servings: $servings, ')
          ..write('tags: $tags, ')
          ..write('source: $source, ')
          ..write('ageMinMonths: $ageMinMonths, ')
          ..write('imagePath: $imagePath, ')
          ..write('safetyVersion: $safetyVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipeIngredientsTableTable extends RecipeIngredientsTable
    with TableInfo<$RecipeIngredientsTableTable, RecipeIngredientEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeIngredientsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<String> ingredientId = GeneratedColumn<String>(
    'ingredient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayTextMeta = const VerificationMeta(
    'displayText',
  );
  @override
  late final GeneratedColumn<String> displayText = GeneratedColumn<String>(
    'display_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _optionalMeta = const VerificationMeta(
    'optional',
  );
  @override
  late final GeneratedColumn<bool> optional = GeneratedColumn<bool>(
    'optional',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("optional" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recipeId,
    ingredientId,
    quantity,
    unit,
    displayText,
    optional,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_ingredients_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeIngredientEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('display_text')) {
      context.handle(
        _displayTextMeta,
        displayText.isAcceptableOrUnknown(
          data['display_text']!,
          _displayTextMeta,
        ),
      );
    }
    if (data.containsKey('optional')) {
      context.handle(
        _optionalMeta,
        optional.isAcceptableOrUnknown(data['optional']!, _optionalMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeIngredientEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeIngredientEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      )!,
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredient_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      displayText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_text'],
      ),
      optional: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}optional'],
      )!,
    );
  }

  @override
  $RecipeIngredientsTableTable createAlias(String alias) {
    return $RecipeIngredientsTableTable(attachedDatabase, alias);
  }
}

class RecipeIngredientEntry extends DataClass
    implements Insertable<RecipeIngredientEntry> {
  final int id;
  final String recipeId;
  final String ingredientId;
  final double? quantity;
  final String? unit;
  final String? displayText;
  final bool optional;
  const RecipeIngredientEntry({
    required this.id,
    required this.recipeId,
    required this.ingredientId,
    this.quantity,
    this.unit,
    this.displayText,
    required this.optional,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recipe_id'] = Variable<String>(recipeId);
    map['ingredient_id'] = Variable<String>(ingredientId);
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<double>(quantity);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || displayText != null) {
      map['display_text'] = Variable<String>(displayText);
    }
    map['optional'] = Variable<bool>(optional);
    return map;
  }

  RecipeIngredientsTableCompanion toCompanion(bool nullToAbsent) {
    return RecipeIngredientsTableCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      ingredientId: Value(ingredientId),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      displayText: displayText == null && nullToAbsent
          ? const Value.absent()
          : Value(displayText),
      optional: Value(optional),
    );
  }

  factory RecipeIngredientEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeIngredientEntry(
      id: serializer.fromJson<int>(json['id']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      ingredientId: serializer.fromJson<String>(json['ingredientId']),
      quantity: serializer.fromJson<double?>(json['quantity']),
      unit: serializer.fromJson<String?>(json['unit']),
      displayText: serializer.fromJson<String?>(json['displayText']),
      optional: serializer.fromJson<bool>(json['optional']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recipeId': serializer.toJson<String>(recipeId),
      'ingredientId': serializer.toJson<String>(ingredientId),
      'quantity': serializer.toJson<double?>(quantity),
      'unit': serializer.toJson<String?>(unit),
      'displayText': serializer.toJson<String?>(displayText),
      'optional': serializer.toJson<bool>(optional),
    };
  }

  RecipeIngredientEntry copyWith({
    int? id,
    String? recipeId,
    String? ingredientId,
    Value<double?> quantity = const Value.absent(),
    Value<String?> unit = const Value.absent(),
    Value<String?> displayText = const Value.absent(),
    bool? optional,
  }) => RecipeIngredientEntry(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    ingredientId: ingredientId ?? this.ingredientId,
    quantity: quantity.present ? quantity.value : this.quantity,
    unit: unit.present ? unit.value : this.unit,
    displayText: displayText.present ? displayText.value : this.displayText,
    optional: optional ?? this.optional,
  );
  RecipeIngredientEntry copyWithCompanion(
    RecipeIngredientsTableCompanion data,
  ) {
    return RecipeIngredientEntry(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      displayText: data.displayText.present
          ? data.displayText.value
          : this.displayText,
      optional: data.optional.present ? data.optional.value : this.optional,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeIngredientEntry(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('displayText: $displayText, ')
          ..write('optional: $optional')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    recipeId,
    ingredientId,
    quantity,
    unit,
    displayText,
    optional,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeIngredientEntry &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.ingredientId == this.ingredientId &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.displayText == this.displayText &&
          other.optional == this.optional);
}

class RecipeIngredientsTableCompanion
    extends UpdateCompanion<RecipeIngredientEntry> {
  final Value<int> id;
  final Value<String> recipeId;
  final Value<String> ingredientId;
  final Value<double?> quantity;
  final Value<String?> unit;
  final Value<String?> displayText;
  final Value<bool> optional;
  const RecipeIngredientsTableCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.displayText = const Value.absent(),
    this.optional = const Value.absent(),
  });
  RecipeIngredientsTableCompanion.insert({
    this.id = const Value.absent(),
    required String recipeId,
    required String ingredientId,
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.displayText = const Value.absent(),
    this.optional = const Value.absent(),
  }) : recipeId = Value(recipeId),
       ingredientId = Value(ingredientId);
  static Insertable<RecipeIngredientEntry> custom({
    Expression<int>? id,
    Expression<String>? recipeId,
    Expression<String>? ingredientId,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<String>? displayText,
    Expression<bool>? optional,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (displayText != null) 'display_text': displayText,
      if (optional != null) 'optional': optional,
    });
  }

  RecipeIngredientsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? recipeId,
    Value<String>? ingredientId,
    Value<double?>? quantity,
    Value<String?>? unit,
    Value<String?>? displayText,
    Value<bool>? optional,
  }) {
    return RecipeIngredientsTableCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      ingredientId: ingredientId ?? this.ingredientId,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      displayText: displayText ?? this.displayText,
      optional: optional ?? this.optional,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<String>(ingredientId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (displayText.present) {
      map['display_text'] = Variable<String>(displayText.value);
    }
    if (optional.present) {
      map['optional'] = Variable<bool>(optional.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeIngredientsTableCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('displayText: $displayText, ')
          ..write('optional: $optional')
          ..write(')'))
        .toString();
  }
}

class $KidProfilesTableTable extends KidProfilesTable
    with TableInfo<$KidProfilesTableTable, KidProfileEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KidProfilesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _allergiesMeta = const VerificationMeta(
    'allergies',
  );
  @override
  late final GeneratedColumn<String> allergies = GeneratedColumn<String>(
    'allergies',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dislikesMeta = const VerificationMeta(
    'dislikes',
  );
  @override
  late final GeneratedColumn<String> dislikes = GeneratedColumn<String>(
    'dislikes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _likesMeta = const VerificationMeta('likes');
  @override
  late final GeneratedColumn<String> likes = GeneratedColumn<String>(
    'likes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pickyLevelMeta = const VerificationMeta(
    'pickyLevel',
  );
  @override
  late final GeneratedColumn<int> pickyLevel = GeneratedColumn<int>(
    'picky_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lunchboxTypeMeta = const VerificationMeta(
    'lunchboxType',
  );
  @override
  late final GeneratedColumn<String> lunchboxType = GeneratedColumn<String>(
    'lunchbox_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    birthDate,
    allergies,
    dislikes,
    likes,
    pickyLevel,
    lunchboxType,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kid_profiles_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<KidProfileEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    } else if (isInserting) {
      context.missing(_birthDateMeta);
    }
    if (data.containsKey('allergies')) {
      context.handle(
        _allergiesMeta,
        allergies.isAcceptableOrUnknown(data['allergies']!, _allergiesMeta),
      );
    } else if (isInserting) {
      context.missing(_allergiesMeta);
    }
    if (data.containsKey('dislikes')) {
      context.handle(
        _dislikesMeta,
        dislikes.isAcceptableOrUnknown(data['dislikes']!, _dislikesMeta),
      );
    } else if (isInserting) {
      context.missing(_dislikesMeta);
    }
    if (data.containsKey('likes')) {
      context.handle(
        _likesMeta,
        likes.isAcceptableOrUnknown(data['likes']!, _likesMeta),
      );
    } else if (isInserting) {
      context.missing(_likesMeta);
    }
    if (data.containsKey('picky_level')) {
      context.handle(
        _pickyLevelMeta,
        pickyLevel.isAcceptableOrUnknown(data['picky_level']!, _pickyLevelMeta),
      );
    }
    if (data.containsKey('lunchbox_type')) {
      context.handle(
        _lunchboxTypeMeta,
        lunchboxType.isAcceptableOrUnknown(
          data['lunchbox_type']!,
          _lunchboxTypeMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KidProfileEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KidProfileEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      )!,
      allergies: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allergies'],
      )!,
      dislikes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dislikes'],
      )!,
      likes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}likes'],
      )!,
      pickyLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}picky_level'],
      )!,
      lunchboxType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lunchbox_type'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $KidProfilesTableTable createAlias(String alias) {
    return $KidProfilesTableTable(attachedDatabase, alias);
  }
}

class KidProfileEntry extends DataClass implements Insertable<KidProfileEntry> {
  final String id;
  final String name;
  final DateTime birthDate;
  final String allergies;
  final String dislikes;
  final String likes;
  final int pickyLevel;
  final String lunchboxType;
  final String? notes;
  const KidProfileEntry({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.allergies,
    required this.dislikes,
    required this.likes,
    required this.pickyLevel,
    required this.lunchboxType,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['birth_date'] = Variable<DateTime>(birthDate);
    map['allergies'] = Variable<String>(allergies);
    map['dislikes'] = Variable<String>(dislikes);
    map['likes'] = Variable<String>(likes);
    map['picky_level'] = Variable<int>(pickyLevel);
    map['lunchbox_type'] = Variable<String>(lunchboxType);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  KidProfilesTableCompanion toCompanion(bool nullToAbsent) {
    return KidProfilesTableCompanion(
      id: Value(id),
      name: Value(name),
      birthDate: Value(birthDate),
      allergies: Value(allergies),
      dislikes: Value(dislikes),
      likes: Value(likes),
      pickyLevel: Value(pickyLevel),
      lunchboxType: Value(lunchboxType),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory KidProfileEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KidProfileEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      birthDate: serializer.fromJson<DateTime>(json['birthDate']),
      allergies: serializer.fromJson<String>(json['allergies']),
      dislikes: serializer.fromJson<String>(json['dislikes']),
      likes: serializer.fromJson<String>(json['likes']),
      pickyLevel: serializer.fromJson<int>(json['pickyLevel']),
      lunchboxType: serializer.fromJson<String>(json['lunchboxType']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'birthDate': serializer.toJson<DateTime>(birthDate),
      'allergies': serializer.toJson<String>(allergies),
      'dislikes': serializer.toJson<String>(dislikes),
      'likes': serializer.toJson<String>(likes),
      'pickyLevel': serializer.toJson<int>(pickyLevel),
      'lunchboxType': serializer.toJson<String>(lunchboxType),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  KidProfileEntry copyWith({
    String? id,
    String? name,
    DateTime? birthDate,
    String? allergies,
    String? dislikes,
    String? likes,
    int? pickyLevel,
    String? lunchboxType,
    Value<String?> notes = const Value.absent(),
  }) => KidProfileEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    birthDate: birthDate ?? this.birthDate,
    allergies: allergies ?? this.allergies,
    dislikes: dislikes ?? this.dislikes,
    likes: likes ?? this.likes,
    pickyLevel: pickyLevel ?? this.pickyLevel,
    lunchboxType: lunchboxType ?? this.lunchboxType,
    notes: notes.present ? notes.value : this.notes,
  );
  KidProfileEntry copyWithCompanion(KidProfilesTableCompanion data) {
    return KidProfileEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      allergies: data.allergies.present ? data.allergies.value : this.allergies,
      dislikes: data.dislikes.present ? data.dislikes.value : this.dislikes,
      likes: data.likes.present ? data.likes.value : this.likes,
      pickyLevel: data.pickyLevel.present
          ? data.pickyLevel.value
          : this.pickyLevel,
      lunchboxType: data.lunchboxType.present
          ? data.lunchboxType.value
          : this.lunchboxType,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KidProfileEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('birthDate: $birthDate, ')
          ..write('allergies: $allergies, ')
          ..write('dislikes: $dislikes, ')
          ..write('likes: $likes, ')
          ..write('pickyLevel: $pickyLevel, ')
          ..write('lunchboxType: $lunchboxType, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    birthDate,
    allergies,
    dislikes,
    likes,
    pickyLevel,
    lunchboxType,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KidProfileEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.birthDate == this.birthDate &&
          other.allergies == this.allergies &&
          other.dislikes == this.dislikes &&
          other.likes == this.likes &&
          other.pickyLevel == this.pickyLevel &&
          other.lunchboxType == this.lunchboxType &&
          other.notes == this.notes);
}

class KidProfilesTableCompanion extends UpdateCompanion<KidProfileEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> birthDate;
  final Value<String> allergies;
  final Value<String> dislikes;
  final Value<String> likes;
  final Value<int> pickyLevel;
  final Value<String> lunchboxType;
  final Value<String?> notes;
  final Value<int> rowid;
  const KidProfilesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.allergies = const Value.absent(),
    this.dislikes = const Value.absent(),
    this.likes = const Value.absent(),
    this.pickyLevel = const Value.absent(),
    this.lunchboxType = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KidProfilesTableCompanion.insert({
    required String id,
    required String name,
    required DateTime birthDate,
    required String allergies,
    required String dislikes,
    required String likes,
    this.pickyLevel = const Value.absent(),
    this.lunchboxType = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       birthDate = Value(birthDate),
       allergies = Value(allergies),
       dislikes = Value(dislikes),
       likes = Value(likes);
  static Insertable<KidProfileEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? birthDate,
    Expression<String>? allergies,
    Expression<String>? dislikes,
    Expression<String>? likes,
    Expression<int>? pickyLevel,
    Expression<String>? lunchboxType,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (birthDate != null) 'birth_date': birthDate,
      if (allergies != null) 'allergies': allergies,
      if (dislikes != null) 'dislikes': dislikes,
      if (likes != null) 'likes': likes,
      if (pickyLevel != null) 'picky_level': pickyLevel,
      if (lunchboxType != null) 'lunchbox_type': lunchboxType,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KidProfilesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<DateTime>? birthDate,
    Value<String>? allergies,
    Value<String>? dislikes,
    Value<String>? likes,
    Value<int>? pickyLevel,
    Value<String>? lunchboxType,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return KidProfilesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      allergies: allergies ?? this.allergies,
      dislikes: dislikes ?? this.dislikes,
      likes: likes ?? this.likes,
      pickyLevel: pickyLevel ?? this.pickyLevel,
      lunchboxType: lunchboxType ?? this.lunchboxType,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (allergies.present) {
      map['allergies'] = Variable<String>(allergies.value);
    }
    if (dislikes.present) {
      map['dislikes'] = Variable<String>(dislikes.value);
    }
    if (likes.present) {
      map['likes'] = Variable<String>(likes.value);
    }
    if (pickyLevel.present) {
      map['picky_level'] = Variable<int>(pickyLevel.value);
    }
    if (lunchboxType.present) {
      map['lunchbox_type'] = Variable<String>(lunchboxType.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KidProfilesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('birthDate: $birthDate, ')
          ..write('allergies: $allergies, ')
          ..write('dislikes: $dislikes, ')
          ..write('likes: $likes, ')
          ..write('pickyLevel: $pickyLevel, ')
          ..write('lunchboxType: $lunchboxType, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MealFeedbacksTableTable extends MealFeedbacksTable
    with TableInfo<$MealFeedbacksTableTable, MealFeedbackEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealFeedbacksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kidIdMeta = const VerificationMeta('kidId');
  @override
  late final GeneratedColumn<String> kidId = GeneratedColumn<String>(
    'kid_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reactionMeta = const VerificationMeta(
    'reaction',
  );
  @override
  late final GeneratedColumn<String> reaction = GeneratedColumn<String>(
    'reaction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonTagMeta = const VerificationMeta(
    'reasonTag',
  );
  @override
  late final GeneratedColumn<String> reasonTag = GeneratedColumn<String>(
    'reason_tag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recipeId,
    kidId,
    reaction,
    reasonTag,
    date,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_feedbacks_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealFeedbackEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('kid_id')) {
      context.handle(
        _kidIdMeta,
        kidId.isAcceptableOrUnknown(data['kid_id']!, _kidIdMeta),
      );
    }
    if (data.containsKey('reaction')) {
      context.handle(
        _reactionMeta,
        reaction.isAcceptableOrUnknown(data['reaction']!, _reactionMeta),
      );
    } else if (isInserting) {
      context.missing(_reactionMeta);
    }
    if (data.containsKey('reason_tag')) {
      context.handle(
        _reasonTagMeta,
        reasonTag.isAcceptableOrUnknown(data['reason_tag']!, _reasonTagMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealFeedbackEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealFeedbackEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      )!,
      kidId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kid_id'],
      ),
      reaction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reaction'],
      )!,
      reasonTag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason_tag'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $MealFeedbacksTableTable createAlias(String alias) {
    return $MealFeedbacksTableTable(attachedDatabase, alias);
  }
}

class MealFeedbackEntry extends DataClass
    implements Insertable<MealFeedbackEntry> {
  final String id;
  final String recipeId;
  final String? kidId;
  final String reaction;
  final String? reasonTag;
  final DateTime date;
  final String? notes;
  const MealFeedbackEntry({
    required this.id,
    required this.recipeId,
    this.kidId,
    required this.reaction,
    this.reasonTag,
    required this.date,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['recipe_id'] = Variable<String>(recipeId);
    if (!nullToAbsent || kidId != null) {
      map['kid_id'] = Variable<String>(kidId);
    }
    map['reaction'] = Variable<String>(reaction);
    if (!nullToAbsent || reasonTag != null) {
      map['reason_tag'] = Variable<String>(reasonTag);
    }
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  MealFeedbacksTableCompanion toCompanion(bool nullToAbsent) {
    return MealFeedbacksTableCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      kidId: kidId == null && nullToAbsent
          ? const Value.absent()
          : Value(kidId),
      reaction: Value(reaction),
      reasonTag: reasonTag == null && nullToAbsent
          ? const Value.absent()
          : Value(reasonTag),
      date: Value(date),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory MealFeedbackEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealFeedbackEntry(
      id: serializer.fromJson<String>(json['id']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      kidId: serializer.fromJson<String?>(json['kidId']),
      reaction: serializer.fromJson<String>(json['reaction']),
      reasonTag: serializer.fromJson<String?>(json['reasonTag']),
      date: serializer.fromJson<DateTime>(json['date']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'recipeId': serializer.toJson<String>(recipeId),
      'kidId': serializer.toJson<String?>(kidId),
      'reaction': serializer.toJson<String>(reaction),
      'reasonTag': serializer.toJson<String?>(reasonTag),
      'date': serializer.toJson<DateTime>(date),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  MealFeedbackEntry copyWith({
    String? id,
    String? recipeId,
    Value<String?> kidId = const Value.absent(),
    String? reaction,
    Value<String?> reasonTag = const Value.absent(),
    DateTime? date,
    Value<String?> notes = const Value.absent(),
  }) => MealFeedbackEntry(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    kidId: kidId.present ? kidId.value : this.kidId,
    reaction: reaction ?? this.reaction,
    reasonTag: reasonTag.present ? reasonTag.value : this.reasonTag,
    date: date ?? this.date,
    notes: notes.present ? notes.value : this.notes,
  );
  MealFeedbackEntry copyWithCompanion(MealFeedbacksTableCompanion data) {
    return MealFeedbackEntry(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      kidId: data.kidId.present ? data.kidId.value : this.kidId,
      reaction: data.reaction.present ? data.reaction.value : this.reaction,
      reasonTag: data.reasonTag.present ? data.reasonTag.value : this.reasonTag,
      date: data.date.present ? data.date.value : this.date,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealFeedbackEntry(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('kidId: $kidId, ')
          ..write('reaction: $reaction, ')
          ..write('reasonTag: $reasonTag, ')
          ..write('date: $date, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, recipeId, kidId, reaction, reasonTag, date, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealFeedbackEntry &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.kidId == this.kidId &&
          other.reaction == this.reaction &&
          other.reasonTag == this.reasonTag &&
          other.date == this.date &&
          other.notes == this.notes);
}

class MealFeedbacksTableCompanion extends UpdateCompanion<MealFeedbackEntry> {
  final Value<String> id;
  final Value<String> recipeId;
  final Value<String?> kidId;
  final Value<String> reaction;
  final Value<String?> reasonTag;
  final Value<DateTime> date;
  final Value<String?> notes;
  final Value<int> rowid;
  const MealFeedbacksTableCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.kidId = const Value.absent(),
    this.reaction = const Value.absent(),
    this.reasonTag = const Value.absent(),
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MealFeedbacksTableCompanion.insert({
    required String id,
    required String recipeId,
    this.kidId = const Value.absent(),
    required String reaction,
    this.reasonTag = const Value.absent(),
    required DateTime date,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       recipeId = Value(recipeId),
       reaction = Value(reaction),
       date = Value(date);
  static Insertable<MealFeedbackEntry> custom({
    Expression<String>? id,
    Expression<String>? recipeId,
    Expression<String>? kidId,
    Expression<String>? reaction,
    Expression<String>? reasonTag,
    Expression<DateTime>? date,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (kidId != null) 'kid_id': kidId,
      if (reaction != null) 'reaction': reaction,
      if (reasonTag != null) 'reason_tag': reasonTag,
      if (date != null) 'date': date,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MealFeedbacksTableCompanion copyWith({
    Value<String>? id,
    Value<String>? recipeId,
    Value<String?>? kidId,
    Value<String>? reaction,
    Value<String?>? reasonTag,
    Value<DateTime>? date,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return MealFeedbacksTableCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      kidId: kidId ?? this.kidId,
      reaction: reaction ?? this.reaction,
      reasonTag: reasonTag ?? this.reasonTag,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (kidId.present) {
      map['kid_id'] = Variable<String>(kidId.value);
    }
    if (reaction.present) {
      map['reaction'] = Variable<String>(reaction.value);
    }
    if (reasonTag.present) {
      map['reason_tag'] = Variable<String>(reasonTag.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealFeedbacksTableCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('kidId: $kidId, ')
          ..write('reaction: $reaction, ')
          ..write('reasonTag: $reasonTag, ')
          ..write('date: $date, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroceryItemsTableTable extends GroceryItemsTable
    with TableInfo<$GroceryItemsTableTable, GroceryItemEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroceryItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<String> ingredientId = GeneratedColumn<String>(
    'ingredient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aisleMeta = const VerificationMeta('aisle');
  @override
  late final GeneratedColumn<String> aisle = GeneratedColumn<String>(
    'aisle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCheckedMeta = const VerificationMeta(
    'isChecked',
  );
  @override
  late final GeneratedColumn<bool> isChecked = GeneratedColumn<bool>(
    'is_checked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_checked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ingredientId,
    nameAr,
    nameEn,
    aisle,
    quantity,
    unit,
    isChecked,
    recipeId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grocery_items_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroceryItemEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('aisle')) {
      context.handle(
        _aisleMeta,
        aisle.isAcceptableOrUnknown(data['aisle']!, _aisleMeta),
      );
    } else if (isInserting) {
      context.missing(_aisleMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('is_checked')) {
      context.handle(
        _isCheckedMeta,
        isChecked.isAcceptableOrUnknown(data['is_checked']!, _isCheckedMeta),
      );
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroceryItemEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroceryItemEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredient_id'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      aisle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aisle'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      isChecked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_checked'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      ),
    );
  }

  @override
  $GroceryItemsTableTable createAlias(String alias) {
    return $GroceryItemsTableTable(attachedDatabase, alias);
  }
}

class GroceryItemEntry extends DataClass
    implements Insertable<GroceryItemEntry> {
  final String id;
  final String ingredientId;
  final String nameAr;
  final String nameEn;
  final String aisle;
  final double? quantity;
  final String? unit;
  final bool isChecked;
  final String? recipeId;
  const GroceryItemEntry({
    required this.id,
    required this.ingredientId,
    required this.nameAr,
    required this.nameEn,
    required this.aisle,
    this.quantity,
    this.unit,
    required this.isChecked,
    this.recipeId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['ingredient_id'] = Variable<String>(ingredientId);
    map['name_ar'] = Variable<String>(nameAr);
    map['name_en'] = Variable<String>(nameEn);
    map['aisle'] = Variable<String>(aisle);
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<double>(quantity);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    map['is_checked'] = Variable<bool>(isChecked);
    if (!nullToAbsent || recipeId != null) {
      map['recipe_id'] = Variable<String>(recipeId);
    }
    return map;
  }

  GroceryItemsTableCompanion toCompanion(bool nullToAbsent) {
    return GroceryItemsTableCompanion(
      id: Value(id),
      ingredientId: Value(ingredientId),
      nameAr: Value(nameAr),
      nameEn: Value(nameEn),
      aisle: Value(aisle),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      isChecked: Value(isChecked),
      recipeId: recipeId == null && nullToAbsent
          ? const Value.absent()
          : Value(recipeId),
    );
  }

  factory GroceryItemEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroceryItemEntry(
      id: serializer.fromJson<String>(json['id']),
      ingredientId: serializer.fromJson<String>(json['ingredientId']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      aisle: serializer.fromJson<String>(json['aisle']),
      quantity: serializer.fromJson<double?>(json['quantity']),
      unit: serializer.fromJson<String?>(json['unit']),
      isChecked: serializer.fromJson<bool>(json['isChecked']),
      recipeId: serializer.fromJson<String?>(json['recipeId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ingredientId': serializer.toJson<String>(ingredientId),
      'nameAr': serializer.toJson<String>(nameAr),
      'nameEn': serializer.toJson<String>(nameEn),
      'aisle': serializer.toJson<String>(aisle),
      'quantity': serializer.toJson<double?>(quantity),
      'unit': serializer.toJson<String?>(unit),
      'isChecked': serializer.toJson<bool>(isChecked),
      'recipeId': serializer.toJson<String?>(recipeId),
    };
  }

  GroceryItemEntry copyWith({
    String? id,
    String? ingredientId,
    String? nameAr,
    String? nameEn,
    String? aisle,
    Value<double?> quantity = const Value.absent(),
    Value<String?> unit = const Value.absent(),
    bool? isChecked,
    Value<String?> recipeId = const Value.absent(),
  }) => GroceryItemEntry(
    id: id ?? this.id,
    ingredientId: ingredientId ?? this.ingredientId,
    nameAr: nameAr ?? this.nameAr,
    nameEn: nameEn ?? this.nameEn,
    aisle: aisle ?? this.aisle,
    quantity: quantity.present ? quantity.value : this.quantity,
    unit: unit.present ? unit.value : this.unit,
    isChecked: isChecked ?? this.isChecked,
    recipeId: recipeId.present ? recipeId.value : this.recipeId,
  );
  GroceryItemEntry copyWithCompanion(GroceryItemsTableCompanion data) {
    return GroceryItemEntry(
      id: data.id.present ? data.id.value : this.id,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      aisle: data.aisle.present ? data.aisle.value : this.aisle,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      isChecked: data.isChecked.present ? data.isChecked.value : this.isChecked,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroceryItemEntry(')
          ..write('id: $id, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn, ')
          ..write('aisle: $aisle, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('isChecked: $isChecked, ')
          ..write('recipeId: $recipeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ingredientId,
    nameAr,
    nameEn,
    aisle,
    quantity,
    unit,
    isChecked,
    recipeId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroceryItemEntry &&
          other.id == this.id &&
          other.ingredientId == this.ingredientId &&
          other.nameAr == this.nameAr &&
          other.nameEn == this.nameEn &&
          other.aisle == this.aisle &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.isChecked == this.isChecked &&
          other.recipeId == this.recipeId);
}

class GroceryItemsTableCompanion extends UpdateCompanion<GroceryItemEntry> {
  final Value<String> id;
  final Value<String> ingredientId;
  final Value<String> nameAr;
  final Value<String> nameEn;
  final Value<String> aisle;
  final Value<double?> quantity;
  final Value<String?> unit;
  final Value<bool> isChecked;
  final Value<String?> recipeId;
  final Value<int> rowid;
  const GroceryItemsTableCompanion({
    this.id = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.aisle = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.isChecked = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroceryItemsTableCompanion.insert({
    required String id,
    required String ingredientId,
    required String nameAr,
    required String nameEn,
    required String aisle,
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.isChecked = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ingredientId = Value(ingredientId),
       nameAr = Value(nameAr),
       nameEn = Value(nameEn),
       aisle = Value(aisle);
  static Insertable<GroceryItemEntry> custom({
    Expression<String>? id,
    Expression<String>? ingredientId,
    Expression<String>? nameAr,
    Expression<String>? nameEn,
    Expression<String>? aisle,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<bool>? isChecked,
    Expression<String>? recipeId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
      if (aisle != null) 'aisle': aisle,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (isChecked != null) 'is_checked': isChecked,
      if (recipeId != null) 'recipe_id': recipeId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroceryItemsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? ingredientId,
    Value<String>? nameAr,
    Value<String>? nameEn,
    Value<String>? aisle,
    Value<double?>? quantity,
    Value<String?>? unit,
    Value<bool>? isChecked,
    Value<String?>? recipeId,
    Value<int>? rowid,
  }) {
    return GroceryItemsTableCompanion(
      id: id ?? this.id,
      ingredientId: ingredientId ?? this.ingredientId,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      aisle: aisle ?? this.aisle,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      isChecked: isChecked ?? this.isChecked,
      recipeId: recipeId ?? this.recipeId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<String>(ingredientId.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (aisle.present) {
      map['aisle'] = Variable<String>(aisle.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (isChecked.present) {
      map['is_checked'] = Variable<bool>(isChecked.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroceryItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn, ')
          ..write('aisle: $aisle, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('isChecked: $isChecked, ')
          ..write('recipeId: $recipeId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppMetadataTableTable extends AppMetadataTable
    with TableInfo<$AppMetadataTableTable, AppMetadataEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppMetadataTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_metadata_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppMetadataEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppMetadataEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppMetadataEntry(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppMetadataTableTable createAlias(String alias) {
    return $AppMetadataTableTable(attachedDatabase, alias);
  }
}

class AppMetadataEntry extends DataClass
    implements Insertable<AppMetadataEntry> {
  final String key;
  final String value;
  const AppMetadataEntry({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppMetadataTableCompanion toCompanion(bool nullToAbsent) {
    return AppMetadataTableCompanion(key: Value(key), value: Value(value));
  }

  factory AppMetadataEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppMetadataEntry(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppMetadataEntry copyWith({String? key, String? value}) =>
      AppMetadataEntry(key: key ?? this.key, value: value ?? this.value);
  AppMetadataEntry copyWithCompanion(AppMetadataTableCompanion data) {
    return AppMetadataEntry(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppMetadataEntry(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppMetadataEntry &&
          other.key == this.key &&
          other.value == this.value);
}

class AppMetadataTableCompanion extends UpdateCompanion<AppMetadataEntry> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppMetadataTableCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppMetadataTableCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppMetadataEntry> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppMetadataTableCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppMetadataTableCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppMetadataTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $IngredientsTableTable ingredientsTable = $IngredientsTableTable(
    this,
  );
  late final $RecipesTableTable recipesTable = $RecipesTableTable(this);
  late final $RecipeIngredientsTableTable recipeIngredientsTable =
      $RecipeIngredientsTableTable(this);
  late final $KidProfilesTableTable kidProfilesTable = $KidProfilesTableTable(
    this,
  );
  late final $MealFeedbacksTableTable mealFeedbacksTable =
      $MealFeedbacksTableTable(this);
  late final $GroceryItemsTableTable groceryItemsTable =
      $GroceryItemsTableTable(this);
  late final $AppMetadataTableTable appMetadataTable = $AppMetadataTableTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    ingredientsTable,
    recipesTable,
    recipeIngredientsTable,
    kidProfilesTable,
    mealFeedbacksTable,
    groceryItemsTable,
    appMetadataTable,
  ];
}

typedef $$IngredientsTableTableCreateCompanionBuilder =
    IngredientsTableCompanion Function({
      required String id,
      required String nameAr,
      required String nameEn,
      required String category,
      required String allergens,
      Value<bool> commonInRegion,
      Value<int> rowid,
    });
typedef $$IngredientsTableTableUpdateCompanionBuilder =
    IngredientsTableCompanion Function({
      Value<String> id,
      Value<String> nameAr,
      Value<String> nameEn,
      Value<String> category,
      Value<String> allergens,
      Value<bool> commonInRegion,
      Value<int> rowid,
    });

class $$IngredientsTableTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientsTableTable> {
  $$IngredientsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allergens => $composableBuilder(
    column: $table.allergens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get commonInRegion => $composableBuilder(
    column: $table.commonInRegion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$IngredientsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientsTableTable> {
  $$IngredientsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allergens => $composableBuilder(
    column: $table.allergens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get commonInRegion => $composableBuilder(
    column: $table.commonInRegion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IngredientsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientsTableTable> {
  $$IngredientsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get allergens =>
      $composableBuilder(column: $table.allergens, builder: (column) => column);

  GeneratedColumn<bool> get commonInRegion => $composableBuilder(
    column: $table.commonInRegion,
    builder: (column) => column,
  );
}

class $$IngredientsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngredientsTableTable,
          IngredientEntry,
          $$IngredientsTableTableFilterComposer,
          $$IngredientsTableTableOrderingComposer,
          $$IngredientsTableTableAnnotationComposer,
          $$IngredientsTableTableCreateCompanionBuilder,
          $$IngredientsTableTableUpdateCompanionBuilder,
          (
            IngredientEntry,
            BaseReferences<
              _$AppDatabase,
              $IngredientsTableTable,
              IngredientEntry
            >,
          ),
          IngredientEntry,
          PrefetchHooks Function()
        > {
  $$IngredientsTableTableTableManager(
    _$AppDatabase db,
    $IngredientsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngredientsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> allergens = const Value.absent(),
                Value<bool> commonInRegion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IngredientsTableCompanion(
                id: id,
                nameAr: nameAr,
                nameEn: nameEn,
                category: category,
                allergens: allergens,
                commonInRegion: commonInRegion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nameAr,
                required String nameEn,
                required String category,
                required String allergens,
                Value<bool> commonInRegion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IngredientsTableCompanion.insert(
                id: id,
                nameAr: nameAr,
                nameEn: nameEn,
                category: category,
                allergens: allergens,
                commonInRegion: commonInRegion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$IngredientsTableTable, IngredientEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $IngredientsTableTable,
                    IngredientEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$IngredientsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngredientsTableTable,
      IngredientEntry,
      $$IngredientsTableTableFilterComposer,
      $$IngredientsTableTableOrderingComposer,
      $$IngredientsTableTableAnnotationComposer,
      $$IngredientsTableTableCreateCompanionBuilder,
      $$IngredientsTableTableUpdateCompanionBuilder,
      (
        IngredientEntry,
        BaseReferences<_$AppDatabase, $IngredientsTableTable, IngredientEntry>,
      ),
      IngredientEntry,
      PrefetchHooks Function()
    >;
typedef $$RecipesTableTableCreateCompanionBuilder =
    RecipesTableCompanion Function({
      required String id,
      required String title,
      required String description,
      required String steps,
      required int prepMinutes,
      required int cookMinutes,
      Value<int> servings,
      required String tags,
      Value<String> source,
      Value<int> ageMinMonths,
      Value<String?> imagePath,
      Value<int> safetyVersion,
      Value<int> rowid,
    });
typedef $$RecipesTableTableUpdateCompanionBuilder =
    RecipesTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> description,
      Value<String> steps,
      Value<int> prepMinutes,
      Value<int> cookMinutes,
      Value<int> servings,
      Value<String> tags,
      Value<String> source,
      Value<int> ageMinMonths,
      Value<String?> imagePath,
      Value<int> safetyVersion,
      Value<int> rowid,
    });

class $$RecipesTableTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTableTable> {
  $$RecipesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get prepMinutes => $composableBuilder(
    column: $table.prepMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cookMinutes => $composableBuilder(
    column: $table.cookMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ageMinMonths => $composableBuilder(
    column: $table.ageMinMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get safetyVersion => $composableBuilder(
    column: $table.safetyVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecipesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTableTable> {
  $$RecipesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get prepMinutes => $composableBuilder(
    column: $table.prepMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cookMinutes => $composableBuilder(
    column: $table.cookMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ageMinMonths => $composableBuilder(
    column: $table.ageMinMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get safetyVersion => $composableBuilder(
    column: $table.safetyVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTableTable> {
  $$RecipesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<int> get prepMinutes => $composableBuilder(
    column: $table.prepMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cookMinutes => $composableBuilder(
    column: $table.cookMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get ageMinMonths => $composableBuilder(
    column: $table.ageMinMonths,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<int> get safetyVersion => $composableBuilder(
    column: $table.safetyVersion,
    builder: (column) => column,
  );
}

class $$RecipesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipesTableTable,
          RecipeEntry,
          $$RecipesTableTableFilterComposer,
          $$RecipesTableTableOrderingComposer,
          $$RecipesTableTableAnnotationComposer,
          $$RecipesTableTableCreateCompanionBuilder,
          $$RecipesTableTableUpdateCompanionBuilder,
          (
            RecipeEntry,
            BaseReferences<_$AppDatabase, $RecipesTableTable, RecipeEntry>,
          ),
          RecipeEntry,
          PrefetchHooks Function()
        > {
  $$RecipesTableTableTableManager(_$AppDatabase db, $RecipesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> steps = const Value.absent(),
                Value<int> prepMinutes = const Value.absent(),
                Value<int> cookMinutes = const Value.absent(),
                Value<int> servings = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> ageMinMonths = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<int> safetyVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipesTableCompanion(
                id: id,
                title: title,
                description: description,
                steps: steps,
                prepMinutes: prepMinutes,
                cookMinutes: cookMinutes,
                servings: servings,
                tags: tags,
                source: source,
                ageMinMonths: ageMinMonths,
                imagePath: imagePath,
                safetyVersion: safetyVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String description,
                required String steps,
                required int prepMinutes,
                required int cookMinutes,
                Value<int> servings = const Value.absent(),
                required String tags,
                Value<String> source = const Value.absent(),
                Value<int> ageMinMonths = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<int> safetyVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipesTableCompanion.insert(
                id: id,
                title: title,
                description: description,
                steps: steps,
                prepMinutes: prepMinutes,
                cookMinutes: cookMinutes,
                servings: servings,
                tags: tags,
                source: source,
                ageMinMonths: ageMinMonths,
                imagePath: imagePath,
                safetyVersion: safetyVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecipesTableTable, RecipeEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $RecipesTableTable,
                    RecipeEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecipesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipesTableTable,
      RecipeEntry,
      $$RecipesTableTableFilterComposer,
      $$RecipesTableTableOrderingComposer,
      $$RecipesTableTableAnnotationComposer,
      $$RecipesTableTableCreateCompanionBuilder,
      $$RecipesTableTableUpdateCompanionBuilder,
      (
        RecipeEntry,
        BaseReferences<_$AppDatabase, $RecipesTableTable, RecipeEntry>,
      ),
      RecipeEntry,
      PrefetchHooks Function()
    >;
typedef $$RecipeIngredientsTableTableCreateCompanionBuilder =
    RecipeIngredientsTableCompanion Function({
      Value<int> id,
      required String recipeId,
      required String ingredientId,
      Value<double?> quantity,
      Value<String?> unit,
      Value<String?> displayText,
      Value<bool> optional,
    });
typedef $$RecipeIngredientsTableTableUpdateCompanionBuilder =
    RecipeIngredientsTableCompanion Function({
      Value<int> id,
      Value<String> recipeId,
      Value<String> ingredientId,
      Value<double?> quantity,
      Value<String?> unit,
      Value<String?> displayText,
      Value<bool> optional,
    });

class $$RecipeIngredientsTableTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTableTable> {
  $$RecipeIngredientsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayText => $composableBuilder(
    column: $table.displayText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get optional => $composableBuilder(
    column: $table.optional,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecipeIngredientsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTableTable> {
  $$RecipeIngredientsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayText => $composableBuilder(
    column: $table.displayText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get optional => $composableBuilder(
    column: $table.optional,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipeIngredientsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTableTable> {
  $$RecipeIngredientsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get displayText => $composableBuilder(
    column: $table.displayText,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get optional =>
      $composableBuilder(column: $table.optional, builder: (column) => column);
}

class $$RecipeIngredientsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeIngredientsTableTable,
          RecipeIngredientEntry,
          $$RecipeIngredientsTableTableFilterComposer,
          $$RecipeIngredientsTableTableOrderingComposer,
          $$RecipeIngredientsTableTableAnnotationComposer,
          $$RecipeIngredientsTableTableCreateCompanionBuilder,
          $$RecipeIngredientsTableTableUpdateCompanionBuilder,
          (
            RecipeIngredientEntry,
            BaseReferences<
              _$AppDatabase,
              $RecipeIngredientsTableTable,
              RecipeIngredientEntry
            >,
          ),
          RecipeIngredientEntry,
          PrefetchHooks Function()
        > {
  $$RecipeIngredientsTableTableTableManager(
    _$AppDatabase db,
    $RecipeIngredientsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeIngredientsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RecipeIngredientsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RecipeIngredientsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> recipeId = const Value.absent(),
                Value<String> ingredientId = const Value.absent(),
                Value<double?> quantity = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> displayText = const Value.absent(),
                Value<bool> optional = const Value.absent(),
              }) => RecipeIngredientsTableCompanion(
                id: id,
                recipeId: recipeId,
                ingredientId: ingredientId,
                quantity: quantity,
                unit: unit,
                displayText: displayText,
                optional: optional,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String recipeId,
                required String ingredientId,
                Value<double?> quantity = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> displayText = const Value.absent(),
                Value<bool> optional = const Value.absent(),
              }) => RecipeIngredientsTableCompanion.insert(
                id: id,
                recipeId: recipeId,
                ingredientId: ingredientId,
                quantity: quantity,
                unit: unit,
                displayText: displayText,
                optional: optional,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $RecipeIngredientsTableTable,
                    RecipeIngredientEntry
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $RecipeIngredientsTableTable,
                    RecipeIngredientEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecipeIngredientsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeIngredientsTableTable,
      RecipeIngredientEntry,
      $$RecipeIngredientsTableTableFilterComposer,
      $$RecipeIngredientsTableTableOrderingComposer,
      $$RecipeIngredientsTableTableAnnotationComposer,
      $$RecipeIngredientsTableTableCreateCompanionBuilder,
      $$RecipeIngredientsTableTableUpdateCompanionBuilder,
      (
        RecipeIngredientEntry,
        BaseReferences<
          _$AppDatabase,
          $RecipeIngredientsTableTable,
          RecipeIngredientEntry
        >,
      ),
      RecipeIngredientEntry,
      PrefetchHooks Function()
    >;
typedef $$KidProfilesTableTableCreateCompanionBuilder =
    KidProfilesTableCompanion Function({
      required String id,
      required String name,
      required DateTime birthDate,
      required String allergies,
      required String dislikes,
      required String likes,
      Value<int> pickyLevel,
      Value<String> lunchboxType,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$KidProfilesTableTableUpdateCompanionBuilder =
    KidProfilesTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<DateTime> birthDate,
      Value<String> allergies,
      Value<String> dislikes,
      Value<String> likes,
      Value<int> pickyLevel,
      Value<String> lunchboxType,
      Value<String?> notes,
      Value<int> rowid,
    });

class $$KidProfilesTableTableFilterComposer
    extends Composer<_$AppDatabase, $KidProfilesTableTable> {
  $$KidProfilesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dislikes => $composableBuilder(
    column: $table.dislikes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get likes => $composableBuilder(
    column: $table.likes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pickyLevel => $composableBuilder(
    column: $table.pickyLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lunchboxType => $composableBuilder(
    column: $table.lunchboxType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KidProfilesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $KidProfilesTableTable> {
  $$KidProfilesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dislikes => $composableBuilder(
    column: $table.dislikes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get likes => $composableBuilder(
    column: $table.likes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pickyLevel => $composableBuilder(
    column: $table.pickyLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lunchboxType => $composableBuilder(
    column: $table.lunchboxType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KidProfilesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $KidProfilesTableTable> {
  $$KidProfilesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<String> get allergies =>
      $composableBuilder(column: $table.allergies, builder: (column) => column);

  GeneratedColumn<String> get dislikes =>
      $composableBuilder(column: $table.dislikes, builder: (column) => column);

  GeneratedColumn<String> get likes =>
      $composableBuilder(column: $table.likes, builder: (column) => column);

  GeneratedColumn<int> get pickyLevel => $composableBuilder(
    column: $table.pickyLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lunchboxType => $composableBuilder(
    column: $table.lunchboxType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$KidProfilesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KidProfilesTableTable,
          KidProfileEntry,
          $$KidProfilesTableTableFilterComposer,
          $$KidProfilesTableTableOrderingComposer,
          $$KidProfilesTableTableAnnotationComposer,
          $$KidProfilesTableTableCreateCompanionBuilder,
          $$KidProfilesTableTableUpdateCompanionBuilder,
          (
            KidProfileEntry,
            BaseReferences<
              _$AppDatabase,
              $KidProfilesTableTable,
              KidProfileEntry
            >,
          ),
          KidProfileEntry,
          PrefetchHooks Function()
        > {
  $$KidProfilesTableTableTableManager(
    _$AppDatabase db,
    $KidProfilesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KidProfilesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KidProfilesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KidProfilesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> birthDate = const Value.absent(),
                Value<String> allergies = const Value.absent(),
                Value<String> dislikes = const Value.absent(),
                Value<String> likes = const Value.absent(),
                Value<int> pickyLevel = const Value.absent(),
                Value<String> lunchboxType = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KidProfilesTableCompanion(
                id: id,
                name: name,
                birthDate: birthDate,
                allergies: allergies,
                dislikes: dislikes,
                likes: likes,
                pickyLevel: pickyLevel,
                lunchboxType: lunchboxType,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required DateTime birthDate,
                required String allergies,
                required String dislikes,
                required String likes,
                Value<int> pickyLevel = const Value.absent(),
                Value<String> lunchboxType = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KidProfilesTableCompanion.insert(
                id: id,
                name: name,
                birthDate: birthDate,
                allergies: allergies,
                dislikes: dislikes,
                likes: likes,
                pickyLevel: pickyLevel,
                lunchboxType: lunchboxType,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$KidProfilesTableTable, KidProfileEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $KidProfilesTableTable,
                    KidProfileEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KidProfilesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KidProfilesTableTable,
      KidProfileEntry,
      $$KidProfilesTableTableFilterComposer,
      $$KidProfilesTableTableOrderingComposer,
      $$KidProfilesTableTableAnnotationComposer,
      $$KidProfilesTableTableCreateCompanionBuilder,
      $$KidProfilesTableTableUpdateCompanionBuilder,
      (
        KidProfileEntry,
        BaseReferences<_$AppDatabase, $KidProfilesTableTable, KidProfileEntry>,
      ),
      KidProfileEntry,
      PrefetchHooks Function()
    >;
typedef $$MealFeedbacksTableTableCreateCompanionBuilder =
    MealFeedbacksTableCompanion Function({
      required String id,
      required String recipeId,
      Value<String?> kidId,
      required String reaction,
      Value<String?> reasonTag,
      required DateTime date,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$MealFeedbacksTableTableUpdateCompanionBuilder =
    MealFeedbacksTableCompanion Function({
      Value<String> id,
      Value<String> recipeId,
      Value<String?> kidId,
      Value<String> reaction,
      Value<String?> reasonTag,
      Value<DateTime> date,
      Value<String?> notes,
      Value<int> rowid,
    });

class $$MealFeedbacksTableTableFilterComposer
    extends Composer<_$AppDatabase, $MealFeedbacksTableTable> {
  $$MealFeedbacksTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kidId => $composableBuilder(
    column: $table.kidId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reaction => $composableBuilder(
    column: $table.reaction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reasonTag => $composableBuilder(
    column: $table.reasonTag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MealFeedbacksTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MealFeedbacksTableTable> {
  $$MealFeedbacksTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kidId => $composableBuilder(
    column: $table.kidId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reaction => $composableBuilder(
    column: $table.reaction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasonTag => $composableBuilder(
    column: $table.reasonTag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MealFeedbacksTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealFeedbacksTableTable> {
  $$MealFeedbacksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<String> get kidId =>
      $composableBuilder(column: $table.kidId, builder: (column) => column);

  GeneratedColumn<String> get reaction =>
      $composableBuilder(column: $table.reaction, builder: (column) => column);

  GeneratedColumn<String> get reasonTag =>
      $composableBuilder(column: $table.reasonTag, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$MealFeedbacksTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealFeedbacksTableTable,
          MealFeedbackEntry,
          $$MealFeedbacksTableTableFilterComposer,
          $$MealFeedbacksTableTableOrderingComposer,
          $$MealFeedbacksTableTableAnnotationComposer,
          $$MealFeedbacksTableTableCreateCompanionBuilder,
          $$MealFeedbacksTableTableUpdateCompanionBuilder,
          (
            MealFeedbackEntry,
            BaseReferences<
              _$AppDatabase,
              $MealFeedbacksTableTable,
              MealFeedbackEntry
            >,
          ),
          MealFeedbackEntry,
          PrefetchHooks Function()
        > {
  $$MealFeedbacksTableTableTableManager(
    _$AppDatabase db,
    $MealFeedbacksTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealFeedbacksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealFeedbacksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealFeedbacksTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> recipeId = const Value.absent(),
                Value<String?> kidId = const Value.absent(),
                Value<String> reaction = const Value.absent(),
                Value<String?> reasonTag = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealFeedbacksTableCompanion(
                id: id,
                recipeId: recipeId,
                kidId: kidId,
                reaction: reaction,
                reasonTag: reasonTag,
                date: date,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String recipeId,
                Value<String?> kidId = const Value.absent(),
                required String reaction,
                Value<String?> reasonTag = const Value.absent(),
                required DateTime date,
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealFeedbacksTableCompanion.insert(
                id: id,
                recipeId: recipeId,
                kidId: kidId,
                reaction: reaction,
                reasonTag: reasonTag,
                date: date,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MealFeedbacksTableTable, MealFeedbackEntry>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $MealFeedbacksTableTable,
                    MealFeedbackEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MealFeedbacksTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealFeedbacksTableTable,
      MealFeedbackEntry,
      $$MealFeedbacksTableTableFilterComposer,
      $$MealFeedbacksTableTableOrderingComposer,
      $$MealFeedbacksTableTableAnnotationComposer,
      $$MealFeedbacksTableTableCreateCompanionBuilder,
      $$MealFeedbacksTableTableUpdateCompanionBuilder,
      (
        MealFeedbackEntry,
        BaseReferences<
          _$AppDatabase,
          $MealFeedbacksTableTable,
          MealFeedbackEntry
        >,
      ),
      MealFeedbackEntry,
      PrefetchHooks Function()
    >;
typedef $$GroceryItemsTableTableCreateCompanionBuilder =
    GroceryItemsTableCompanion Function({
      required String id,
      required String ingredientId,
      required String nameAr,
      required String nameEn,
      required String aisle,
      Value<double?> quantity,
      Value<String?> unit,
      Value<bool> isChecked,
      Value<String?> recipeId,
      Value<int> rowid,
    });
typedef $$GroceryItemsTableTableUpdateCompanionBuilder =
    GroceryItemsTableCompanion Function({
      Value<String> id,
      Value<String> ingredientId,
      Value<String> nameAr,
      Value<String> nameEn,
      Value<String> aisle,
      Value<double?> quantity,
      Value<String?> unit,
      Value<bool> isChecked,
      Value<String?> recipeId,
      Value<int> rowid,
    });

class $$GroceryItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $GroceryItemsTableTable> {
  $$GroceryItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aisle => $composableBuilder(
    column: $table.aisle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isChecked => $composableBuilder(
    column: $table.isChecked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GroceryItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GroceryItemsTableTable> {
  $$GroceryItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aisle => $composableBuilder(
    column: $table.aisle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isChecked => $composableBuilder(
    column: $table.isChecked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GroceryItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroceryItemsTableTable> {
  $$GroceryItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get aisle =>
      $composableBuilder(column: $table.aisle, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<bool> get isChecked =>
      $composableBuilder(column: $table.isChecked, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);
}

class $$GroceryItemsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroceryItemsTableTable,
          GroceryItemEntry,
          $$GroceryItemsTableTableFilterComposer,
          $$GroceryItemsTableTableOrderingComposer,
          $$GroceryItemsTableTableAnnotationComposer,
          $$GroceryItemsTableTableCreateCompanionBuilder,
          $$GroceryItemsTableTableUpdateCompanionBuilder,
          (
            GroceryItemEntry,
            BaseReferences<
              _$AppDatabase,
              $GroceryItemsTableTable,
              GroceryItemEntry
            >,
          ),
          GroceryItemEntry,
          PrefetchHooks Function()
        > {
  $$GroceryItemsTableTableTableManager(
    _$AppDatabase db,
    $GroceryItemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroceryItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroceryItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroceryItemsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ingredientId = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String> aisle = const Value.absent(),
                Value<double?> quantity = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<bool> isChecked = const Value.absent(),
                Value<String?> recipeId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroceryItemsTableCompanion(
                id: id,
                ingredientId: ingredientId,
                nameAr: nameAr,
                nameEn: nameEn,
                aisle: aisle,
                quantity: quantity,
                unit: unit,
                isChecked: isChecked,
                recipeId: recipeId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ingredientId,
                required String nameAr,
                required String nameEn,
                required String aisle,
                Value<double?> quantity = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<bool> isChecked = const Value.absent(),
                Value<String?> recipeId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroceryItemsTableCompanion.insert(
                id: id,
                ingredientId: ingredientId,
                nameAr: nameAr,
                nameEn: nameEn,
                aisle: aisle,
                quantity: quantity,
                unit: unit,
                isChecked: isChecked,
                recipeId: recipeId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GroceryItemsTableTable, GroceryItemEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $GroceryItemsTableTable,
                    GroceryItemEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GroceryItemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroceryItemsTableTable,
      GroceryItemEntry,
      $$GroceryItemsTableTableFilterComposer,
      $$GroceryItemsTableTableOrderingComposer,
      $$GroceryItemsTableTableAnnotationComposer,
      $$GroceryItemsTableTableCreateCompanionBuilder,
      $$GroceryItemsTableTableUpdateCompanionBuilder,
      (
        GroceryItemEntry,
        BaseReferences<
          _$AppDatabase,
          $GroceryItemsTableTable,
          GroceryItemEntry
        >,
      ),
      GroceryItemEntry,
      PrefetchHooks Function()
    >;
typedef $$AppMetadataTableTableCreateCompanionBuilder =
    AppMetadataTableCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppMetadataTableTableUpdateCompanionBuilder =
    AppMetadataTableCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppMetadataTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppMetadataTableTable> {
  $$AppMetadataTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppMetadataTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppMetadataTableTable> {
  $$AppMetadataTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppMetadataTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppMetadataTableTable> {
  $$AppMetadataTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppMetadataTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppMetadataTableTable,
          AppMetadataEntry,
          $$AppMetadataTableTableFilterComposer,
          $$AppMetadataTableTableOrderingComposer,
          $$AppMetadataTableTableAnnotationComposer,
          $$AppMetadataTableTableCreateCompanionBuilder,
          $$AppMetadataTableTableUpdateCompanionBuilder,
          (
            AppMetadataEntry,
            BaseReferences<
              _$AppDatabase,
              $AppMetadataTableTable,
              AppMetadataEntry
            >,
          ),
          AppMetadataEntry,
          PrefetchHooks Function()
        > {
  $$AppMetadataTableTableTableManager(
    _$AppDatabase db,
    $AppMetadataTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppMetadataTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppMetadataTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppMetadataTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AppMetadataTableCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppMetadataTableCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppMetadataTableTable, AppMetadataEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppMetadataTableTable,
                    AppMetadataEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppMetadataTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppMetadataTableTable,
      AppMetadataEntry,
      $$AppMetadataTableTableFilterComposer,
      $$AppMetadataTableTableOrderingComposer,
      $$AppMetadataTableTableAnnotationComposer,
      $$AppMetadataTableTableCreateCompanionBuilder,
      $$AppMetadataTableTableUpdateCompanionBuilder,
      (
        AppMetadataEntry,
        BaseReferences<_$AppDatabase, $AppMetadataTableTable, AppMetadataEntry>,
      ),
      AppMetadataEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$IngredientsTableTableTableManager get ingredientsTable =>
      $$IngredientsTableTableTableManager(_db, _db.ingredientsTable);
  $$RecipesTableTableTableManager get recipesTable =>
      $$RecipesTableTableTableManager(_db, _db.recipesTable);
  $$RecipeIngredientsTableTableTableManager get recipeIngredientsTable =>
      $$RecipeIngredientsTableTableTableManager(
        _db,
        _db.recipeIngredientsTable,
      );
  $$KidProfilesTableTableTableManager get kidProfilesTable =>
      $$KidProfilesTableTableTableManager(_db, _db.kidProfilesTable);
  $$MealFeedbacksTableTableTableManager get mealFeedbacksTable =>
      $$MealFeedbacksTableTableTableManager(_db, _db.mealFeedbacksTable);
  $$GroceryItemsTableTableTableManager get groceryItemsTable =>
      $$GroceryItemsTableTableTableManager(_db, _db.groceryItemsTable);
  $$AppMetadataTableTableTableManager get appMetadataTable =>
      $$AppMetadataTableTableTableManager(_db, _db.appMetadataTable);
}
