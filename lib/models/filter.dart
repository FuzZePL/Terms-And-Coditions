class FilterOwn {
  String id;
  List<dynamic> listOfType;
  bool onlyFromYourSchool;
  String level;
  String school;

  FilterOwn(
    this.id,
    this.listOfType,
    this.onlyFromYourSchool,
    this.level,
    this.school,
  );

  Map<String, Object?> toJson() => {
        'id': id,
        'listOfType': listOfType,
        'onlyFromYourSchool': onlyFromYourSchool,
        'level': level,
        'school': school,
      };

  static FilterOwn fromMap(Map<String, dynamic> map) {
    return FilterOwn(
      map['id'],
      map['listOfType'],
      map['onlyFromYourSchool'],
      map['level'],
      map['school'],
    );
  }
}
