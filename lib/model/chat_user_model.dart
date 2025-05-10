class ChatUserModel {
  final String id;
  String name;
  String email;
  final String? image;
  final String? about;
  final String? lastActive;
  final String? createAt;
  final bool? isOnline;
  final String? pushToken;

  ChatUserModel({
    required this.id,
    required this.name,
    required this.email,
    this.image,
    this.about,
    this.lastActive,
    this.createAt,
    this.isOnline,
    this.pushToken,
  });

  factory ChatUserModel.fromJson(Map<String, dynamic> json) {
    return ChatUserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      image: json['image'],
      about: json['about'],
      lastActive: json['lastActive'],
      createAt: json['createAt'],
      isOnline: json['isOnline'] is bool
          ? json['isOnline'] as bool?
          : json['isOnline'] == 'true',
      pushToken: json['push_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'image': image,
      'about': about,
      'lastActive': lastActive,
      'createAt': createAt,
      'isOnline': isOnline,
      'push_token': pushToken,
    };
  }
}
