class UserRanking {
  final String name;
  final String image;
  final int pkt;

  UserRanking(this.name, this.image, this.pkt);

  static UserRanking fromMapRanking(Map<String, dynamic> map) {
    return UserRanking(
      map['username'],
      map['image'],
      map['pkt'],
    );
  }
}
