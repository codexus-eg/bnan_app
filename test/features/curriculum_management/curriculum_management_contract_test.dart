import 'dart:io';

import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/features/curriculum_management/data/models/update_curriculum_request_model.dart';
import 'package:bnan_app/features/curriculum_management/data/repo/curriculum_management_repo_impl.dart';
import 'package:bnan_app/features/curriculum_management/presentation/manager/get_curriculums_cubit/get_curriculums_cubit.dart';
import 'package:bnan_app/features/curriculum_management/presentation/manager/get_curriculums_cubit/get_curriculums_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('curriculum update contract', () {
    test(
      'PATCH is multipart and omits icon when no new image is selected',
      () async {
        final api = _RecordingApiConsumer();
        final repo = CurriculumManagementRepoImpl(api);

        await repo.updateCurriculum(
          curriculumId: 'curriculum-1',
          request: const UpdateCurriculumRequestModel(
            name: 'Name',
            description: 'Description',
            registrationMode: 'egyptian',
          ),
        );

        expect(api.patchPath, '/curriculums/curriculum-1');
        expect(api.patchIsFormData, isTrue);
        expect(api.patchIsProtected, isTrue);
        final formData = api.patchData! as FormData;
        expect(Map.fromEntries(formData.fields), {
          'name': 'Name',
          'description': 'Description',
          'registrationMode': 'egyptian',
        });
        expect(formData.files.where((entry) => entry.key == 'icon'), isEmpty);
      },
    );

    test(
      'includes icon as MultipartFile when a new image is selected',
      () async {
        final directory = await Directory.systemTemp.createTemp('curriculum');
        addTearDown(() => directory.delete(recursive: true));
        final icon = await File('${directory.path}/icon.png').writeAsBytes([1]);
        final formData = await UpdateCurriculumRequestModel(
          name: 'Name',
          description: 'Description',
          registrationMode: 'gulf',
          icon: icon,
        ).toFormData();

        expect(formData.files.single.key, 'icon');
        expect(formData.files.single.value, isA<MultipartFile>());
      },
    );
  });

  test('DELETE uses the protected curriculum endpoint', () async {
    final api = _RecordingApiConsumer();
    final result = await CurriculumManagementRepoImpl(
      api,
    ).deleteCurriculum('curriculum-2');

    expect(result.isRight(), isTrue);
    expect(api.deletePath, '/curriculums/curriculum-2');
    expect(api.deleteIsProtected, isTrue);
  });

  test('removes a curriculum locally only when explicitly requested', () async {
    final cubit = GetCurriculumsCubit(
      CurriculumManagementRepoImpl(_RecordingApiConsumer()),
    );
    await cubit.getCurriculums();

    cubit.removeCurriculum('curriculum-1');

    final state = cubit.state as GetCurriculumsSuccess;
    expect(state.curriculums.map((item) => item.id), ['curriculum-2']);
    await cubit.close();
  });
}

class _RecordingApiConsumer implements ApiConsumer {
  String? patchPath;
  Object? patchData;
  bool? patchIsFormData;
  bool? patchIsProtected;
  String? deletePath;
  bool? deleteIsProtected;

  @override
  Future<dynamic> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    patchPath = path;
    patchData = data;
    patchIsFormData = isFormData;
    patchIsProtected = isProtected;
    return {
      'data': {'id': 'curriculum-1', 'name': 'Name'},
    };
  }

  @override
  Future<dynamic> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    deletePath = path;
    deleteIsProtected = isProtected;
    return null;
  }

  @override
  Future get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async => {
    'success': true,
    'length': 2,
    'data': [
      {'id': 'curriculum-1', 'name': 'First'},
      {'id': 'curriculum-2', 'name': 'Second'},
    ],
  };

  @override
  Future post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) => throw UnimplementedError();

  @override
  Future put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) => throw UnimplementedError();
}
