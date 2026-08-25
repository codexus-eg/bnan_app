import 'dart:io';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/student_auth/data/models/auth_response_model.dart';
import 'package:bnan_app/features/teacher_registration/data/models/teacher_register_request_model.dart';
import 'package:bnan_app/features/teacher_registration/data/repo/teacher_registration_repo.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => S.load(const Locale('en')));

  test('empty video link blocks the registration request', () async {
    final repo = _RecordingRepo();
    final cubit = TeacherRegistrationCubit(repo);
    addTearDown(cubit.close);
    cubit.changeCanProvideTrialLesson(true);
    cubit.whyJoinBananController.text = 'Because';
    cubit.howHandleWeakStudentController.text = 'Support the student';

    final requiredMessage = S.current.fieldIsRequired(S.current.shortVideoLink);
    expect(cubit.validateEvaluationStep(), requiredMessage);

    await cubit.registerTeacher();

    expect(repo.calls, 0);
    expect(cubit.state, isA<TeacherRegistrationFailureState>());
    expect(
      (cubit.state as TeacherRegistrationFailureState).errorMessage,
      requiredMessage,
    );
  });

  test('video link must be a valid http or https URL', () async {
    final cubit = TeacherRegistrationCubit(_RecordingRepo());
    addTearDown(cubit.close);

    cubit.shortVideoLinkController.text = 'not-a-url';
    expect(cubit.validateIntroVideoUrl(), S.current.invalidLink);
    cubit.shortVideoLinkController.text = 'https://example.com/video';
    expect(cubit.validateIntroVideoUrl(), isNull);
  });

  test('validated video link is trimmed and sent in the request', () async {
    final directory = await Directory.systemTemp.createTemp('teacher-video');
    addTearDown(() => directory.delete(recursive: true));
    final file = await File('${directory.path}/file.pdf').writeAsBytes([1]);
    final repo = _RecordingRepo();
    final cubit = TeacherRegistrationCubit(repo);
    addTearDown(cubit.close);
    cubit.shortVideoLinkController.text = '  https://example.com/video  ';
    cubit.changeTeachingCurriculum(id: 'curriculum', name: 'Curriculum');
    cubit.changeCvFile(file);
    cubit.changeCertificateFile(file);
    cubit.changeNationalIdFile(file);

    await cubit.registerTeacher();

    expect(repo.calls, 1);
    expect(repo.request?.introVideoUrl, 'https://example.com/video');
  });
}

class _RecordingRepo implements TeacherRegistrationRepo {
  int calls = 0;
  TeacherRegisterRequestModel? request;

  @override
  Future<Either<Failure, AuthResponseModel>> registerTeacher({
    required TeacherRegisterRequestModel request,
  }) async {
    calls++;
    this.request = request;
    return Left(Failure(message: 'stop'));
  }
}
