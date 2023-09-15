class AppUser {
  final String id;
  String email;
  String username;
  String school;
  final String image;
  final String token;
  final int pkt;

  AppUser(
    this.id,
    this.email,
    this.username,
    this.school,
    this.image,
    this.token,
    this.pkt,
  );

  Map<String, Object?> toJson() => {
        'id': id,
        'email': email,
        'username': username,
        'school': school,
        'image': image,
        'token': token,
        'pkt': pkt,
      };

  Map<String, Object?> toJsonLimited() => {
        'school': school,
        'username': username,
        'image': image,
      };

  static AppUser fromMap(Map<String, dynamic> map) {
    return AppUser(
      map['id'],
      map['email'],
      map['username'],
      map['school'],
      map['image'],
      map['token'],
      map['pkt'],
    );
  }

  static AppUser fromMapLimited(Map<String, dynamic> map) {
    return AppUser(
      '',
      '',
      map['username'],
      map['school'],
      map['image'],
      '',
      0,
    );
  }
}
