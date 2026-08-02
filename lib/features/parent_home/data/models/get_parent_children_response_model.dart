import 'package:bnan_app/features/parent_home/data/models/parent_child_model.dart';

class GetParentChildrenResponseModel {
  const GetParentChildrenResponseModel({
    this.status = '',
    this.data = const [],
  });

  final String status;
  final List<ParentChildModel> data;

  factory GetParentChildrenResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return GetParentChildrenResponseModel(
      status: json['status']?.toString() ?? '',
      data: data is List
          ? data
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .map(ParentChildModel.fromJson)
                .toList(growable: false)
          : const [],
    );
  }
}
