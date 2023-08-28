// Constants for BillingRecommendation type IDs:

class BillingRecommendationTypeID {
  static const int unBilled = 1;
  static const int inaccurateReading = 2;
  static const int noMeter = 3;
  static const int stoppedMeter = 4;
  static const int slowMeter = 5;
  static const int missedReadingDate = 6;
}

// Constants for BillingRecommendation type names:

class BillingRecommendationTypeNames {
  static const String unBilled = 'Unbilled cases';
  static const String inaccurateReading = 'Inaccurate reading cases';
  static const String noMeter = 'No meter cases';
  static const String stoppedMeter = 'Stopped meter cases';
  static const String slowMeter = 'Suspected slow meters';
  static const String missedReadingDate = 'Missed reading date';
}

// Returns the String name for a BillingRecommendation type from its int ID value:

String getBillingRecommendationTypeFromInt(billingRecommendationTypeID) {
  switch (billingRecommendationTypeID) {
    case BillingRecommendationTypeID.unBilled:
      return BillingRecommendationTypeNames.unBilled;
    case BillingRecommendationTypeID.inaccurateReading:
      return BillingRecommendationTypeNames.inaccurateReading;
    case BillingRecommendationTypeID.noMeter:
      return BillingRecommendationTypeNames.noMeter;
    case BillingRecommendationTypeID.stoppedMeter:
      return BillingRecommendationTypeNames.stoppedMeter;
    case BillingRecommendationTypeID.slowMeter:
      return BillingRecommendationTypeNames.slowMeter;
    case BillingRecommendationTypeID.missedReadingDate:
      return BillingRecommendationTypeNames.missedReadingDate;
    default:
      return 'Unclassified';
  }
}

// Returns the int ID for a BillingRecommendation type from its String name:

int getBillingRecommendationTypeFromString(BillingRecommendationTypeName) {
  switch (BillingRecommendationTypeName) {
    case BillingRecommendationTypeNames.unBilled:
      return BillingRecommendationTypeID.unBilled;
    case BillingRecommendationTypeNames.inaccurateReading:
      return BillingRecommendationTypeID.inaccurateReading;
    case BillingRecommendationTypeNames.noMeter:
      return BillingRecommendationTypeID.noMeter;
    case BillingRecommendationTypeNames.stoppedMeter:
      return BillingRecommendationTypeID.stoppedMeter;
    case BillingRecommendationTypeNames.slowMeter:
      return BillingRecommendationTypeID.slowMeter;
    case BillingRecommendationTypeNames.missedReadingDate:
      return BillingRecommendationTypeID.missedReadingDate;
    default:
      return 0;
  }
}

// Constants for BillingRecommendation category IDs:

class BillingRecommendationCategoryID {
  static const int domestic = 1;
  static const int commercial = 2;
  static const int industrial = 3;
  static const int bplMetered = 4;
  static const int bplUnmetered = 5;
  static const int wslt = 6;
  static const int generalPurpose = 7;
}

// Constants for BillingRecommendation category Namess:

class BillingRecommendationCategoryNames {
  static const String domestic = 'Domestic connections';
  static const String commercial = 'Commercial connections';
  static const String industrial = 'Industrial LT connections';
  static const String bplMetered = 'BPL - metered connections';
  static const String bplUnmetered = 'BPL - unmetered connections';
  static const String wslt = 'Public Water Supply';
  static const String generalPurpose = 'General purpose connections';
}

// Returns the String name for a BillingRecommendation category from its int ID value:

String getBillingRecommendationCategoryFromInt(categoryID) {
  switch (categoryID) {
    case BillingRecommendationCategoryID.domestic:
      return BillingRecommendationCategoryNames.domestic;
    case BillingRecommendationCategoryID.commercial:
      return BillingRecommendationCategoryNames.commercial;
    case BillingRecommendationCategoryID.industrial:
      return BillingRecommendationCategoryNames.industrial;
    case BillingRecommendationCategoryID.bplMetered:
      return BillingRecommendationCategoryNames.bplMetered;
    case BillingRecommendationCategoryID.bplUnmetered:
      return BillingRecommendationCategoryNames.bplUnmetered;
    case BillingRecommendationCategoryID.wslt:
      return BillingRecommendationCategoryNames.wslt;
    case BillingRecommendationCategoryID.generalPurpose:
      return BillingRecommendationCategoryNames.generalPurpose;
    default:
      return 'Unclassified';
  }
}

// Returns the int ID for a BillingRecommendation category from its String name:

int getBillingRecommendationCategoryFromString(categoryName) {
  switch (categoryName) {
    case BillingRecommendationCategoryNames.domestic:
      return BillingRecommendationCategoryID.domestic;
    case BillingRecommendationCategoryNames.commercial:
      return BillingRecommendationCategoryID.commercial;
    case BillingRecommendationCategoryNames.industrial:
      return BillingRecommendationCategoryID.industrial;
    case BillingRecommendationCategoryNames.bplMetered:
      return BillingRecommendationCategoryID.bplMetered;
    case BillingRecommendationCategoryNames.bplUnmetered:
      return BillingRecommendationCategoryID.bplUnmetered;
    case BillingRecommendationCategoryNames.wslt:
      return BillingRecommendationCategoryID.wslt;
    case BillingRecommendationCategoryNames.generalPurpose:
      return BillingRecommendationCategoryID.generalPurpose;
    default:
      return 0;
  }
}

// Constants for BillingRecommendation status IDs:

class BillingRecommendationStatusID {
  static const int newRec = 1;
  static const int pendingRec = 2;
  static const int progressRec = 3;
  static const int delayedRec = 4;
  static const int completedRec = 5;
  static const int deferredRec = 6;
  static const int droppedRec = 7;
}

// Constants for BillingRecommendation status names:

class BillingRecommendationStatusNames {
  static const String newRec = 'New';
  static const String pendingRec = 'Pending';
  static const String progressRec = 'In progress';
  static const String delayedRec = 'Delayed';
  static const String completedRec = 'Completed';
  static const String deferredRec = 'Deferred';
  static const String droppedRec = 'Dropped';
}

// Returns the String name for a BillingRecommendation status from its int ID value:

String getBillingRecommendationStatusFromInt(statusID) {
  switch (statusID) {
    case BillingRecommendationStatusID.newRec:
      return BillingRecommendationStatusNames.newRec;
    case BillingRecommendationStatusID.pendingRec:
      return BillingRecommendationStatusNames.pendingRec;
    case BillingRecommendationStatusID.progressRec:
      return BillingRecommendationStatusNames.progressRec;
    case BillingRecommendationStatusID.delayedRec:
      return BillingRecommendationStatusNames.delayedRec;
    case BillingRecommendationStatusID.completedRec:
      return BillingRecommendationStatusNames.completedRec;
    case BillingRecommendationStatusID.deferredRec:
      return BillingRecommendationStatusNames.deferredRec;
    case BillingRecommendationStatusID.droppedRec:
      return BillingRecommendationStatusNames.droppedRec;
    default:
      return 'Unclassified';
  }
}

// Returns the int ID for a BillingRecommendation status from its String name:

int getBillingRecommendationStatusFromString(statusName) {
  switch (statusName) {
    case BillingRecommendationStatusNames.newRec:
      return BillingRecommendationStatusID.newRec;
    case BillingRecommendationStatusNames.pendingRec:
      return BillingRecommendationStatusID.pendingRec;
    case BillingRecommendationStatusNames.progressRec:
      return BillingRecommendationStatusID.progressRec;
    case BillingRecommendationStatusNames.delayedRec:
      return BillingRecommendationStatusID.delayedRec;
    case BillingRecommendationStatusNames.completedRec:
      return BillingRecommendationStatusID.completedRec;
    case BillingRecommendationStatusNames.deferredRec:
      return BillingRecommendationStatusID.deferredRec;
    case BillingRecommendationStatusNames.droppedRec:
      return BillingRecommendationStatusID.droppedRec;
    default:
      return 0;
  }
}
