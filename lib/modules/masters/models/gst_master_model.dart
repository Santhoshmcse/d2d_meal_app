class GstMasterModel {

  final int id;

  final String code;

  final String label;

  final bool active;

  const GstMasterModel({
    required this.id,
    required this.code,
    required this.label,
    required this.active,
  });

  factory GstMasterModel.fromJson(
      Map<String, dynamic> json) {

    return GstMasterModel(
      id: json['id'],
      code: json['code'],
      label: json['label'],
      active: json['active'],
    );
  }
}