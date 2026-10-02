class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.authToken,
  });
  
  final int id;
  final String name;
  final String email;
  String authToken;

}
