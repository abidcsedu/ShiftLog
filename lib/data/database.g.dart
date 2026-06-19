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
          ..write('weekendDays: $weekendDays')
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
          other.weekendDays == this.weekendDays);
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
          ..write('weekendDays: $weekendDays')
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dayKey,
    clockIn,
    clockOut,
    workMode,
    note,
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
  const TimeLog({
    required this.id,
    required this.dayKey,
    required this.clockIn,
    this.clockOut,
    required this.workMode,
    this.note,
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
    };
  }

  TimeLog copyWith({
    int? id,
    String? dayKey,
    DateTime? clockIn,
    Value<DateTime?> clockOut = const Value.absent(),
    String? workMode,
    Value<String?> note = const Value.absent(),
  }) => TimeLog(
    id: id ?? this.id,
    dayKey: dayKey ?? this.dayKey,
    clockIn: clockIn ?? this.clockIn,
    clockOut: clockOut.present ? clockOut.value : this.clockOut,
    workMode: workMode ?? this.workMode,
    note: note.present ? note.value : this.note,
  );
  TimeLog copyWithCompanion(TimeLogsCompanion data) {
    return TimeLog(
      id: data.id.present ? data.id.value : this.id,
      dayKey: data.dayKey.present ? data.dayKey.value : this.dayKey,
      clockIn: data.clockIn.present ? data.clockIn.value : this.clockIn,
      clockOut: data.clockOut.present ? data.clockOut.value : this.clockOut,
      workMode: data.workMode.present ? data.workMode.value : this.workMode,
      note: data.note.present ? data.note.value : this.note,
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
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, dayKey, clockIn, clockOut, workMode, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimeLog &&
          other.id == this.id &&
          other.dayKey == this.dayKey &&
          other.clockIn == this.clockIn &&
          other.clockOut == this.clockOut &&
          other.workMode == this.workMode &&
          other.note == this.note);
}

class TimeLogsCompanion extends UpdateCompanion<TimeLog> {
  final Value<int> id;
  final Value<String> dayKey;
  final Value<DateTime> clockIn;
  final Value<DateTime?> clockOut;
  final Value<String> workMode;
  final Value<String?> note;
  const TimeLogsCompanion({
    this.id = const Value.absent(),
    this.dayKey = const Value.absent(),
    this.clockIn = const Value.absent(),
    this.clockOut = const Value.absent(),
    this.workMode = const Value.absent(),
    this.note = const Value.absent(),
  });
  TimeLogsCompanion.insert({
    this.id = const Value.absent(),
    required String dayKey,
    required DateTime clockIn,
    this.clockOut = const Value.absent(),
    required String workMode,
    this.note = const Value.absent(),
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
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayKey != null) 'day_key': dayKey,
      if (clockIn != null) 'clock_in': clockIn,
      if (clockOut != null) 'clock_out': clockOut,
      if (workMode != null) 'work_mode': workMode,
      if (note != null) 'note': note,
    });
  }

  TimeLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? dayKey,
    Value<DateTime>? clockIn,
    Value<DateTime?>? clockOut,
    Value<String>? workMode,
    Value<String?>? note,
  }) {
    return TimeLogsCompanion(
      id: id ?? this.id,
      dayKey: dayKey ?? this.dayKey,
      clockIn: clockIn ?? this.clockIn,
      clockOut: clockOut ?? this.clockOut,
      workMode: workMode ?? this.workMode,
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
          ..write('note: $note')
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserSettingsTable userSettings = $UserSettingsTable(this);
  late final $TimeLogsTable timeLogs = $TimeLogsTable(this);
  late final $LeaveLogsTable leaveLogs = $LeaveLogsTable(this);
  late final $DayOverridesTable dayOverrides = $DayOverridesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userSettings,
    timeLogs,
    leaveLogs,
    dayOverrides,
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
    });
typedef $$TimeLogsTableUpdateCompanionBuilder =
    TimeLogsCompanion Function({
      Value<int> id,
      Value<String> dayKey,
      Value<DateTime> clockIn,
      Value<DateTime?> clockOut,
      Value<String> workMode,
      Value<String?> note,
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
              }) => TimeLogsCompanion(
                id: id,
                dayKey: dayKey,
                clockIn: clockIn,
                clockOut: clockOut,
                workMode: workMode,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String dayKey,
                required DateTime clockIn,
                Value<DateTime?> clockOut = const Value.absent(),
                required String workMode,
                Value<String?> note = const Value.absent(),
              }) => TimeLogsCompanion.insert(
                id: id,
                dayKey: dayKey,
                clockIn: clockIn,
                clockOut: clockOut,
                workMode: workMode,
                note: note,
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
}
