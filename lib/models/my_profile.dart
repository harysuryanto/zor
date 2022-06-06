class MyProfile {
  final String name;

  MyProfile({
    required this.name,
  });

  factory MyProfile.fromMap(Map<String, dynamic> data) {
    return MyProfile(
      name: data['name'] ?? '',
    );
  }
}
