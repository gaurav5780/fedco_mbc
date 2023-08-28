// Constants for Area IDs:

class AreaIDs {
  static const int all = 1;
  static const int meghalaya = 2;
  static const int mawsynram = 3;
  static const int nongalbibra = 4;
  static const int phulbari = 5;
  static const int tripura = 6;
  static const int ambassa = 7;
  static const int gandachera = 8;
  static const int manu = 9;
  static const int chawmanu = 10;
  static const int mohanpur = 11;
  static const int bamutia = 12;
  static const int hezamara = 13;
  static const int lefunga = 14;
  static const int sabroom = 15;
  static const int satchand = 16;
}

// Constants for Area Names:

class AreasNames {
  static const String all = 'All areas';
  static const String meghalaya = 'Meghalaya';
  static const String mawsynram = 'Mawsynram';
  static const String nongalbibra = 'Nongalbibra';
  static const String phulbari = 'Phulbari';
  static const String tripura = 'Tripura';
  static const String ambassa = 'Ambassa';
  static const String gandachera = 'Gandachera';
  static const String manu = 'Manu';
  static const String chawmanu = 'Chawmanu';
  static const String mohanpur = 'Mohanpur';
  static const String bamutia = 'Bamutia';
  static const String hezamara = 'Hezamara';
  static const String lefunga = 'Lefunga';
  static const String sabroom = 'Sabroom';
  static const String satchand = 'Satchand';
}

// Returns the String name for an Area from its int ID value:

String getAreaNamefromInt(id) {
  switch (id) {
    case AreaIDs.all:
      return AreasNames.all;
    case AreaIDs.meghalaya:
      return AreasNames.meghalaya;
    case AreaIDs.mawsynram:
      return AreasNames.mawsynram;
    case AreaIDs.nongalbibra:
      return AreasNames.nongalbibra;
    case AreaIDs.phulbari:
      return AreasNames.phulbari;
    case AreaIDs.tripura:
      return AreasNames.tripura;
    case AreaIDs.ambassa:
      return AreasNames.ambassa;
    case AreaIDs.gandachera:
      return AreasNames.gandachera;
    case AreaIDs.manu:
      return AreasNames.manu;
    case AreaIDs.chawmanu:
      return AreasNames.chawmanu;
    case AreaIDs.mohanpur:
      return AreasNames.mohanpur;
    case AreaIDs.bamutia:
      return AreasNames.bamutia;
    case AreaIDs.hezamara:
      return AreasNames.hezamara;
    case AreaIDs.lefunga:
      return AreasNames.lefunga;
    case AreaIDs.sabroom:
      return AreasNames.sabroom;
    case AreaIDs.satchand:
      return AreasNames.satchand;
    case 0:
      return 'Area not assigned';
    default:
      return 'No area mentioned';
  }
}

// Returns the int ID for an Area from its String name value:

int getAreaNamefromString(stringArea) {
  switch (stringArea) {
    case AreasNames.all:
      return AreaIDs.all;
    case AreasNames.meghalaya:
      return AreaIDs.meghalaya;
    case AreasNames.mawsynram:
      return AreaIDs.mawsynram;
    case AreasNames.nongalbibra:
      return AreaIDs.nongalbibra;
    case AreasNames.phulbari:
      return AreaIDs.phulbari;
    case AreasNames.tripura:
      return AreaIDs.tripura;
    case AreasNames.ambassa:
      return AreaIDs.ambassa;
    case AreasNames.gandachera:
      return AreaIDs.gandachera;
    case AreasNames.manu:
      return AreaIDs.manu;
    case AreasNames.chawmanu:
      return AreaIDs.chawmanu;
    case AreasNames.mohanpur:
      return AreaIDs.mohanpur;
    case AreasNames.bamutia:
      return AreaIDs.bamutia;
    case AreasNames.hezamara:
      return AreaIDs.hezamara;
    case AreasNames.lefunga:
      return AreaIDs.lefunga;
    case AreasNames.sabroom:
      return AreaIDs.sabroom;
    case AreasNames.satchand:
      return AreaIDs.satchand;
    default:
      return 0;
  }
}

// Constants for Area Type IDs:

class AreaTypeID {
  static const int discom = 1;
  static const int zone = 2;
  static const int circle = 3;
  static const int division = 4;
  static const int subDivision = 5;
  static const int section = 6;
  static const int htFeeder = 7;
  static const int htFeederBranch = 8;
  static const int distributionTransformer = 9;
  static const int ltFeeder = 10;
  static const int ltFeederBranch = 11;
}

// Constants for Area Type Names:

class AreaTypeNames {
  static const String discom = 'DISCOM';
  static const String zone = 'Zone';
  static const String circle = 'Circle';
  static const String division = 'Division';
  static const String subDivision = 'Sub-division';
  static const String section = 'Section';
  static const String htFeeder = 'HT Feeder';
  static const String htFeederBranch = 'HT Feeder Branch';
  static const String distributionTransformer = 'Distribution Transformer';
  static const String ltFeeder = 'LT Feeder';
  static const String ltFeederBranch = 'LT Feeder Branch';
}

// Returns the String area type from its int ID value:

String getAreaTypeFromInt(areaTypeID) {
  switch (areaTypeID) {
    case AreaTypeID.discom:
      return AreaTypeNames.discom;
    case AreaTypeID.zone:
      return AreaTypeNames.zone;
    case AreaTypeID.circle:
      return AreaTypeNames.circle;
    case AreaTypeID.division:
      return AreaTypeNames.division;
    case AreaTypeID.subDivision:
      return AreaTypeNames.subDivision;
    case AreaTypeID.section:
      return AreaTypeNames.section;
    case AreaTypeID.htFeeder:
      return AreaTypeNames.htFeeder;
    case AreaTypeID.htFeederBranch:
      return AreaTypeNames.htFeederBranch;
    case AreaTypeID.distributionTransformer:
      return AreaTypeNames.distributionTransformer;
    case AreaTypeID.ltFeeder:
      return AreaTypeNames.ltFeeder;
    case AreaTypeID.ltFeederBranch:
      return AreaTypeNames.ltFeederBranch;
    case 0:
      return 'Unassigned';
    default:
      return 'No type mentioned';
  }
}

// Returns the int area type ID from its String type value:

int getAreaTypeFromString(areaTypeName) {
  switch (areaTypeName) {
    case AreaTypeNames.discom:
      return AreaTypeID.discom;
    case AreaTypeNames.zone:
      return AreaTypeID.zone;
    case AreaTypeNames.circle:
      return AreaTypeID.circle;
    case AreaTypeNames.division:
      return AreaTypeID.division;
    case AreaTypeNames.subDivision:
      return AreaTypeID.subDivision;
    case AreaTypeNames.section:
      return AreaTypeID.section;
    case AreaTypeNames.htFeeder:
      return AreaTypeID.htFeeder;
    case AreaTypeNames.htFeederBranch:
      return AreaTypeID.htFeederBranch;
    case AreaTypeNames.distributionTransformer:
      return AreaTypeID.distributionTransformer;
    case AreaTypeNames.ltFeeder:
      return AreaTypeID.ltFeeder;
    case AreaTypeNames.ltFeederBranch:
      return AreaTypeID.ltFeederBranch;
    default:
      return 0;
  }
}
