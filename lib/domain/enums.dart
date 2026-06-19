enum WorkMode { office, wfh, outside }

enum Gender { male, female }

enum LeaveType { half, full }

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
