import 'dart:convert';

import 'package:bnan_app/core/cache/hive_box_names.dart';
import 'package:bnan_app/features/student_profile/data/local/student_profile_local_data_source.dart';
import 'package:bnan_app/features/student_profile/data/models/logged_user_response_model.dart';
import 'package:hive_flutter/hive_flutter.dart';



class StudentProfileLocalDataSourceImpl
    implements StudentProfileLocalDataSource {
  static const String _loggedUserKey = 'logged_user';

  @override
  Future<void> cacheLoggedUser({
    required LoggedUserResponseModel loggedUserResponse,
  }) async {
    final box = await Hive.openBox(HiveBoxNames.studentProfileBox);

    final jsonString = jsonEncode(loggedUserResponse.toJson());

    await box.put(_loggedUserKey, jsonString);
  }

  @override
  Future<LoggedUserResponseModel?> getCachedLoggedUser() async {
    final box = await Hive.openBox(HiveBoxNames.studentProfileBox);

    final cachedData = box.get(_loggedUserKey);

    if (cachedData == null) return null;

    if (cachedData is String) {
      final decodedData = jsonDecode(cachedData) as Map<String, dynamic>;
      return LoggedUserResponseModel.fromJson(decodedData);
    }

    await box.delete(_loggedUserKey);
    return null;
  }

  @override
  Future<void> clearCachedLoggedUser() async {
    final box = await Hive.openBox(HiveBoxNames.studentProfileBox);

    await box.delete(_loggedUserKey);
  }
}