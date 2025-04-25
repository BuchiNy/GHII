class User {
  final int? id;
  final String fullName;
  final bool isPrivate;
  final String login;
  final String avatarUrl;
  final String type;
  final String? description;

  User({
    this.id,
    required this.fullName,
    required this.isPrivate,
    required this.login,
    required this.avatarUrl,
    required this.type,
    this.description,
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      fullName: json['full_name'],
      isPrivate: json['private'],
      login: json['owner']['login'],
      avatarUrl: json['owner']['avatar_url'],
      type: json['owner']['type'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'full_name': fullName,
      'private': isPrivate ? 1 : 0,
      'login': login,
      'avatar_url': avatarUrl,
      'type': type,
      'description': description,
    };
  }
  factory User.fromMap(Map<String, dynamic> map){
    return User(
        id: map['id'] as int?,
        fullName: map['full_name'] as String,
        isPrivate: map['private'] == 1,
        login: map['login'] as String,
        avatarUrl: map['avatar_url'] as String,
        type: map['type'] as String,
        description: map['description'] as String?,
      );
    }
}