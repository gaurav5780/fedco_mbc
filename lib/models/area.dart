// Defining modal class for Area:

class Area {
  final int id;
  final int areaName;
  final String areaDescription;
  final int areaType;
  final String areaColor;

  Area({
    required this.id,
    required this.areaName,
    required this.areaDescription,
    required this.areaType,
    required this.areaColor,
  });

  static List<Area> listFromJson(List<dynamic> list) =>
      List<Area>.from(list.map((x) => Area.fromJson(x)));

  factory Area.fromJson(Map<String, dynamic> json) => _$AreaFromJson(json);
  Map<String, dynamic> toJson() => _$AreaToJson(this);
}

Area _$AreaFromJson(Map<String, dynamic> json) => Area(
      id: json['id'] as int,
      areaName: json['areaName'] as int,
      areaDescription: json['areaDescription'] as String,
      areaType: json['areaType'] as int,
      areaColor: json['areaColor'] as String,
    );

Map<String, dynamic> _$AreaToJson(Area instance) => <String, dynamic>{
      'id': instance.id,
      'areaName': instance.areaName,
      'areaDescription': instance.areaDescription,
      'areaType': instance.areaType,
      'areaColor': instance.areaColor,
    };
