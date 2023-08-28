// Defining model class for BillingUpdate:

class BillingUpdate {
  final int id;
  final int billingAssignment;
  final String updateDescription;
  final DateTime updateDate;
  final int updateType;
  final int updateRectifiedCases;
  final int updateIncentive;

  BillingUpdate({
    required this.id,
    required this.billingAssignment,
    required this.updateDescription,
    required this.updateDate,
    required this.updateType,
    required this.updateRectifiedCases,
    required this.updateIncentive,
  });

  factory BillingUpdate.fromJson(Map<String, dynamic> json) =>
      _$BillingUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$BillingUpdateToJson(this);

  static List<BillingUpdate> listFromJson(List<dynamic> list) =>
      List<BillingUpdate>.from(list.map((x) => BillingUpdate.fromJson(x)));
}

BillingUpdate _$BillingUpdateFromJson(Map<String, dynamic> json) =>
    BillingUpdate(
      id: json['id'] as int,
      billingAssignment: json['billingAssignment'] as int,
      updateDescription: json['updateDescription'] as String,
      updateDate: DateTime.parse(json['updateDate'] as String),
      updateType: json['updateType'] as int,
      updateRectifiedCases: json['updateRectifiedCases'] as int,
      updateIncentive: json['updateIncentive'] as int,
    );

Map<String, dynamic> _$BillingUpdateToJson(BillingUpdate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'billingAssignment': instance.billingAssignment,
      'updateDescription': instance.updateDescription,
      'updateDate': instance.updateDate.toIso8601String(),
      'updateType': instance.updateType,
      'updateRectifiedCases': instance.updateRectifiedCases,
      'updateIncentive': instance.updateIncentive,
    };
