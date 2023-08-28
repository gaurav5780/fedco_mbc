// Constants for update type - Integer IDs:
class UpdateTypeInt {
  static const assigned = 1;
  static const volunteered = 2;
  static const delegated = 3;
  static const partial = 4;
  static const completed = 5;
}

// Constants for update type - String Names:
class UpdateTypeString {
  static const assigned = 'Assigned';
  static const volunteered = 'Volunteered';
  static const delegated = 'Delegated';
  static const partial = 'Partially completed';
  static const completed = 'Completed';
}

// Returns the String name for an Update from its int ID value:

String getUpdateTypeFromInt(updateTypeID) {
  switch (updateTypeID) {
    case UpdateTypeInt.assigned:
      return UpdateTypeString.assigned;
    case UpdateTypeInt.volunteered:
      return UpdateTypeString.volunteered;
    case UpdateTypeInt.delegated:
      return UpdateTypeString.delegated;
    case UpdateTypeInt.partial:
      return UpdateTypeString.partial;
    case UpdateTypeInt.completed:
      return UpdateTypeString.completed;
    default:
      return 'Unclassified';
  }
}

// Returns the int ID for an Update from its String name:

int getUpdateTypeFromString(updateTypeString) {
  switch (updateTypeString) {
    case UpdateTypeString.assigned:
      return UpdateTypeInt.assigned;
    case UpdateTypeString.volunteered:
      return UpdateTypeInt.volunteered;
    case UpdateTypeString.delegated:
      return UpdateTypeInt.delegated;
    case UpdateTypeString.partial:
      return UpdateTypeInt.partial;
    case UpdateTypeString.completed:
      return UpdateTypeInt.completed;
    default:
      return 0;
  }
}
