// Defining the modal class for User:

class User {
  int id;
  int area;
  bool isUserLoggedIn;
  bool hasSeenIntro;
  String userName;
  String userAvatar;
  String userEmail;
  String userPass;
  String userBio;
  String phoneNumber;
  String deviceIdentifier;
  int userLevel;
  int userReportsTo;
  int userIncentiveScore;

  User({
    required this.id,
    required this.area,
    required this.isUserLoggedIn,
    required this.hasSeenIntro,
    required this.userName,
    required this.userAvatar,
    required this.userEmail,
    required this.userPass,
    required this.userBio,
    required this.phoneNumber,
    required this.deviceIdentifier,
    required this.userLevel,
    required this.userReportsTo,
    required this.userIncentiveScore,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<dynamic, dynamic> toJson() => _$UserToJson(this);

  static List<User> listFromJson(List<dynamic> list) =>
      List<User>.from(list.map((x) => User.fromJson(x)));
}

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int,
      area: json['area'] as int,
      isUserLoggedIn: json['isUserLoggedIn'] as bool,
      hasSeenIntro: json['hasSeenIntro'] as bool,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String,
      userEmail: json['userEmail'] as String,
      userPass: json['userPass'] as String,
      userBio: json['userBio'] as String,
      phoneNumber: json['phoneNumber'] as String,
      deviceIdentifier: json['deviceIdentifier'] as String,
      userLevel: json['userLevel'] as int,
      userReportsTo: json['userReportsTo'] as int,
      userIncentiveScore: json['userIncentiveScore'] as int,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'area': instance.area,
      'isUserLoggedIn': instance.isUserLoggedIn,
      'hasSeenIntro': instance.hasSeenIntro,
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
      'userEmail': instance.userEmail,
      'userPass': instance.userPass,
      'userBio': instance.userBio,
      'phoneNumber': instance.phoneNumber,
      'deviceIdentifier': instance.deviceIdentifier,
      'userLevel': instance.userLevel,
      'userReportsTo': instance.userReportsTo,
      'userIncentiveScore': instance.userIncentiveScore,
    };
