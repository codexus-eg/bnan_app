import 'package:bnan_app/features/packages_management/data/models/package_access_scope.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_add_child_egyptian_request.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_add_child_gulf_request.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_child_student_request.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_payment_address.dart';
import 'package:bnan_app/features/parent_children/data/repo/parent_add_child_repo_impl.dart';
import 'package:bnan_app/features/parent_children/presentation/policies/parent_package_policy.dart';
import 'package:bnan_app/core/network/dio_consumer.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Egyptian payload contains registration fields only', () {
    final json = ParentAddChildEgyptianRequest(
      student: _student,
      curriculumId: 'curriculum-1',
      packageId: 'package-1',
      discountCode: 'SAVE',
    ).toJson();

    expect(json.keys, {'student', 'curriculum', 'packageId', 'discountCode'});
    final student = json['student'] as Map<String, dynamic>;
    expect(student.keys, {
      'fullName',
      'email',
      'password',
      'grade',
      'subjects',
    });
    expect(json.containsKey('receiptImage'), isFalse);
    expect(json.containsKey('method'), isFalse);
    expect(json.containsKey('referenceNumber'), isFalse);
  });

  test('Gulf payload never contains parent credentials', () {
    final json = ParentAddChildGulfRequest(
      student: _student,
      curriculumId: 'curriculum-1',
      packageId: 'package-1',
      paymentAddress: const ParentPaymentAddress(
        city: 'Riyadh',
        region: 'Riyadh',
        line1: 'Street 1',
      ),
    ).toJson();

    expect(json.keys, {
      'student',
      'curriculum',
      'packageId',
      'paymentAddress',
      'locale',
    });
    expect(json.containsKey('parentEmail'), isFalse);
    expect(json.containsKey('parentPassword'), isFalse);
    expect(json.containsKey('password'), isFalse);
    expect((json['student'] as Map<String, dynamic>)['subjects'], [
      'subject-1',
      'subject-2',
      'subject-3',
    ]);
  });

  test('Gulf package policy supports private and legacy packages', () {
    const single = PackageModel(
      accessScope: PackageAccessScope.singleSubject,
      isActive: true,
    );
    const all = PackageModel(
      accessScope: PackageAccessScope.allSubjects,
      isActive: true,
    );
    const inactive = PackageModel(isActive: false);
    expect(
      ParentPackagePolicy.isVisible(single, registrationMode: 'gulf'),
      isTrue,
    );
    expect(
      ParentPackagePolicy.isVisible(single, registrationMode: 'egyptian'),
      isFalse,
    );
    expect(
      ParentPackagePolicy.isVisible(all, registrationMode: 'gulf'),
      isTrue,
    );
    expect(
      ParentPackagePolicy.isVisible(inactive, registrationMode: 'egyptian'),
      isFalse,
    );
  });

  test(
    'Gulf repository request uses parent auth and Idempotency-Key',
    () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.com/api/v1'));
      RequestOptions? captured;
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.extra['isProtected'] == true) {
              options.headers['Authorization'] = 'Bearer parent-token';
            }
            handler.next(options);
          },
        ),
      );
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            captured = options;
            handler.resolve(
              Response(
                requestOptions: options,
                data: {
                  'data': {
                    'paymentId': 'payment-1',
                    'checkoutUrl': 'https://checkout.example.com',
                    'orderId': 'order-1',
                    'status': 'pending',
                    'providerStatus': 'pending',
                  },
                },
              ),
            );
          },
        ),
      );

      await ParentAddChildRepoImpl(DioConsumer(dio: dio)).checkoutGulf(
        request: ParentAddChildGulfRequest(
          student: _student,
          curriculumId: 'curriculum-1',
          packageId: 'package-1',
          paymentAddress: const ParentPaymentAddress(
            city: 'Riyadh',
            region: 'Riyadh',
            line1: 'Street 1',
          ),
        ),
        idempotencyKey: 'attempt-1',
      );

      expect(captured?.extra['isProtected'], isTrue);
      expect(captured?.headers['Authorization'], 'Bearer parent-token');
      expect(captured?.headers['Idempotency-Key'], 'attempt-1');
    },
  );

  test('Gulf repository rejects 2xx without checkout context', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.com/api/v1'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) => handler.resolve(
          Response(
            requestOptions: options,
            data: {
              'data': {'status': 'pending'},
            },
          ),
        ),
      ),
    );

    final result = await ParentAddChildRepoImpl(DioConsumer(dio: dio))
        .checkoutGulf(
          request: ParentAddChildGulfRequest(
            student: _student,
            curriculumId: 'curriculum-1',
            packageId: 'package-1',
            paymentAddress: const ParentPaymentAddress(
              city: 'Riyadh',
              region: 'Riyadh',
              line1: 'Street 1',
            ),
          ),
          idempotencyKey: 'attempt-1',
        );

    expect(result.isLeft(), isTrue);
  });
}

const _student = ParentChildStudentRequest(
  fullName: 'Student Name',
  email: 'student@example.com',
  password: 'Password1',
  gradeId: 'grade-1',
  subjectIds: ['subject-1', 'subject-2', 'subject-3'],
);
