enum WorkMode { office, wfh, outside }

enum Gender { male, female }

/// Duration of a leave (half or full day).
enum LeaveType { half, full }

/// Category of leave, each with its own yearly entitlement.
enum LeaveCategory { casual, sick, maternity, parental }

extension WorkModeX on WorkMode {
  String get db => name; // 'office' | 'wfh' | 'outside'
  String get label => switch (this) {
        WorkMode.office => 'Office',
        WorkMode.wfh => 'WFH',
        WorkMode.outside => 'Outside Office',
      };
  static WorkMode fromDb(String v) =>
      WorkMode.values.firstWhere((e) => e.name == v, orElse: () => WorkMode.office);
}

extension GenderX on Gender {
  String get db => name;
  String get label => this == Gender.female ? 'Female' : 'Male';
  static Gender fromDb(String v) =>
      Gender.values.firstWhere((e) => e.name == v, orElse: () => Gender.male);
}

extension LeaveTypeX on LeaveType {
  String get db => name; // 'half' | 'full'
  String get label => this == LeaveType.half ? 'Half Day' : 'Full Day';
  double get deduction => this == LeaveType.half ? 0.5 : 1.0;
  static LeaveType fromDb(String v) =>
      LeaveType.values.firstWhere((e) => e.name == v, orElse: () => LeaveType.full);
}

extension LeaveCategoryX on LeaveCategory {
  String get db => name;
  String get label => switch (this) {
        LeaveCategory.casual => 'Casual',
        LeaveCategory.sick => 'Sick',
        LeaveCategory.maternity => 'Maternity',
        LeaveCategory.parental => 'Parental',
      };
  /// Full-year entitlement in days.
  double get fullYearDays => switch (this) {
        LeaveCategory.casual => 15,
        LeaveCategory.sick => 10,
        LeaveCategory.maternity => 112, // 16 weeks
        LeaveCategory.parental => 10,
      };
  bool get femaleOnly => this == LeaveCategory.maternity;

  static LeaveCategory fromDb(String v) => LeaveCategory.values
      .firstWhere((e) => e.name == v, orElse: () => LeaveCategory.casual);
}
