// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UserSettingsTable extends UserSettings
    with TableInfo<$UserSettingsTable, UserSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearlyHolidayAllocationMeta =
      const VerificationMeta('yearlyHolidayAllocation');
  @override
  late final GeneratedColumn<int> yearlyHolidayAllocation =
      GeneratedColumn<int>(
        'yearly_holiday_allocation',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _yearlyWfhLimitMeta = const VerificationMeta(
    'yearlyWfhLimit',
  );
  @override
  late final GeneratedColumn<int> yearlyWfhLimit = GeneratedColumn<int>(
    'yearly_wfh_limit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(12),
  );
  static const VerificationMeta _monthlyWfhLimitMeta = const VerificationMeta(
    'monthlyWfhLimit',
  );
  @override
  late final GeneratedColumn<int> monthlyWfhLimit = GeneratedColumn<int>(
    'monthly_wfh_limit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _darkModeMeta = const VerificationMeta(
    'darkMode',
  );
  @override
  late final GeneratedColumn<bool> darkMode = GeneratedColumn<bool>(
    'dark_mode',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dark_mode" IN (0, 1))',
    ),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dailyTargetMinutesMeta =
      const VerificationMeta('dailyTargetMinutes');
  @override
  late final GeneratedColumn<int> dailyTargetMinutes = GeneratedColumn<int>(
    'daily_target_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(510),
  );
  static const VerificationMeta _weekendDaysMeta = const VerificationMeta(
    'weekendDays',
  );
  @override
  late final GeneratedColumn<String> weekendDays = GeneratedColumn<String>(
    'weekend_days',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('5,6'),
  );
  static const VerificationMeta _officeStartMinMeta = const VerificationMeta(
    'officeStartMin',
  );
  @override
  late final GeneratedColumn<int> officeStartMin = GeneratedColumn<int>(
    'office_start_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(570),
  );
  static const VerificationMeta _officeEndMinMeta = const VerificationMeta(
    'officeEndMin',
  );
  @override
  late final GeneratedColumn<int> officeEndMin = GeneratedColumn<int>(
    'office_end_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1080),
  );
  static const VerificationMeta _ramadanEnabledMeta = const VerificationMeta(
    'ramadanEnabled',
  );
  @override
  late final GeneratedColumn<bool> ramadanEnabled = GeneratedColumn<bool>(
    'ramadan_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ramadan_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _ramadanStartMinMeta = const VerificationMeta(
    'ramadanStartMin',
  );
  @override
  late final GeneratedColumn<int> ramadanStartMin = GeneratedColumn<int>(
    'ramadan_start_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(570),
  );
  static const VerificationMeta _ramadanEndMinMeta = const VerificationMeta(
    'ramadanEndMin',
  );
  @override
  late final GeneratedColumn<int> ramadanEndMin = GeneratedColumn<int>(
    'ramadan_end_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(930),
  );
  static const VerificationMeta _joinDateMeta = const VerificationMeta(
    'joinDate',
  );
  @override
  late final GeneratedColumn<DateTime> joinDate = GeneratedColumn<DateTime>(
    'join_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _biometricLockMeta = const VerificationMeta(
    'biometricLock',
  );
  @override
  late final GeneratedColumn<bool> biometricLock = GeneratedColumn<bool>(
    'biometric_lock',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("biometric_lock" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gender,
    yearlyHolidayAllocation,
    yearlyWfhLimit,
    monthlyWfhLimit,
    createdAt,
    darkMode,
    displayName,
    dailyTargetMinutes,
    weekendDays,
    officeStartMin,
    officeEndMin,
    ramadanEnabled,
    ramadanStartMin,
    ramadanEndMin,
    joinDate,
    biometricLock,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('yearly_holiday_allocation')) {
      context.handle(
        _yearlyHolidayAllocationMeta,
        yearlyHolidayAllocation.isAcceptableOrUnknown(
          data['yearly_holiday_allocation']!,
          _yearlyHolidayAllocationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_yearlyHolidayAllocationMeta);
    }
    if (data.containsKey('yearly_wfh_limit')) {
      context.handle(
        _yearlyWfhLimitMeta,
        yearlyWfhLimit.isAcceptableOrUnknown(
          data['yearly_wfh_limit']!,
          _yearlyWfhLimitMeta,
        ),
      );
    }
    if (data.containsKey('monthly_wfh_limit')) {
      context.handle(
        _monthlyWfhLimitMeta,
        monthlyWfhLimit.isAcceptableOrUnknown(
          data['monthly_wfh_limit']!,
          _monthlyWfhLimitMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('dark_mode')) {
      context.handle(
        _darkModeMeta,
        darkMode.isAcceptableOrUnknown(data['dark_mode']!, _darkModeMeta),
      );
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('daily_target_minutes')) {
      context.handle(
        _dailyTargetMinutesMeta,
        dailyTargetMinutes.isAcceptableOrUnknown(
          data['daily_target_minutes']!,
          _dailyTargetMinutesMeta,
        ),
      );
    }
    if (data.containsKey('weekend_days')) {
      context.handle(
        _weekendDaysMeta,
        weekendDays.isAcceptableOrUnknown(
          data['weekend_days']!,
          _weekendDaysMeta,
        ),
      );
    }
    if (data.containsKey('office_start_min')) {
      context.handle(
        _officeStartMinMeta,
        officeStartMin.isAcceptableOrUnknown(
          data['office_start_min']!,
          _officeStartMinMeta,
        ),
      );
    }
    if (data.containsKey('office_end_min')) {
      context.handle(
        _officeEndMinMeta,
        officeEndMin.isAcceptableOrUnknown(
          data['office_end_min']!,
          _officeEndMinMeta,
        ),
      );
    }
    if (data.containsKey('ramadan_enabled')) {
      context.handle(
        _ramadanEnabledMeta,
        ramadanEnabled.isAcceptableOrUnknown(
          data['ramadan_enabled']!,
          _ramadanEnabledMeta,
        ),
      );
    }
    if (data.containsKey('ramadan_start_min')) {
      context.handle(
        _ramadanStartMinMeta,
        ramadanStartMin.isAcceptableOrUnknown(
          data['ramadan_start_min']!,
          _ramadanStartMinMeta,
        ),
      );
    }
    if (data.containsKey('ramadan_end_min')) {
      context.handle(
        _ramadanEndMinMeta,
        ramadanEndMin.isAcceptableOrUnknown(
          data['ramadan_end_min']!,
          _ramadanEndMinMeta,
        ),
      );
    }
    if (data.containsKey('join_date')) {
      context.handle(
        _joinDateMeta,
        joinDate.isAcceptableOrUnknown(data['join_date']!, _joinDateMeta),
      );
    }
    if (data.containsKey('biometric_lock')) {
      context.handle(
        _biometricLockMeta,
        biometricLock.isAcceptableOrUnknown(
          data['biometric_lock']!,
          _biometricLockMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      )!,
      yearlyHolidayAllocation: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}yearly_holiday_allocation'],
      )!,
      yearlyWfhLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}yearly_wfh_limit'],
      )!,
      monthlyWfhLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_wfh_limit'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      darkMode: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dark_mode'],
      ),
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      dailyTargetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_target_minutes'],
      )!,
      weekendDays: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weekend_days'],
      )!,
      officeStartMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}office_start_min'],
      )!,
      officeEndMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}office_end_min'],
      )!,
      ramadanEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ramadan_enabled'],
      )!,
      ramadanStartMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ramadan_start_min'],
      )!,
      ramadanEndMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ramadan_end_min'],
      )!,
      joinDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}join_date'],
      ),
      biometricLock: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}biometric_lock'],
      )!,
    );
  }

  @override
  $UserSettingsTable createAlias(String alias) {
    return $UserSettingsTable(attachedDatabase, alias);
  }
}

class UserSetting extends DataClass implements Insertable<UserSetting> {
  final int id;
  final String gender;
  final int yearlyHolidayAllocation;
  final int yearlyWfhLimit;
  final int monthlyWfhLimit;
  final DateTime createdAt;
  final bool? darkMode;
  final String? displayName;
  final int dailyTargetMinutes;
  final String weekendDays;
  final int officeStartMin;
  final int officeEndMin;
  final bool ramadanEnabled;
  final int ramadanStartMin;
  final int ramadanEndMin;
  final DateTime? joinDate;
  final bool biometricLock;
  const UserSetting({
    required this.id,
    required this.gender,
    required this.yearlyHolidayAllocation,
    required this.yearlyWfhLimit,
    required this.monthlyWfhLimit,
    required this.createdAt,
    this.darkMode,
    this.displayName,
    required this.dailyTargetMinutes,
    required this.weekendDays,
    required this.officeStartMin,
    required this.officeEndMin,
    required this.ramadanEnabled,
    required this.ramadanStartMin,
    required this.ramadanEndMin,
    this.joinDate,
    required this.biometricLock,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['gender'] = Variable<String>(gender);
    map['yearly_holiday_allocation'] = Variable<int>(yearlyHolidayAllocation);
    map['yearly_wfh_limit'] = Variable<int>(yearlyWfhLimit);
    map['monthly_wfh_limit'] = Variable<int>(monthlyWfhLimit);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || darkMode != null) {
      map['dark_mode'] = Variable<bool>(darkMode);
    }
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    map['daily_target_minutes'] = Variable<int>(dailyTargetMinutes);
    map['weekend_days'] = Variable<String>(weekendDays);
    map['office_start_min'] = Variable<int>(officeStartMin);
    map['office_end_min'] = Variable<int>(officeEndMin);
    map['ramadan_enabled'] = Variable<bool>(ramadanEnabled);
    map['ramadan_start_min'] = Variable<int>(ramadanStartMin);
    map['ramadan_end_min'] = Variable<int>(ramadanEndMin);
    if (!nullToAbsent || joinDate != null) {
      map['join_date'] = Variable<DateTime>(joinDate);
    }
    map['biometric_lock'] = Variable<bool>(biometricLock);
    return map;
  }

  UserSettingsCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsCompanion(
      id: Value(id),
      gender: Value(gender),
      yearlyHolidayAllocation: Value(yearlyHolidayAllocation),
      yearlyWfhLimit: Value(yearlyWfhLimit),
      monthlyWfhLimit: Value(monthlyWfhLimit),
      createdAt: Value(createdAt),
      darkMode: darkMode == null && nullToAbsent
          ? const Value.absent()
          : Value(darkMode),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      dailyTargetMinutes: Value(dailyTargetMinutes),
      weekendDays: Value(weekendDays),
      officeStartMin: Value(officeStartMin),
      officeEndMin: Value(officeEndMin),
      ramadanEnabled: Value(ramadanEnabled),
      ramadanStartMin: Value(ramadanStartMin),
      ramadanEndMin: Value(ramadanEndMin),
      joinDate: joinDate == null && nullToAbsent
          ? const Value.absent()
          : Value(joinDate),
      biometricLock: Value(biometricLock),
    );
  }

  factory UserSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSetting(
      id: serializer.fromJson<int>(json['id']),
      gender: serializer.fromJson<String>(json['gender']),
      yearlyHolidayAllocation: serializer.fromJson<int>(
        json['yearlyHolidayAllocation'],
      ),
      yearlyWfhLimit: serializer.fromJson<int>(json['yearlyWfhLimit']),
      monthlyWfhLimit: serializer.fromJson<int>(json['monthlyWfhLimit']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      darkMode: serializer.fromJson<bool?>(json['darkMode']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      dailyTargetMinutes: serializer.fromJson<int>(json['dailyTargetMinutes']),
      weekendDays: serializer.fromJson<String>(json['weekendDays']),
      officeStartMin: serializer.fromJson<int>(json['officeStartMin']),
      officeEndMin: serializer.fromJson<int>(json['officeEndMin']),
      ramadanEnabled: serializer.fromJson<bool>(json['ramadanEnabled']),
      ramadanStartMin: serializer.fromJson<int>(json['ramadanStartMin']),
      ramadanEndMin: serializer.fromJson<int>(json['ramadanEndMin']),
      joinDate: serializer.fromJson<DateTime?>(json['joinDate']),
      biometricLock: serializer.fromJson<bool>(json['biometricLock']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gender': serializer.toJson<String>(gender),
      'yearlyHolidayAllocation': serializer.toJson<int>(
        yearlyHolidayAllocation,
      ),
      'yearlyWfhLimit': serializer.toJson<int>(yearlyWfhLimit),
      'monthlyWfhLimit': serializer.toJson<int>(monthlyWfhLimit),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'darkMode': serializer.toJson<bool?>(darkMode),
      'displayName': serializer.toJson<String?>(displayName),
      'dailyTargetMinutes': serializer.toJson<int>(dailyTargetMinutes),
      'weekendDays': serializer.toJson<String>(weekendDays),
      'officeStartMin': serializer.toJson<int>(officeStartMin),
      'officeEndMin': serializer.toJson<int>(officeEndMin),
      'ramadanEnabled': serializer.toJson<bool>(ramadanEnabled),
      'ramadanStartMin': serializer.toJson<int>(ramadanStartMin),
      'ramadanEndMin': serializer.toJson<int>(ramadanEndMin),
      'joinDate': serializer.toJson<DateTime?>(joinDate),
      'biometricLock': serializer.toJson<bool>(biometricLock),
    };
  }

  UserSetting copyWith({
    int? id,
    String? gender,
    int? yearlyHolidayAllocation,
    int? yearlyWfhLimit,
    int? monthlyWfhLimit,
    DateTime? createdAt,
    Value<bool?> darkMode = const Value.absent(),
    Value<String?> displayName = const Value.absent(),
    int? dailyTargetMinutes,
    String? weekendDays,
    int? officeStartMin,
    int? officeEndMin,
    bool? ramadanEnabled,
    int? ramadanStartMin,
    int? ramadanEndMin,
    Value<DateTime?> joinDate = const Value.absent(),
    bool? biometricLock,
  }) => UserSetting(
    id: id ?? this.id,
    gender: gender ?? this.gender,
    yearlyHolidayAllocation:
        yearlyHolidayAllocation ?? this.yearlyHolidayAllocation,
    yearlyWfhLimit: yearlyWfhLimit ?? this.yearlyWfhLimit,
    monthlyWfhLimit: monthlyWfhLimit ?? this.monthlyWfhLimit,
    createdAt: createdAt ?? this.createdAt,
    darkMode: darkMode.present ? darkMode.value : this.darkMode,
    displayName: displayName.present ? displayName.value : this.displayName,
    dailyTargetMinutes: dailyTargetMinutes ?? this.dailyTargetMinutes,
    weekendDays: weekendDays ?? this.weekendDays,
    officeStartMin: officeStartMin ?? this.officeStartMin,
    officeEndMin: officeEndMin ?? this.officeEndMin,
    ramadanEnabled: ramadanEnabled ?? this.ramadanEnabled,
    ramadanStartMin: ramadanStartMin ?? this.ramadanStartMin,
    ramadanEndMin: ramadanEndMin ?? this.ramadanEndMin,
    joinDate: joinDate.present ? joinDate.value : this.joinDate,
    biometricLock: biometricLock ?? this.biometricLock,
  );
  UserSetting copyWithCompanion(UserSettingsCompanion data) {
    return UserSetting(
      id: data.id.present ? data.id.value : this.id,
      gender: data.gender.present ? data.gender.value : this.gender,
      yearlyHolidayAllocation: data.yearlyHolidayAllocation.present
          ? data.yearlyHolidayAllocation.value
          : this.yearlyHolidayAllocation,
      yearlyWfhLimit: data.yearlyWfhLimit.present
          ? data.yearlyWfhLimit.value
          : this.yearlyWfhLimit,
      monthlyWfhLimit: data.monthlyWfhLimit.present
          ? data.monthlyWfhLimit.value
          : this.monthlyWfhLimit,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      darkMode: data.darkMode.present ? data.darkMode.value : this.darkMode,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      dailyTargetMinutes: data.dailyTargetMinutes.present
          ? data.dailyTargetMinutes.value
          : this.dailyTargetMinutes,
      weekendDays: data.weekendDays.present
          ? data.weekendDays.value
          : this.weekendDays,
      officeStartMin: data.officeStartMin.present
          ? data.officeStartMin.value
          : this.officeStartMin,
      officeEndMin: data.officeEndMin.present
          ? data.officeEndMin.value
          : this.officeEndMin,
      ramadanEnabled: data.ramadanEnabled.present
          ? data.ramadanEnabled.value
          : this.ramadanEnabled,
      ramadanStartMin: data.ramadanStartMin.present
          ? data.ramadanStartMin.value
          : this.ramadanStartMin,
      ramadanEndMin: data.ramadanEndMin.present
          ? data.ramadanEndMin.value
          : this.ramadanEndMin,
      joinDate: data.joinDate.present ? data.joinDate.value : this.joinDate,
      biometricLock: data.biometricLock.present
          ? data.biometricLock.value
          : this.biometricLock,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSetting(')
          ..write('id: $id, ')
          ..write('gender: $gender, ')
          ..write('yearlyHolidayAllocation: $yearlyHolidayAllocation, ')
          ..write('yearlyWfhLimit: $yearlyWfhLimit, ')
          ..write('monthlyWfhLimit: $monthlyWfhLimit, ')
          ..write('createdAt: $createdAt, ')
          ..write('darkMode: $darkMode, ')
          ..write('displayName: $displayName, ')
          ..write('dailyTargetMinutes: $dailyTargetMinutes, ')
          ..write('weekendDays: $weekendDays, ')
          ..write('officeStartMin: $officeStartMin, ')
          ..write('officeEndMin: $officeEndMin, ')
          ..write('ramadanEnabled: $ramadanEnabled, ')
          ..write('ramadanStartMin: $ramadanStartMin, ')
          ..write('ramadanEndMin: $ramadanEndMin, ')
          ..write('joinDate: $joinDate, ')
          ..write('biometricLock: $biometricLock')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    gender,
    yearlyHolidayAllocation,
    yearlyWfhLimit,
    monthlyWfhLimit,
    createdAt,
    darkMode,
    displayName,
    dailyTargetMinutes,
    weekendDays,
    officeStartMin,
    officeEndMin,
    ramadanEnabled,
    ramadanStartMin,
    ramadanEndMin,
    joinDate,
    biometricLock,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSetting &&
          other.id == this.id &&
          other.gender == this.gender &&
          other.yearlyHolidayAllocation == this.yearlyHolidayAllocation &&
          other.yearlyWfhLimit == this.yearlyWfhLimit &&
          other.monthlyWfhLimit == this.monthlyWfhLimit &&
          other.createdAt == this.createdAt &&
          other.darkMode == this.darkMode &&
          other.displayName == this.displayName &&
          other.dailyTargetMinutes == this.dailyTargetMinutes &&
          other.weekendDays == this.weekendDays &&
          other.officeStartMin == this.officeStartMin &&
          other.officeEndMin == this.officeEndMin &&
          other.ramadanEnabled == this.ramadanEnabled &&
          other.ramadanStartMin == this.ramadanStartMin &&
          other.ramadanEndMin == this.ramadanEndMin &&
          other.joinDate == this.joinDate &&
          other.biometricLock == this.biometricLock);
}

class UserSettingsCompanion extends UpdateCompanion<UserSetting> {
  final Value<int> id;
  final Value<String> gender;
  final Value<int> yearlyHolidayAllocation;
  final Value<int> yearlyWfhLimit;
  final Value<int> monthlyWfhLimit;
  final Value<DateTime> createdAt;
  final Value<bool?> darkMode;
  final Value<String?> displayName;
  final Value<int> dailyTargetMinutes;
  final Value<String> weekendDays;
  final Value<int> officeStartMin;
  final Value<int> officeEndMin;
  final Value<bool> ramadanEnabled;
  final Value<int> ramadanStartMin;
  final Value<int> ramadanEndMin;
  final Value<DateTime?> joinDate;
  final Value<bool> biometricLock;
  const UserSettingsCompanion({
    this.id = const Value.absent(),
    this.gender = const Value.absent(),
    this.yearlyHolidayAllocation = const Value.absent(),
    this.yearlyWfhLimit = const Value.absent(),
    this.monthlyWfhLimit = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.darkMode = const Value.absent(),
    this.displayName = const Value.absent(),
    this.dailyTargetMinutes = const Value.absent(),
    this.weekendDays = const Value.absent(),
    this.officeStartMin = const Value.absent(),
    this.officeEndMin = const Value.absent(),
    this.ramadanEnabled = const Value.absent(),
    this.ramadanStartMin = const Value.absent(),
    this.ramadanEndMin = const Value.absent(),
    this.joinDate = const Value.absent(),
    this.biometricLock = const Value.absent(),
  });
  UserSettingsCompanion.insert({
    this.id = const Value.absent(),
    required String gender,
    required int yearlyHolidayAllocation,
    this.yearlyWfhLimit = const Value.absent(),
    this.monthlyWfhLimit = const Value.absent(),
    required DateTime createdAt,
    this.darkMode = const Value.absent(),
    this.displayName = const Value.absent(),
    this.dailyTargetMinutes = const Value.absent(),
    this.weekendDays = const Value.absent(),
    this.officeStartMin = const Value.absent(),
    this.officeEndMin = const Value.absent(),
    this.ramadanEnabled = const Value.absent(),
    this.ramadanStartMin = const Value.absent(),
    this.ramadanEndMin = const Value.absent(),
    this.joinDate = const Value.absent(),
    this.biometricLock = const Value.absent(),
  }) : gender = Value(gender),
       yearlyHolidayAllocation = Value(yearlyHolidayAllocation),
       createdAt = Value(createdAt);
  static Insertable<UserSetting> custom({
    Expression<int>? id,
    Expression<String>? gender,
    Expression<int>? yearlyHolidayAllocation,
    Expression<int>? yearlyWfhLimit,
    Expression<int>? monthlyWfhLimit,
    Expression<DateTime>? createdAt,
    Expression<bool>? darkMode,
    Expression<String>? displayName,
    Expression<int>? dailyTargetMinutes,
    Expression<String>? weekendDays,
    Expression<int>? officeStartMin,
    Expression<int>? officeEndMin,
    Expression<bool>? ramadanEnabled,
    Expression<int>? ramadanStartMin,
    Expression<int>? ramadanEndMin,
    Expression<DateTime>? joinDate,
    Expression<bool>? biometricLock,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gender != null) 'gender': gender,
      if (yearlyHolidayAllocation != null)
        'yearly_holiday_allocation': yearlyHolidayAllocation,
      if (yearlyWfhLimit != null) 'yearly_wfh_limit': yearlyWfhLimit,
      if (monthlyWfhLimit != null) 'monthly_wfh_limit': monthlyWfhLimit,
      if (createdAt != null) 'created_at': createdAt,
      if (darkMode != null) 'dark_mode': darkMode,
      if (displayName != null) 'display_name': displayName,
      if (dailyTargetMinutes != null)
        'daily_target_minutes': dailyTargetMinutes,
      if (weekendDays != null) 'weekend_days': weekendDays,
      if (officeStartMin != null) 'office_start_min': officeStartMin,
      if (officeEndMin != null) 'office_end_min': officeEndMin,
      if (ramadanEnabled != null) 'ramadan_enabled': ramadanEnabled,
      if (ramadanStartMin != null) 'ramadan_start_min': ramadanStartMin,
      if (ramadanEndMin != null) 'ramadan_end_min': ramadanEndMin,
      if (joinDate != null) 'join_date': joinDate,
      if (biometricLock != null) 'biometric_lock': biometricLock,
    });
  }

  UserSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? gender,
    Value<int>? yearlyHolidayAllocation,
    Value<int>? yearlyWfhLimit,
    Value<int>? monthlyWfhLimit,
    Value<DateTime>? createdAt,
    Value<bool?>? darkMode,
    Value<String?>? displayName,
    Value<int>? dailyTargetMinutes,
    Value<String>? weekendDays,
    Value<int>? officeStartMin,
    Value<int>? officeEndMin,
    Value<bool>? ramadanEnabled,
    Value<int>? ramadanStartMin,
    Value<int>? ramadanEndMin,
    Value<DateTime?>? joinDate,
    Value<bool>? biometricLock,
  }) {
    return UserSettingsCompanion(
      id: id ?? this.id,
      gender: gender ?? this.gender,
      yearlyHolidayAllocation:
          yearlyHolidayAllocation ?? this.yearlyHolidayAllocation,
      yearlyWfhLimit: yearlyWfhLimit ?? this.yearlyWfhLimit,
      monthlyWfhLimit: monthlyWfhLimit ?? this.monthlyWfhLimit,
      createdAt: createdAt ?? this.createdAt,
      darkMode: darkMode ?? this.darkMode,
      displayName: displayName ?? this.displayName,
      dailyTargetMinutes: dailyTargetMinutes ?? this.dailyTargetMinutes,
      weekendDays: weekendDays ?? this.weekendDays,
      officeStartMin: officeStartMin ?? this.officeStartMin,
      officeEndMin: officeEndMin ?? this.officeEndMin,
      ramadanEnabled: ramadanEnabled ?? this.ramadanEnabled,
      ramadanStartMin: ramadanStartMin ?? this.ramadanStartMin,
      ramadanEndMin: ramadanEndMin ?? this.ramadanEndMin,
      joinDate: joinDate ?? this.joinDate,
      biometricLock: biometricLock ?? this.biometricLock,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (yearlyHolidayAllocation.present) {
      map['yearly_holiday_allocation'] = Variable<int>(
        yearlyHolidayAllocation.value,
      );
    }
    if (yearlyWfhLimit.present) {
      map['yearly_wfh_limit'] = Variable<int>(yearlyWfhLimit.value);
    }
    if (monthlyWfhLimit.present) {
      map['monthly_wfh_limit'] = Variable<int>(monthlyWfhLimit.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (darkMode.present) {
      map['dark_mode'] = Variable<bool>(darkMode.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (dailyTargetMinutes.present) {
      map['daily_target_minutes'] = Variable<int>(dailyTargetMinutes.value);
    }
    if (weekendDays.present) {
      map['weekend_days'] = Variable<String>(weekendDays.value);
    }
    if (officeStartMin.present) {
      map['office_start_min'] = Variable<int>(officeStartMin.value);
    }
    if (officeEndMin.present) {
      map['office_end_min'] = Variable<int>(officeEndMin.value);
    }
    if (ramadanEnabled.present) {
      map['ramadan_enabled'] = Variable<bool>(ramadanEnabled.value);
    }
    if (ramadanStartMin.present) {
      map['ramadan_start_min'] = Variable<int>(ramadanStartMin.value);
    }
    if (ramadanEndMin.present) {
      map['ramadan_end_min'] = Variable<int>(ramadanEndMin.value);
    }
    if (joinDate.present) {
      map['join_date'] = Variable<DateTime>(joinDate.value);
    }
    if (biometricLock.present) {
      map['biometric_lock'] = Variable<bool>(biometricLock.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsCompanion(')
          ..write('id: $id, ')
          ..write('gender: $gender, ')
          ..write('yearlyHolidayAllocation: $yearlyHolidayAllocation, ')
          ..write('yearlyWfhLimit: $yearlyWfhLimit, ')
          ..write('monthlyWfhLimit: $monthlyWfhLimit, ')
          ..write('createdAt: $createdAt, ')
          ..write('darkMode: $darkMode, ')
          ..write('displayName: $displayName, ')
          ..write('dailyTargetMinutes: $dailyTargetMinutes, ')
          ..write('weekendDays: $weekendDays, ')
          ..write('officeStartMin: $officeStartMin, ')
          ..write('officeEndMin: $officeEndMin, ')
          ..write('ramadanEnabled: $ramadanEnabled, ')
          ..write('ramadanStartMin: $ramadanStartMin, ')
          ..write('ramadanEndMin: $ramadanEndMin, ')
          ..write('joinDate: $joinDate, ')
          ..write('biometricLock: $biometricLock')
          ..write(')'))
        .toString();
  }
}

class $TimeLogsTable extends TimeLogs with TableInfo<$TimeLogsTable, TimeLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimeLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dayKeyMeta = const VerificationMeta('dayKey');
  @override
  late final GeneratedColumn<String> dayKey = GeneratedColumn<String>(
    'day_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clockInMeta = const VerificationMeta(
    'clockIn',
  );
  @override
  late final GeneratedColumn<DateTime> clockIn = GeneratedColumn<DateTime>(
    'clock_in',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clockOutMeta = const VerificationMeta(
    'clockOut',
  );
  @override
  late final GeneratedColumn<DateTime> clockOut = GeneratedColumn<DateTime>(
    'clock_out',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workModeMeta = const VerificationMeta(
    'workMode',
  );
  @override
  late final GeneratedColumn<String> workMode = GeneratedColumn<String>(
    'work_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _projectMeta = const VerificationMeta(
    'project',
  );
  @override
  late final GeneratedColumn<String> project = GeneratedColumn<String>(
    'project',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dayKey,
    clockIn,
    clockOut,
    workMode,
    note,
    project,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'time_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimeLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day_key')) {
      context.handle(
        _dayKeyMeta,
        dayKey.isAcceptableOrUnknown(data['day_key']!, _dayKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dayKeyMeta);
    }
    if (data.containsKey('clock_in')) {
      context.handle(
        _clockInMeta,
        clockIn.isAcceptableOrUnknown(data['clock_in']!, _clockInMeta),
      );
    } else if (isInserting) {
      context.missing(_clockInMeta);
    }
    if (data.containsKey('clock_out')) {
      context.handle(
        _clockOutMeta,
        clockOut.isAcceptableOrUnknown(data['clock_out']!, _clockOutMeta),
      );
    }
    if (data.containsKey('work_mode')) {
      context.handle(
        _workModeMeta,
        workMode.isAcceptableOrUnknown(data['work_mode']!, _workModeMeta),
      );
    } else if (isInserting) {
      context.missing(_workModeMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('project')) {
      context.handle(
        _projectMeta,
        project.isAcceptableOrUnknown(data['project']!, _projectMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimeLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimeLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_key'],
      )!,
      clockIn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}clock_in'],
      )!,
      clockOut: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}clock_out'],
      ),
      workMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_mode'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      project: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project'],
      ),
    );
  }

  @override
  $TimeLogsTable createAlias(String alias) {
    return $TimeLogsTable(attachedDatabase, alias);
  }
}

class TimeLog extends DataClass implements Insertable<TimeLog> {
  final int id;
  final String dayKey;
  final DateTime clockIn;
  final DateTime? clockOut;
  final String workMode;
  final String? note;
  final String? project;
  const TimeLog({
    required this.id,
    required this.dayKey,
    required this.clockIn,
    this.clockOut,
    required this.workMode,
    this.note,
    this.project,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day_key'] = Variable<String>(dayKey);
    map['clock_in'] = Variable<DateTime>(clockIn);
    if (!nullToAbsent || clockOut != null) {
      map['clock_out'] = Variable<DateTime>(clockOut);
    }
    map['work_mode'] = Variable<String>(workMode);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || project != null) {
      map['project'] = Variable<String>(project);
    }
    return map;
  }

  TimeLogsCompanion toCompanion(bool nullToAbsent) {
    return TimeLogsCompanion(
      id: Value(id),
      dayKey: Value(dayKey),
      clockIn: Value(clockIn),
      clockOut: clockOut == null && nullToAbsent
          ? const Value.absent()
          : Value(clockOut),
      workMode: Value(workMode),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      project: project == null && nullToAbsent
          ? const Value.absent()
          : Value(project),
    );
  }

  factory TimeLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimeLog(
      id: serializer.fromJson<int>(json['id']),
      dayKey: serializer.fromJson<String>(json['dayKey']),
      clockIn: serializer.fromJson<DateTime>(json['clockIn']),
      clockOut: serializer.fromJson<DateTime?>(json['clockOut']),
      workMode: serializer.fromJson<String>(json['workMode']),
      note: serializer.fromJson<String?>(json['note']),
      project: serializer.fromJson<String?>(json['project']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dayKey': serializer.toJson<String>(dayKey),
      'clockIn': serializer.toJson<DateTime>(clockIn),
      'clockOut': serializer.toJson<DateTime?>(clockOut),
      'workMode': serializer.toJson<String>(workMode),
      'note': serializer.toJson<String?>(note),
      'project': serializer.toJson<String?>(project),
    };
  }

  TimeLog copyWith({
    int? id,
    String? dayKey,
    DateTime? clockIn,
    Value<DateTime?> clockOut = const Value.absent(),
    String? workMode,
    Value<String?> note = const Value.absent(),
    Value<String?> project = const Value.absent(),
  }) => TimeLog(
    id: id ?? this.id,
    dayKey: dayKey ?? this.dayKey,
    clockIn: clockIn ?? this.clockIn,
    clockOut: clockOut.present ? clockOut.value : this.clockOut,
    workMode: workMode ?? this.workMode,
    note: note.present ? note.value : this.note,
    project: project.present ? project.value : this.project,
  );
  TimeLog copyWithCompanion(TimeLogsCompanion data) {
    return TimeLog(
      id: data.id.present ? data.id.value : this.id,
      dayKey: data.dayKey.present ? data.dayKey.value : this.dayKey,
      clockIn: data.clockIn.present ? data.clockIn.value : this.clockIn,
      clockOut: data.clockOut.present ? data.clockOut.value : this.clockOut,
      workMode: data.workMode.present ? data.workMode.value : this.workMode,
      note: data.note.present ? data.note.value : this.note,
      project: data.project.present ? data.project.value : this.project,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimeLog(')
          ..write('id: $id, ')
          ..write('dayKey: $dayKey, ')
          ..write('clockIn: $clockIn, ')
          ..write('clockOut: $clockOut, ')
          ..write('workMode: $workMode, ')
          ..write('note: $note, ')
          ..write('project: $project')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, dayKey, clockIn, clockOut, workMode, note, project);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimeLog &&
          other.id == this.id &&
          other.dayKey == this.dayKey &&
          other.clockIn == this.clockIn &&
          other.clockOut == this.clockOut &&
          other.workMode == this.workMode &&
          other.note == this.note &&
          other.project == this.project);
}

class TimeLogsCompanion extends UpdateCompanion<TimeLog> {
  final Value<int> id;
  final Value<String> dayKey;
  final Value<DateTime> clockIn;
  final Value<DateTime?> clockOut;
  final Value<String> workMode;
  final Value<String?> note;
  final Value<String?> project;
  const TimeLogsCompanion({
    this.id = const Value.absent(),
    this.dayKey = const Value.absent(),
    this.clockIn = const Value.absent(),
    this.clockOut = const Value.absent(),
    this.workMode = const Value.absent(),
    this.note = const Value.absent(),
    this.project = const Value.absent(),
  });
  TimeLogsCompanion.insert({
    this.id = const Value.absent(),
    required String dayKey,
    required DateTime clockIn,
    this.clockOut = const Value.absent(),
    required String workMode,
    this.note = const Value.absent(),
    this.project = const Value.absent(),
  }) : dayKey = Value(dayKey),
       clockIn = Value(clockIn),
       workMode = Value(workMode);
  static Insertable<TimeLog> custom({
    Expression<int>? id,
    Expression<String>? dayKey,
    Expression<DateTime>? clockIn,
    Expression<DateTime>? clockOut,
    Expression<String>? workMode,
    Expression<String>? note,
    Expression<String>? project,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayKey != null) 'day_key': dayKey,
      if (clockIn != null) 'clock_in': clockIn,
      if (clockOut != null) 'clock_out': clockOut,
      if (workMode != null) 'work_mode': workMode,
      if (note != null) 'note': note,
      if (project != null) 'project': project,
    });
  }

  TimeLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? dayKey,
    Value<DateTime>? clockIn,
    Value<DateTime?>? clockOut,
    Value<String>? workMode,
    Value<String?>? note,
    Value<String?>? project,
  }) {
    return TimeLogsCompanion(
      id: id ?? this.id,
      dayKey: dayKey ?? this.dayKey,
      clockIn: clockIn ?? this.clockIn,
      clockOut: clockOut ?? this.clockOut,
      workMode: workMode ?? this.workMode,
      note: note ?? this.note,
      project: project ?? this.project,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dayKey.present) {
      map['day_key'] = Variable<String>(dayKey.value);
    }
    if (clockIn.present) {
      map['clock_in'] = Variable<DateTime>(clockIn.value);
    }
    if (clockOut.present) {
      map['clock_out'] = Variable<DateTime>(clockOut.value);
    }
    if (workMode.present) {
      map['work_mode'] = Variable<String>(workMode.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (project.present) {
      map['project'] = Variable<String>(project.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimeLogsCompanion(')
          ..write('id: $id, ')
          ..write('dayKey: $dayKey, ')
          ..write('clockIn: $clockIn, ')
          ..write('clockOut: $clockOut, ')
          ..write('workMode: $workMode, ')
          ..write('note: $note, ')
          ..write('project: $project')
          ..write(')'))
        .toString();
  }
}

class $LeaveLogsTable extends LeaveLogs
    with TableInfo<$LeaveLogsTable, LeaveLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeaveLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dayKeyMeta = const VerificationMeta('dayKey');
  @override
  late final GeneratedColumn<String> dayKey = GeneratedColumn<String>(
    'day_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, dayKey, type, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leave_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<LeaveLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day_key')) {
      context.handle(
        _dayKeyMeta,
        dayKey.isAcceptableOrUnknown(data['day_key']!, _dayKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dayKeyMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LeaveLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LeaveLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_key'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $LeaveLogsTable createAlias(String alias) {
    return $LeaveLogsTable(attachedDatabase, alias);
  }
}

class LeaveLog extends DataClass implements Insertable<LeaveLog> {
  final int id;
  final String dayKey;
  final String type;
  final String? note;
  const LeaveLog({
    required this.id,
    required this.dayKey,
    required this.type,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day_key'] = Variable<String>(dayKey);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  LeaveLogsCompanion toCompanion(bool nullToAbsent) {
    return LeaveLogsCompanion(
      id: Value(id),
      dayKey: Value(dayKey),
      type: Value(type),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory LeaveLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LeaveLog(
      id: serializer.fromJson<int>(json['id']),
      dayKey: serializer.fromJson<String>(json['dayKey']),
      type: serializer.fromJson<String>(json['type']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dayKey': serializer.toJson<String>(dayKey),
      'type': serializer.toJson<String>(type),
      'note': serializer.toJson<String?>(note),
    };
  }

  LeaveLog copyWith({
    int? id,
    String? dayKey,
    String? type,
    Value<String?> note = const Value.absent(),
  }) => LeaveLog(
    id: id ?? this.id,
    dayKey: dayKey ?? this.dayKey,
    type: type ?? this.type,
    note: note.present ? note.value : this.note,
  );
  LeaveLog copyWithCompanion(LeaveLogsCompanion data) {
    return LeaveLog(
      id: data.id.present ? data.id.value : this.id,
      dayKey: data.dayKey.present ? data.dayKey.value : this.dayKey,
      type: data.type.present ? data.type.value : this.type,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LeaveLog(')
          ..write('id: $id, ')
          ..write('dayKey: $dayKey, ')
          ..write('type: $type, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dayKey, type, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LeaveLog &&
          other.id == this.id &&
          other.dayKey == this.dayKey &&
          other.type == this.type &&
          other.note == this.note);
}

class LeaveLogsCompanion extends UpdateCompanion<LeaveLog> {
  final Value<int> id;
  final Value<String> dayKey;
  final Value<String> type;
  final Value<String?> note;
  const LeaveLogsCompanion({
    this.id = const Value.absent(),
    this.dayKey = const Value.absent(),
    this.type = const Value.absent(),
    this.note = const Value.absent(),
  });
  LeaveLogsCompanion.insert({
    this.id = const Value.absent(),
    required String dayKey,
    required String type,
    this.note = const Value.absent(),
  }) : dayKey = Value(dayKey),
       type = Value(type);
  static Insertable<LeaveLog> custom({
    Expression<int>? id,
    Expression<String>? dayKey,
    Expression<String>? type,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayKey != null) 'day_key': dayKey,
      if (type != null) 'type': type,
      if (note != null) 'note': note,
    });
  }

  LeaveLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? dayKey,
    Value<String>? type,
    Value<String?>? note,
  }) {
    return LeaveLogsCompanion(
      id: id ?? this.id,
      dayKey: dayKey ?? this.dayKey,
      type: type ?? this.type,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dayKey.present) {
      map['day_key'] = Variable<String>(dayKey.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeaveLogsCompanion(')
          ..write('id: $id, ')
          ..write('dayKey: $dayKey, ')
          ..write('type: $type, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $DayOverridesTable extends DayOverrides
    with TableInfo<$DayOverridesTable, DayOverride> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DayOverridesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dayKeyMeta = const VerificationMeta('dayKey');
  @override
  late final GeneratedColumn<String> dayKey = GeneratedColumn<String>(
    'day_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [dayKey, type];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'day_overrides';
  @override
  VerificationContext validateIntegrity(
    Insertable<DayOverride> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('day_key')) {
      context.handle(
        _dayKeyMeta,
        dayKey.isAcceptableOrUnknown(data['day_key']!, _dayKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dayKeyMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dayKey};
  @override
  DayOverride map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DayOverride(
      dayKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_key'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
    );
  }

  @override
  $DayOverridesTable createAlias(String alias) {
    return $DayOverridesTable(attachedDatabase, alias);
  }
}

class DayOverride extends DataClass implements Insertable<DayOverride> {
  final String dayKey;
  final String type;
  const DayOverride({required this.dayKey, required this.type});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day_key'] = Variable<String>(dayKey);
    map['type'] = Variable<String>(type);
    return map;
  }

  DayOverridesCompanion toCompanion(bool nullToAbsent) {
    return DayOverridesCompanion(dayKey: Value(dayKey), type: Value(type));
  }

  factory DayOverride.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DayOverride(
      dayKey: serializer.fromJson<String>(json['dayKey']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dayKey': serializer.toJson<String>(dayKey),
      'type': serializer.toJson<String>(type),
    };
  }

  DayOverride copyWith({String? dayKey, String? type}) =>
      DayOverride(dayKey: dayKey ?? this.dayKey, type: type ?? this.type);
  DayOverride copyWithCompanion(DayOverridesCompanion data) {
    return DayOverride(
      dayKey: data.dayKey.present ? data.dayKey.value : this.dayKey,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DayOverride(')
          ..write('dayKey: $dayKey, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(dayKey, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DayOverride &&
          other.dayKey == this.dayKey &&
          other.type == this.type);
}

class DayOverridesCompanion extends UpdateCompanion<DayOverride> {
  final Value<String> dayKey;
  final Value<String> type;
  final Value<int> rowid;
  const DayOverridesCompanion({
    this.dayKey = const Value.absent(),
    this.type = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DayOverridesCompanion.insert({
    required String dayKey,
    required String type,
    this.rowid = const Value.absent(),
  }) : dayKey = Value(dayKey),
       type = Value(type);
  static Insertable<DayOverride> custom({
    Expression<String>? dayKey,
    Expression<String>? type,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (dayKey != null) 'day_key': dayKey,
      if (type != null) 'type': type,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DayOverridesCompanion copyWith({
    Value<String>? dayKey,
    Value<String>? type,
    Value<int>? rowid,
  }) {
    return DayOverridesCompanion(
      dayKey: dayKey ?? this.dayKey,
      type: type ?? this.type,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dayKey.present) {
      map['day_key'] = Variable<String>(dayKey.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DayOverridesCompanion(')
          ..write('dayKey: $dayKey, ')
          ..write('type: $type, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LeaveRecordsTable extends LeaveRecords
    with TableInfo<$LeaveRecordsTable, LeaveRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeaveRecordsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _leaveTypeMeta = const VerificationMeta(
    'leaveType',
  );
  @override
  late final GeneratedColumn<String> leaveType = GeneratedColumn<String>(
    'leave_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<String> duration = GeneratedColumn<String>(
    'duration',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _daysConsumedMeta = const VerificationMeta(
    'daysConsumed',
  );
  @override
  late final GeneratedColumn<double> daysConsumed = GeneratedColumn<double>(
    'days_consumed',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _appliedOnMeta = const VerificationMeta(
    'appliedOn',
  );
  @override
  late final GeneratedColumn<DateTime> appliedOn = GeneratedColumn<DateTime>(
    'applied_on',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    leaveType,
    startDate,
    endDate,
    duration,
    daysConsumed,
    reason,
    appliedOn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leave_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<LeaveRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('leave_type')) {
      context.handle(
        _leaveTypeMeta,
        leaveType.isAcceptableOrUnknown(data['leave_type']!, _leaveTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_leaveTypeMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    if (data.containsKey('days_consumed')) {
      context.handle(
        _daysConsumedMeta,
        daysConsumed.isAcceptableOrUnknown(
          data['days_consumed']!,
          _daysConsumedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_daysConsumedMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('applied_on')) {
      context.handle(
        _appliedOnMeta,
        appliedOn.isAcceptableOrUnknown(data['applied_on']!, _appliedOnMeta),
      );
    } else if (isInserting) {
      context.missing(_appliedOnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LeaveRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LeaveRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      leaveType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}leave_type'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}duration'],
      )!,
      daysConsumed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}days_consumed'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
      appliedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}applied_on'],
      )!,
    );
  }

  @override
  $LeaveRecordsTable createAlias(String alias) {
    return $LeaveRecordsTable(attachedDatabase, alias);
  }
}

class LeaveRecord extends DataClass implements Insertable<LeaveRecord> {
  final int id;
  final String leaveType;
  final DateTime startDate;
  final DateTime endDate;
  final String duration;
  final double daysConsumed;
  final String? reason;
  final DateTime appliedOn;
  const LeaveRecord({
    required this.id,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.daysConsumed,
    this.reason,
    required this.appliedOn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['leave_type'] = Variable<String>(leaveType);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['duration'] = Variable<String>(duration);
    map['days_consumed'] = Variable<double>(daysConsumed);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    map['applied_on'] = Variable<DateTime>(appliedOn);
    return map;
  }

  LeaveRecordsCompanion toCompanion(bool nullToAbsent) {
    return LeaveRecordsCompanion(
      id: Value(id),
      leaveType: Value(leaveType),
      startDate: Value(startDate),
      endDate: Value(endDate),
      duration: Value(duration),
      daysConsumed: Value(daysConsumed),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      appliedOn: Value(appliedOn),
    );
  }

  factory LeaveRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LeaveRecord(
      id: serializer.fromJson<int>(json['id']),
      leaveType: serializer.fromJson<String>(json['leaveType']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      duration: serializer.fromJson<String>(json['duration']),
      daysConsumed: serializer.fromJson<double>(json['daysConsumed']),
      reason: serializer.fromJson<String?>(json['reason']),
      appliedOn: serializer.fromJson<DateTime>(json['appliedOn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'leaveType': serializer.toJson<String>(leaveType),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'duration': serializer.toJson<String>(duration),
      'daysConsumed': serializer.toJson<double>(daysConsumed),
      'reason': serializer.toJson<String?>(reason),
      'appliedOn': serializer.toJson<DateTime>(appliedOn),
    };
  }

  LeaveRecord copyWith({
    int? id,
    String? leaveType,
    DateTime? startDate,
    DateTime? endDate,
    String? duration,
    double? daysConsumed,
    Value<String?> reason = const Value.absent(),
    DateTime? appliedOn,
  }) => LeaveRecord(
    id: id ?? this.id,
    leaveType: leaveType ?? this.leaveType,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    duration: duration ?? this.duration,
    daysConsumed: daysConsumed ?? this.daysConsumed,
    reason: reason.present ? reason.value : this.reason,
    appliedOn: appliedOn ?? this.appliedOn,
  );
  LeaveRecord copyWithCompanion(LeaveRecordsCompanion data) {
    return LeaveRecord(
      id: data.id.present ? data.id.value : this.id,
      leaveType: data.leaveType.present ? data.leaveType.value : this.leaveType,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      duration: data.duration.present ? data.duration.value : this.duration,
      daysConsumed: data.daysConsumed.present
          ? data.daysConsumed.value
          : this.daysConsumed,
      reason: data.reason.present ? data.reason.value : this.reason,
      appliedOn: data.appliedOn.present ? data.appliedOn.value : this.appliedOn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LeaveRecord(')
          ..write('id: $id, ')
          ..write('leaveType: $leaveType, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('duration: $duration, ')
          ..write('daysConsumed: $daysConsumed, ')
          ..write('reason: $reason, ')
          ..write('appliedOn: $appliedOn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    leaveType,
    startDate,
    endDate,
    duration,
    daysConsumed,
    reason,
    appliedOn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LeaveRecord &&
          other.id == this.id &&
          other.leaveType == this.leaveType &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.duration == this.duration &&
          other.daysConsumed == this.daysConsumed &&
          other.reason == this.reason &&
          other.appliedOn == this.appliedOn);
}

class LeaveRecordsCompanion extends UpdateCompanion<LeaveRecord> {
  final Value<int> id;
  final Value<String> leaveType;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<String> duration;
  final Value<double> daysConsumed;
  final Value<String?> reason;
  final Value<DateTime> appliedOn;
  const LeaveRecordsCompanion({
    this.id = const Value.absent(),
    this.leaveType = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.duration = const Value.absent(),
    this.daysConsumed = const Value.absent(),
    this.reason = const Value.absent(),
    this.appliedOn = const Value.absent(),
  });
  LeaveRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String duration,
    required double daysConsumed,
    this.reason = const Value.absent(),
    required DateTime appliedOn,
  }) : leaveType = Value(leaveType),
       startDate = Value(startDate),
       endDate = Value(endDate),
       duration = Value(duration),
       daysConsumed = Value(daysConsumed),
       appliedOn = Value(appliedOn);
  static Insertable<LeaveRecord> custom({
    Expression<int>? id,
    Expression<String>? leaveType,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? duration,
    Expression<double>? daysConsumed,
    Expression<String>? reason,
    Expression<DateTime>? appliedOn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (leaveType != null) 'leave_type': leaveType,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (duration != null) 'duration': duration,
      if (daysConsumed != null) 'days_consumed': daysConsumed,
      if (reason != null) 'reason': reason,
      if (appliedOn != null) 'applied_on': appliedOn,
    });
  }

  LeaveRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? leaveType,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<String>? duration,
    Value<double>? daysConsumed,
    Value<String?>? reason,
    Value<DateTime>? appliedOn,
  }) {
    return LeaveRecordsCompanion(
      id: id ?? this.id,
      leaveType: leaveType ?? this.leaveType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      duration: duration ?? this.duration,
      daysConsumed: daysConsumed ?? this.daysConsumed,
      reason: reason ?? this.reason,
      appliedOn: appliedOn ?? this.appliedOn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (leaveType.present) {
      map['leave_type'] = Variable<String>(leaveType.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (duration.present) {
      map['duration'] = Variable<String>(duration.value);
    }
    if (daysConsumed.present) {
      map['days_consumed'] = Variable<double>(daysConsumed.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (appliedOn.present) {
      map['applied_on'] = Variable<DateTime>(appliedOn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeaveRecordsCompanion(')
          ..write('id: $id, ')
          ..write('leaveType: $leaveType, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('duration: $duration, ')
          ..write('daysConsumed: $daysConsumed, ')
          ..write('reason: $reason, ')
          ..write('appliedOn: $appliedOn')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _checklistMeta = const VerificationMeta(
    'checklist',
  );
  @override
  late final GeneratedColumn<String> checklist = GeneratedColumn<String>(
    'checklist',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _pinnedMeta = const VerificationMeta('pinned');
  @override
  late final GeneratedColumn<bool> pinned = GeneratedColumn<bool>(
    'pinned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pinned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    date,
    title,
    body,
    tags,
    checklist,
    pinned,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Note> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('checklist')) {
      context.handle(
        _checklistMeta,
        checklist.isAcceptableOrUnknown(data['checklist']!, _checklistMeta),
      );
    }
    if (data.containsKey('pinned')) {
      context.handle(
        _pinnedMeta,
        pinned.isAcceptableOrUnknown(data['pinned']!, _pinnedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Note map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Note(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      checklist: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checklist'],
      )!,
      pinned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pinned'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class Note extends DataClass implements Insertable<Note> {
  final int id;
  final String kind;
  final DateTime date;
  final String title;
  final String body;
  final String tags;
  final String checklist;
  final bool pinned;
  final DateTime updatedAt;
  const Note({
    required this.id,
    required this.kind,
    required this.date,
    required this.title,
    required this.body,
    required this.tags,
    required this.checklist,
    required this.pinned,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kind'] = Variable<String>(kind);
    map['date'] = Variable<DateTime>(date);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['tags'] = Variable<String>(tags);
    map['checklist'] = Variable<String>(checklist);
    map['pinned'] = Variable<bool>(pinned);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      kind: Value(kind),
      date: Value(date),
      title: Value(title),
      body: Value(body),
      tags: Value(tags),
      checklist: Value(checklist),
      pinned: Value(pinned),
      updatedAt: Value(updatedAt),
    );
  }

  factory Note.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Note(
      id: serializer.fromJson<int>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      date: serializer.fromJson<DateTime>(json['date']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      tags: serializer.fromJson<String>(json['tags']),
      checklist: serializer.fromJson<String>(json['checklist']),
      pinned: serializer.fromJson<bool>(json['pinned']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>(kind),
      'date': serializer.toJson<DateTime>(date),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'tags': serializer.toJson<String>(tags),
      'checklist': serializer.toJson<String>(checklist),
      'pinned': serializer.toJson<bool>(pinned),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Note copyWith({
    int? id,
    String? kind,
    DateTime? date,
    String? title,
    String? body,
    String? tags,
    String? checklist,
    bool? pinned,
    DateTime? updatedAt,
  }) => Note(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    date: date ?? this.date,
    title: title ?? this.title,
    body: body ?? this.body,
    tags: tags ?? this.tags,
    checklist: checklist ?? this.checklist,
    pinned: pinned ?? this.pinned,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Note copyWithCompanion(NotesCompanion data) {
    return Note(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      date: data.date.present ? data.date.value : this.date,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      tags: data.tags.present ? data.tags.value : this.tags,
      checklist: data.checklist.present ? data.checklist.value : this.checklist,
      pinned: data.pinned.present ? data.pinned.value : this.pinned,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('date: $date, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('tags: $tags, ')
          ..write('checklist: $checklist, ')
          ..write('pinned: $pinned, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    date,
    title,
    body,
    tags,
    checklist,
    pinned,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.date == this.date &&
          other.title == this.title &&
          other.body == this.body &&
          other.tags == this.tags &&
          other.checklist == this.checklist &&
          other.pinned == this.pinned &&
          other.updatedAt == this.updatedAt);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<int> id;
  final Value<String> kind;
  final Value<DateTime> date;
  final Value<String> title;
  final Value<String> body;
  final Value<String> tags;
  final Value<String> checklist;
  final Value<bool> pinned;
  final Value<DateTime> updatedAt;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.date = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.tags = const Value.absent(),
    this.checklist = const Value.absent(),
    this.pinned = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  NotesCompanion.insert({
    this.id = const Value.absent(),
    required String kind,
    required DateTime date,
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.tags = const Value.absent(),
    this.checklist = const Value.absent(),
    this.pinned = const Value.absent(),
    required DateTime updatedAt,
  }) : kind = Value(kind),
       date = Value(date),
       updatedAt = Value(updatedAt);
  static Insertable<Note> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<DateTime>? date,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? tags,
    Expression<String>? checklist,
    Expression<bool>? pinned,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (date != null) 'date': date,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (tags != null) 'tags': tags,
      if (checklist != null) 'checklist': checklist,
      if (pinned != null) 'pinned': pinned,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  NotesCompanion copyWith({
    Value<int>? id,
    Value<String>? kind,
    Value<DateTime>? date,
    Value<String>? title,
    Value<String>? body,
    Value<String>? tags,
    Value<String>? checklist,
    Value<bool>? pinned,
    Value<DateTime>? updatedAt,
  }) {
    return NotesCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      date: date ?? this.date,
      title: title ?? this.title,
      body: body ?? this.body,
      tags: tags ?? this.tags,
      checklist: checklist ?? this.checklist,
      pinned: pinned ?? this.pinned,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (checklist.present) {
      map['checklist'] = Variable<String>(checklist.value);
    }
    if (pinned.present) {
      map['pinned'] = Variable<bool>(pinned.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('date: $date, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('tags: $tags, ')
          ..write('checklist: $checklist, ')
          ..write('pinned: $pinned, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserSettingsTable userSettings = $UserSettingsTable(this);
  late final $TimeLogsTable timeLogs = $TimeLogsTable(this);
  late final $LeaveLogsTable leaveLogs = $LeaveLogsTable(this);
  late final $DayOverridesTable dayOverrides = $DayOverridesTable(this);
  late final $LeaveRecordsTable leaveRecords = $LeaveRecordsTable(this);
  late final $NotesTable notes = $NotesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userSettings,
    timeLogs,
    leaveLogs,
    dayOverrides,
    leaveRecords,
    notes,
  ];
}

typedef $$UserSettingsTableCreateCompanionBuilder =
    UserSettingsCompanion Function({
      Value<int> id,
      required String gender,
      required int yearlyHolidayAllocation,
      Value<int> yearlyWfhLimit,
      Value<int> monthlyWfhLimit,
      required DateTime createdAt,
      Value<bool?> darkMode,
      Value<String?> displayName,
      Value<int> dailyTargetMinutes,
      Value<String> weekendDays,
      Value<int> officeStartMin,
      Value<int> officeEndMin,
      Value<bool> ramadanEnabled,
      Value<int> ramadanStartMin,
      Value<int> ramadanEndMin,
      Value<DateTime?> joinDate,
      Value<bool> biometricLock,
    });
typedef $$UserSettingsTableUpdateCompanionBuilder =
    UserSettingsCompanion Function({
      Value<int> id,
      Value<String> gender,
      Value<int> yearlyHolidayAllocation,
      Value<int> yearlyWfhLimit,
      Value<int> monthlyWfhLimit,
      Value<DateTime> createdAt,
      Value<bool?> darkMode,
      Value<String?> displayName,
      Value<int> dailyTargetMinutes,
      Value<String> weekendDays,
      Value<int> officeStartMin,
      Value<int> officeEndMin,
      Value<bool> ramadanEnabled,
      Value<int> ramadanStartMin,
      Value<int> ramadanEndMin,
      Value<DateTime?> joinDate,
      Value<bool> biometricLock,
    });

class $$UserSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableFilterComposer({
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

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get yearlyHolidayAllocation => $composableBuilder(
    column: $table.yearlyHolidayAllocation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get yearlyWfhLimit => $composableBuilder(
    column: $table.yearlyWfhLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyWfhLimit => $composableBuilder(
    column: $table.monthlyWfhLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get darkMode => $composableBuilder(
    column: $table.darkMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyTargetMinutes => $composableBuilder(
    column: $table.dailyTargetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weekendDays => $composableBuilder(
    column: $table.weekendDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get officeStartMin => $composableBuilder(
    column: $table.officeStartMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get officeEndMin => $composableBuilder(
    column: $table.officeEndMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ramadanEnabled => $composableBuilder(
    column: $table.ramadanEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ramadanStartMin => $composableBuilder(
    column: $table.ramadanStartMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ramadanEndMin => $composableBuilder(
    column: $table.ramadanEndMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get joinDate => $composableBuilder(
    column: $table.joinDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get biometricLock => $composableBuilder(
    column: $table.biometricLock,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableOrderingComposer({
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

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get yearlyHolidayAllocation => $composableBuilder(
    column: $table.yearlyHolidayAllocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get yearlyWfhLimit => $composableBuilder(
    column: $table.yearlyWfhLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyWfhLimit => $composableBuilder(
    column: $table.monthlyWfhLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get darkMode => $composableBuilder(
    column: $table.darkMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyTargetMinutes => $composableBuilder(
    column: $table.dailyTargetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weekendDays => $composableBuilder(
    column: $table.weekendDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get officeStartMin => $composableBuilder(
    column: $table.officeStartMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get officeEndMin => $composableBuilder(
    column: $table.officeEndMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ramadanEnabled => $composableBuilder(
    column: $table.ramadanEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ramadanStartMin => $composableBuilder(
    column: $table.ramadanStartMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ramadanEndMin => $composableBuilder(
    column: $table.ramadanEndMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get joinDate => $composableBuilder(
    column: $table.joinDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get biometricLock => $composableBuilder(
    column: $table.biometricLock,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<int> get yearlyHolidayAllocation => $composableBuilder(
    column: $table.yearlyHolidayAllocation,
    builder: (column) => column,
  );

  GeneratedColumn<int> get yearlyWfhLimit => $composableBuilder(
    column: $table.yearlyWfhLimit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get monthlyWfhLimit => $composableBuilder(
    column: $table.monthlyWfhLimit,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get darkMode =>
      $composableBuilder(column: $table.darkMode, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyTargetMinutes => $composableBuilder(
    column: $table.dailyTargetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get weekendDays => $composableBuilder(
    column: $table.weekendDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get officeStartMin => $composableBuilder(
    column: $table.officeStartMin,
    builder: (column) => column,
  );

  GeneratedColumn<int> get officeEndMin => $composableBuilder(
    column: $table.officeEndMin,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get ramadanEnabled => $composableBuilder(
    column: $table.ramadanEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ramadanStartMin => $composableBuilder(
    column: $table.ramadanStartMin,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ramadanEndMin => $composableBuilder(
    column: $table.ramadanEndMin,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get joinDate =>
      $composableBuilder(column: $table.joinDate, builder: (column) => column);

  GeneratedColumn<bool> get biometricLock => $composableBuilder(
    column: $table.biometricLock,
    builder: (column) => column,
  );
}

class $$UserSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserSettingsTable,
          UserSetting,
          $$UserSettingsTableFilterComposer,
          $$UserSettingsTableOrderingComposer,
          $$UserSettingsTableAnnotationComposer,
          $$UserSettingsTableCreateCompanionBuilder,
          $$UserSettingsTableUpdateCompanionBuilder,
          (
            UserSetting,
            BaseReferences<_$AppDatabase, $UserSettingsTable, UserSetting>,
          ),
          UserSetting,
          PrefetchHooks Function()
        > {
  $$UserSettingsTableTableManager(_$AppDatabase db, $UserSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> gender = const Value.absent(),
                Value<int> yearlyHolidayAllocation = const Value.absent(),
                Value<int> yearlyWfhLimit = const Value.absent(),
                Value<int> monthlyWfhLimit = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool?> darkMode = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<int> dailyTargetMinutes = const Value.absent(),
                Value<String> weekendDays = const Value.absent(),
                Value<int> officeStartMin = const Value.absent(),
                Value<int> officeEndMin = const Value.absent(),
                Value<bool> ramadanEnabled = const Value.absent(),
                Value<int> ramadanStartMin = const Value.absent(),
                Value<int> ramadanEndMin = const Value.absent(),
                Value<DateTime?> joinDate = const Value.absent(),
                Value<bool> biometricLock = const Value.absent(),
              }) => UserSettingsCompanion(
                id: id,
                gender: gender,
                yearlyHolidayAllocation: yearlyHolidayAllocation,
                yearlyWfhLimit: yearlyWfhLimit,
                monthlyWfhLimit: monthlyWfhLimit,
                createdAt: createdAt,
                darkMode: darkMode,
                displayName: displayName,
                dailyTargetMinutes: dailyTargetMinutes,
                weekendDays: weekendDays,
                officeStartMin: officeStartMin,
                officeEndMin: officeEndMin,
                ramadanEnabled: ramadanEnabled,
                ramadanStartMin: ramadanStartMin,
                ramadanEndMin: ramadanEndMin,
                joinDate: joinDate,
                biometricLock: biometricLock,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String gender,
                required int yearlyHolidayAllocation,
                Value<int> yearlyWfhLimit = const Value.absent(),
                Value<int> monthlyWfhLimit = const Value.absent(),
                required DateTime createdAt,
                Value<bool?> darkMode = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<int> dailyTargetMinutes = const Value.absent(),
                Value<String> weekendDays = const Value.absent(),
                Value<int> officeStartMin = const Value.absent(),
                Value<int> officeEndMin = const Value.absent(),
                Value<bool> ramadanEnabled = const Value.absent(),
                Value<int> ramadanStartMin = const Value.absent(),
                Value<int> ramadanEndMin = const Value.absent(),
                Value<DateTime?> joinDate = const Value.absent(),
                Value<bool> biometricLock = const Value.absent(),
              }) => UserSettingsCompanion.insert(
                id: id,
                gender: gender,
                yearlyHolidayAllocation: yearlyHolidayAllocation,
                yearlyWfhLimit: yearlyWfhLimit,
                monthlyWfhLimit: monthlyWfhLimit,
                createdAt: createdAt,
                darkMode: darkMode,
                displayName: displayName,
                dailyTargetMinutes: dailyTargetMinutes,
                weekendDays: weekendDays,
                officeStartMin: officeStartMin,
                officeEndMin: officeEndMin,
                ramadanEnabled: ramadanEnabled,
                ramadanStartMin: ramadanStartMin,
                ramadanEndMin: ramadanEndMin,
                joinDate: joinDate,
                biometricLock: biometricLock,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserSettingsTable,
      UserSetting,
      $$UserSettingsTableFilterComposer,
      $$UserSettingsTableOrderingComposer,
      $$UserSettingsTableAnnotationComposer,
      $$UserSettingsTableCreateCompanionBuilder,
      $$UserSettingsTableUpdateCompanionBuilder,
      (
        UserSetting,
        BaseReferences<_$AppDatabase, $UserSettingsTable, UserSetting>,
      ),
      UserSetting,
      PrefetchHooks Function()
    >;
typedef $$TimeLogsTableCreateCompanionBuilder =
    TimeLogsCompanion Function({
      Value<int> id,
      required String dayKey,
      required DateTime clockIn,
      Value<DateTime?> clockOut,
      required String workMode,
      Value<String?> note,
      Value<String?> project,
    });
typedef $$TimeLogsTableUpdateCompanionBuilder =
    TimeLogsCompanion Function({
      Value<int> id,
      Value<String> dayKey,
      Value<DateTime> clockIn,
      Value<DateTime?> clockOut,
      Value<String> workMode,
      Value<String?> note,
      Value<String?> project,
    });

class $$TimeLogsTableFilterComposer
    extends Composer<_$AppDatabase, $TimeLogsTable> {
  $$TimeLogsTableFilterComposer({
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

  ColumnFilters<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get clockIn => $composableBuilder(
    column: $table.clockIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get clockOut => $composableBuilder(
    column: $table.clockOut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workMode => $composableBuilder(
    column: $table.workMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get project => $composableBuilder(
    column: $table.project,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TimeLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $TimeLogsTable> {
  $$TimeLogsTableOrderingComposer({
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

  ColumnOrderings<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get clockIn => $composableBuilder(
    column: $table.clockIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get clockOut => $composableBuilder(
    column: $table.clockOut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workMode => $composableBuilder(
    column: $table.workMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get project => $composableBuilder(
    column: $table.project,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TimeLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimeLogsTable> {
  $$TimeLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => column);

  GeneratedColumn<DateTime> get clockIn =>
      $composableBuilder(column: $table.clockIn, builder: (column) => column);

  GeneratedColumn<DateTime> get clockOut =>
      $composableBuilder(column: $table.clockOut, builder: (column) => column);

  GeneratedColumn<String> get workMode =>
      $composableBuilder(column: $table.workMode, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get project =>
      $composableBuilder(column: $table.project, builder: (column) => column);
}

class $$TimeLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TimeLogsTable,
          TimeLog,
          $$TimeLogsTableFilterComposer,
          $$TimeLogsTableOrderingComposer,
          $$TimeLogsTableAnnotationComposer,
          $$TimeLogsTableCreateCompanionBuilder,
          $$TimeLogsTableUpdateCompanionBuilder,
          (TimeLog, BaseReferences<_$AppDatabase, $TimeLogsTable, TimeLog>),
          TimeLog,
          PrefetchHooks Function()
        > {
  $$TimeLogsTableTableManager(_$AppDatabase db, $TimeLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimeLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimeLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimeLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> dayKey = const Value.absent(),
                Value<DateTime> clockIn = const Value.absent(),
                Value<DateTime?> clockOut = const Value.absent(),
                Value<String> workMode = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> project = const Value.absent(),
              }) => TimeLogsCompanion(
                id: id,
                dayKey: dayKey,
                clockIn: clockIn,
                clockOut: clockOut,
                workMode: workMode,
                note: note,
                project: project,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String dayKey,
                required DateTime clockIn,
                Value<DateTime?> clockOut = const Value.absent(),
                required String workMode,
                Value<String?> note = const Value.absent(),
                Value<String?> project = const Value.absent(),
              }) => TimeLogsCompanion.insert(
                id: id,
                dayKey: dayKey,
                clockIn: clockIn,
                clockOut: clockOut,
                workMode: workMode,
                note: note,
                project: project,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TimeLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TimeLogsTable,
      TimeLog,
      $$TimeLogsTableFilterComposer,
      $$TimeLogsTableOrderingComposer,
      $$TimeLogsTableAnnotationComposer,
      $$TimeLogsTableCreateCompanionBuilder,
      $$TimeLogsTableUpdateCompanionBuilder,
      (TimeLog, BaseReferences<_$AppDatabase, $TimeLogsTable, TimeLog>),
      TimeLog,
      PrefetchHooks Function()
    >;
typedef $$LeaveLogsTableCreateCompanionBuilder =
    LeaveLogsCompanion Function({
      Value<int> id,
      required String dayKey,
      required String type,
      Value<String?> note,
    });
typedef $$LeaveLogsTableUpdateCompanionBuilder =
    LeaveLogsCompanion Function({
      Value<int> id,
      Value<String> dayKey,
      Value<String> type,
      Value<String?> note,
    });

class $$LeaveLogsTableFilterComposer
    extends Composer<_$AppDatabase, $LeaveLogsTable> {
  $$LeaveLogsTableFilterComposer({
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

  ColumnFilters<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LeaveLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $LeaveLogsTable> {
  $$LeaveLogsTableOrderingComposer({
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

  ColumnOrderings<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LeaveLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeaveLogsTable> {
  $$LeaveLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$LeaveLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LeaveLogsTable,
          LeaveLog,
          $$LeaveLogsTableFilterComposer,
          $$LeaveLogsTableOrderingComposer,
          $$LeaveLogsTableAnnotationComposer,
          $$LeaveLogsTableCreateCompanionBuilder,
          $$LeaveLogsTableUpdateCompanionBuilder,
          (LeaveLog, BaseReferences<_$AppDatabase, $LeaveLogsTable, LeaveLog>),
          LeaveLog,
          PrefetchHooks Function()
        > {
  $$LeaveLogsTableTableManager(_$AppDatabase db, $LeaveLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeaveLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeaveLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeaveLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> dayKey = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => LeaveLogsCompanion(
                id: id,
                dayKey: dayKey,
                type: type,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String dayKey,
                required String type,
                Value<String?> note = const Value.absent(),
              }) => LeaveLogsCompanion.insert(
                id: id,
                dayKey: dayKey,
                type: type,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LeaveLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LeaveLogsTable,
      LeaveLog,
      $$LeaveLogsTableFilterComposer,
      $$LeaveLogsTableOrderingComposer,
      $$LeaveLogsTableAnnotationComposer,
      $$LeaveLogsTableCreateCompanionBuilder,
      $$LeaveLogsTableUpdateCompanionBuilder,
      (LeaveLog, BaseReferences<_$AppDatabase, $LeaveLogsTable, LeaveLog>),
      LeaveLog,
      PrefetchHooks Function()
    >;
typedef $$DayOverridesTableCreateCompanionBuilder =
    DayOverridesCompanion Function({
      required String dayKey,
      required String type,
      Value<int> rowid,
    });
typedef $$DayOverridesTableUpdateCompanionBuilder =
    DayOverridesCompanion Function({
      Value<String> dayKey,
      Value<String> type,
      Value<int> rowid,
    });

class $$DayOverridesTableFilterComposer
    extends Composer<_$AppDatabase, $DayOverridesTable> {
  $$DayOverridesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DayOverridesTableOrderingComposer
    extends Composer<_$AppDatabase, $DayOverridesTable> {
  $$DayOverridesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get dayKey => $composableBuilder(
    column: $table.dayKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DayOverridesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DayOverridesTable> {
  $$DayOverridesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get dayKey =>
      $composableBuilder(column: $table.dayKey, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);
}

class $$DayOverridesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DayOverridesTable,
          DayOverride,
          $$DayOverridesTableFilterComposer,
          $$DayOverridesTableOrderingComposer,
          $$DayOverridesTableAnnotationComposer,
          $$DayOverridesTableCreateCompanionBuilder,
          $$DayOverridesTableUpdateCompanionBuilder,
          (
            DayOverride,
            BaseReferences<_$AppDatabase, $DayOverridesTable, DayOverride>,
          ),
          DayOverride,
          PrefetchHooks Function()
        > {
  $$DayOverridesTableTableManager(_$AppDatabase db, $DayOverridesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DayOverridesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DayOverridesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DayOverridesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> dayKey = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DayOverridesCompanion(
                dayKey: dayKey,
                type: type,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String dayKey,
                required String type,
                Value<int> rowid = const Value.absent(),
              }) => DayOverridesCompanion.insert(
                dayKey: dayKey,
                type: type,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DayOverridesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DayOverridesTable,
      DayOverride,
      $$DayOverridesTableFilterComposer,
      $$DayOverridesTableOrderingComposer,
      $$DayOverridesTableAnnotationComposer,
      $$DayOverridesTableCreateCompanionBuilder,
      $$DayOverridesTableUpdateCompanionBuilder,
      (
        DayOverride,
        BaseReferences<_$AppDatabase, $DayOverridesTable, DayOverride>,
      ),
      DayOverride,
      PrefetchHooks Function()
    >;
typedef $$LeaveRecordsTableCreateCompanionBuilder =
    LeaveRecordsCompanion Function({
      Value<int> id,
      required String leaveType,
      required DateTime startDate,
      required DateTime endDate,
      required String duration,
      required double daysConsumed,
      Value<String?> reason,
      required DateTime appliedOn,
    });
typedef $$LeaveRecordsTableUpdateCompanionBuilder =
    LeaveRecordsCompanion Function({
      Value<int> id,
      Value<String> leaveType,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<String> duration,
      Value<double> daysConsumed,
      Value<String?> reason,
      Value<DateTime> appliedOn,
    });

class $$LeaveRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $LeaveRecordsTable> {
  $$LeaveRecordsTableFilterComposer({
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

  ColumnFilters<String> get leaveType => $composableBuilder(
    column: $table.leaveType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get daysConsumed => $composableBuilder(
    column: $table.daysConsumed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get appliedOn => $composableBuilder(
    column: $table.appliedOn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LeaveRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $LeaveRecordsTable> {
  $$LeaveRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get leaveType => $composableBuilder(
    column: $table.leaveType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get daysConsumed => $composableBuilder(
    column: $table.daysConsumed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get appliedOn => $composableBuilder(
    column: $table.appliedOn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LeaveRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeaveRecordsTable> {
  $$LeaveRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get leaveType =>
      $composableBuilder(column: $table.leaveType, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<double> get daysConsumed => $composableBuilder(
    column: $table.daysConsumed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<DateTime> get appliedOn =>
      $composableBuilder(column: $table.appliedOn, builder: (column) => column);
}

class $$LeaveRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LeaveRecordsTable,
          LeaveRecord,
          $$LeaveRecordsTableFilterComposer,
          $$LeaveRecordsTableOrderingComposer,
          $$LeaveRecordsTableAnnotationComposer,
          $$LeaveRecordsTableCreateCompanionBuilder,
          $$LeaveRecordsTableUpdateCompanionBuilder,
          (
            LeaveRecord,
            BaseReferences<_$AppDatabase, $LeaveRecordsTable, LeaveRecord>,
          ),
          LeaveRecord,
          PrefetchHooks Function()
        > {
  $$LeaveRecordsTableTableManager(_$AppDatabase db, $LeaveRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeaveRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeaveRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeaveRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> leaveType = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<String> duration = const Value.absent(),
                Value<double> daysConsumed = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<DateTime> appliedOn = const Value.absent(),
              }) => LeaveRecordsCompanion(
                id: id,
                leaveType: leaveType,
                startDate: startDate,
                endDate: endDate,
                duration: duration,
                daysConsumed: daysConsumed,
                reason: reason,
                appliedOn: appliedOn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String leaveType,
                required DateTime startDate,
                required DateTime endDate,
                required String duration,
                required double daysConsumed,
                Value<String?> reason = const Value.absent(),
                required DateTime appliedOn,
              }) => LeaveRecordsCompanion.insert(
                id: id,
                leaveType: leaveType,
                startDate: startDate,
                endDate: endDate,
                duration: duration,
                daysConsumed: daysConsumed,
                reason: reason,
                appliedOn: appliedOn,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LeaveRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LeaveRecordsTable,
      LeaveRecord,
      $$LeaveRecordsTableFilterComposer,
      $$LeaveRecordsTableOrderingComposer,
      $$LeaveRecordsTableAnnotationComposer,
      $$LeaveRecordsTableCreateCompanionBuilder,
      $$LeaveRecordsTableUpdateCompanionBuilder,
      (
        LeaveRecord,
        BaseReferences<_$AppDatabase, $LeaveRecordsTable, LeaveRecord>,
      ),
      LeaveRecord,
      PrefetchHooks Function()
    >;
typedef $$NotesTableCreateCompanionBuilder =
    NotesCompanion Function({
      Value<int> id,
      required String kind,
      required DateTime date,
      Value<String> title,
      Value<String> body,
      Value<String> tags,
      Value<String> checklist,
      Value<bool> pinned,
      required DateTime updatedAt,
    });
typedef $$NotesTableUpdateCompanionBuilder =
    NotesCompanion Function({
      Value<int> id,
      Value<String> kind,
      Value<DateTime> date,
      Value<String> title,
      Value<String> body,
      Value<String> tags,
      Value<String> checklist,
      Value<bool> pinned,
      Value<DateTime> updatedAt,
    });

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
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

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checklist => $composableBuilder(
    column: $table.checklist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pinned => $composableBuilder(
    column: $table.pinned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checklist => $composableBuilder(
    column: $table.checklist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pinned => $composableBuilder(
    column: $table.pinned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get checklist =>
      $composableBuilder(column: $table.checklist, builder: (column) => column);

  GeneratedColumn<bool> get pinned =>
      $composableBuilder(column: $table.pinned, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$NotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotesTable,
          Note,
          $$NotesTableFilterComposer,
          $$NotesTableOrderingComposer,
          $$NotesTableAnnotationComposer,
          $$NotesTableCreateCompanionBuilder,
          $$NotesTableUpdateCompanionBuilder,
          (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
          Note,
          PrefetchHooks Function()
        > {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<String> checklist = const Value.absent(),
                Value<bool> pinned = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => NotesCompanion(
                id: id,
                kind: kind,
                date: date,
                title: title,
                body: body,
                tags: tags,
                checklist: checklist,
                pinned: pinned,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String kind,
                required DateTime date,
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<String> checklist = const Value.absent(),
                Value<bool> pinned = const Value.absent(),
                required DateTime updatedAt,
              }) => NotesCompanion.insert(
                id: id,
                kind: kind,
                date: date,
                title: title,
                body: body,
                tags: tags,
                checklist: checklist,
                pinned: pinned,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotesTable,
      Note,
      $$NotesTableFilterComposer,
      $$NotesTableOrderingComposer,
      $$NotesTableAnnotationComposer,
      $$NotesTableCreateCompanionBuilder,
      $$NotesTableUpdateCompanionBuilder,
      (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
      Note,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserSettingsTableTableManager get userSettings =>
      $$UserSettingsTableTableManager(_db, _db.userSettings);
  $$TimeLogsTableTableManager get timeLogs =>
      $$TimeLogsTableTableManager(_db, _db.timeLogs);
  $$LeaveLogsTableTableManager get leaveLogs =>
      $$LeaveLogsTableTableManager(_db, _db.leaveLogs);
  $$DayOverridesTableTableManager get dayOverrides =>
      $$DayOverridesTableTableManager(_db, _db.dayOverrides);
  $$LeaveRecordsTableTableManager get leaveRecords =>
      $$LeaveRecordsTableTableManager(_db, _db.leaveRecords);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
}
