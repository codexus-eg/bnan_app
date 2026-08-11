import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/features/parent_home/data/models/get_parent_children_response_model.dart';
import 'package:bnan_app/features/parent_home/data/repo/parent_home_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parent children response parses nested classroom and grade safely', () {
    final response = GetParentChildrenResponseModel.fromJson({
      'status': 'success',
      'data': [
        {
          'id': 'child-1',
          'userId': 'user-1',
          'fullName': 'Egyptian Test Student 2',
          'registrationMode': 'egyptian',
          'curriculum': {
            'id': 'egyptian-curriculum',
            'name': 'Egyptian',
            'registrationMode': 'egyptian',
          },
          'classroom': {
            'id': 'classroom-1',
            'name': 'First A',
            'grade': {'name': 'First Grade'},
          },
        },
        {
          'id': 'child-2',
          'fullName': 'Without Classroom',
          'registrationMode': 'gulf',
        },
      ],
    });

    expect(response.status, 'success');
    expect(response.data, hasLength(2));
    expect(response.data.first.classroom?.grade?.name, 'First Grade');
    expect(response.data.first.id, 'child-1');
    expect(response.data.first.registrationMode, RegistrationMode.egyptian);
    expect(response.data.first.curriculum?.id, 'egyptian-curriculum');
    expect(response.data.last.registrationMode, RegistrationMode.gulf);
    expect(response.data.last.classroom, isNull);
  });

  test('missing and unknown child registration modes parse as null', () {
    expect(
      GetParentChildrenResponseModel.fromJson({
        'data': [
          {'id': 'one'},
          {'id': 'two', 'registrationMode': 'unknown'},
        ],
      }).data.map((child) => child.registrationMode),
      everyElement(isNull),
    );
  });

  test('registration mode falls back to the nested curriculum', () {
    final child = GetParentChildrenResponseModel.fromJson({
      'data': [
        {
          'id': 'gulf-child',
          'curriculum': {
            '_id': 'saudi-2',
            'name': 'Saudi 2',
            'registrationMode': 'gulf',
          },
        },
      ],
    }).data.single;
    expect(child.curriculum?.id, 'saudi-2');
    expect(child.registrationMode, RegistrationMode.gulf);
  });

  test('child supports underscore id and fallback name and grade', () {
    final child = GetParentChildrenResponseModel.fromJson({
      'data': [
        {'_id': 'child-3', 'name': 'Fallback Name', 'grade': 'Grade 3'},
      ],
    }).data.single;

    expect(child.id, 'child-3');
    expect(child.fullName, 'Fallback Name');
    expect(child.grade, 'Grade 3');
  });

  test('missing or invalid data parses as an empty list', () {
    expect(GetParentChildrenResponseModel.fromJson({}).data, isEmpty);
    expect(GetParentChildrenResponseModel.fromJson({'data': {}}).data, isEmpty);
  });

  test('repository sends one protected GET without query or body', () async {
    final api = _FakeApi();
    final result = await ParentHomeRepoImpl(api).getParentChildren();

    expect(result.isRight(), isTrue);
    expect(api.path, '/parents/my-childs');
    expect(api.data, isNull);
    expect(api.query, isNull);
    expect(api.isProtected, isTrue);
  });
}

class _FakeApi implements ApiConsumer {
  String? path;
  Object? data;
  Map<String, dynamic>? query;
  bool isProtected = false;

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    this.path = path;
    this.data = data;
    query = queryParameter;
    this.isProtected = isProtected;
    return {'status': 'success', 'data': <Object>[]};
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
