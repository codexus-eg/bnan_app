import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/parent_home/data/models/get_parent_children_response_model.dart';
import 'package:bnan_app/features/parent_home/data/models/parent_child_model.dart';
import 'package:bnan_app/features/parent_home/data/repo/parent_home_repo.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_cubit.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/certificate_model.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/repo/student_certificates_repo.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/manager/get_certificates/get_certificates_cubit.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/manager/get_certificates/get_certificates_state.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/parent_certificates_content.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('selects first child and keeps filter while changing child', (
    tester,
  ) async {
    const children = [
      ParentChildModel(id: 'child-1', fullName: 'First Child'),
      ParentChildModel(id: 'child-2', fullName: 'Second Child'),
    ];
    final childrenCubit = GetParentChildrenCubit(
      _ChildrenRepo(const GetParentChildrenResponseModel(data: children)),
    );
    final certificatesRepo = _CertificatesRepo();
    final certificatesCubit = GetCertificatesCubit(certificatesRepo);
    addTearDown(childrenCubit.close);
    addTearDown(certificatesCubit.close);

    await _pump(tester, childrenCubit, certificatesCubit);
    await childrenCubit.getParentChildren();
    await tester.pumpAndSettle();

    final dropdown = tester.widget<CustomDropdown>(
      find.byKey(const Key('parentCertificatesChildDropdown')),
    );
    expect(dropdown.value, 'child-1');
    expect(certificatesRepo.studentIds, ['child-1']);

    dropdown.onChanged?.call('child-2');
    await tester.pump();

    expect(certificatesRepo.studentIds, ['child-1', 'child-2']);
    expect(certificatesCubit.state, isA<GetCertificatesLoading>());
    expect(
      find.byKey(const Key('parentCertificatesChildDropdown')),
      findsOneWidget,
    );
    certificatesRepo.second.complete(const Right([]));
    await tester.pumpAndSettle();
  });

  testWidgets('empty children does not request certificates', (tester) async {
    final childrenCubit = GetParentChildrenCubit(
      _ChildrenRepo(const GetParentChildrenResponseModel()),
    );
    final certificatesRepo = _CertificatesRepo();
    final certificatesCubit = GetCertificatesCubit(certificatesRepo);
    addTearDown(childrenCubit.close);
    addTearDown(certificatesCubit.close);

    await _pump(tester, childrenCubit, certificatesCubit);
    await childrenCubit.getParentChildren();
    await tester.pumpAndSettle();

    expect(find.text('There are no registered children'), findsOneWidget);
    expect(certificatesRepo.studentIds, isEmpty);
  });
}

Future<void> _pump(
  WidgetTester tester,
  GetParentChildrenCubit childrenCubit,
  GetCertificatesCubit certificatesCubit,
) {
  return tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: childrenCubit),
          BlocProvider.value(value: certificatesCubit),
        ],
        child: const Scaffold(body: ParentCertificatesContent()),
      ),
    ),
  );
}

class _ChildrenRepo implements ParentHomeRepo {
  const _ChildrenRepo(this.response);

  final GetParentChildrenResponseModel response;

  @override
  Future<Either<Failure, GetParentChildrenResponseModel>>
  getParentChildren() async => Right(response);
}

class _CertificatesRepo implements StudentCertificatesRepo {
  final studentIds = <String?>[];
  final second = Completer<Either<Failure, List<CertificateModel>>>();

  @override
  Future<Either<Failure, List<CertificateModel>>> getMyCertificates({
    String? studentId,
  }) {
    studentIds.add(studentId);
    if (studentIds.length == 1) return Future.value(const Right([]));
    return second.future;
  }
}
