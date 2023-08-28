// Constants for user levels int IDs:

class UserLevelID {
  static const int admin = 1;
  static const int guest = 2;
  static const int chief = 3;
  static const int manager = 4;
  static const int executive = 5;
  static const int meterReader = 6;
}

// Constants for user levels String names:

class UserLevelName {
  static const String admin = 'Admin';
  static const String guest = 'Guest';
  static const String chief = 'Chief';
  static const String manager = 'Manager';
  static const String executive = 'Executive';
  static const String meterReader = 'Meter Reader';
}

// Returns the String name for a User from int ID value:

String getUserLevelFromInt(levelID) {
  switch (levelID) {
    case UserLevelID.admin:
      return UserLevelName.admin;
    case UserLevelID.guest:
      return UserLevelName.guest;
    case UserLevelID.chief:
      return UserLevelName.chief;
    case UserLevelID.manager:
      return UserLevelName.manager;
    case UserLevelID.executive:
      return UserLevelName.executive;
    case UserLevelID.meterReader:
      return UserLevelName.meterReader;
    default:
      return 'Unclassified';
  }
}

// Returns the int ID for a User from String name:

int getUserLevelFromString(stringID) {
  switch (stringID) {
    case UserLevelName.admin:
      return UserLevelID.admin;
    case UserLevelName.guest:
      return UserLevelID.guest;
    case UserLevelName.chief:
      return UserLevelID.chief;
    case UserLevelName.manager:
      return UserLevelID.manager;
    case UserLevelName.executive:
      return UserLevelID.executive;
    case UserLevelName.meterReader:
      return UserLevelID.meterReader;
    default:
      return 0;
  }
}
