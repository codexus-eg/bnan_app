import 'package:bnan_app/features/users_management/data/models/user_model.dart';

final usersManagementSkeletonMock = List<UserItem>.filled(
  3,
  usersManagementSkeletonUser,
);

const usersManagementSkeletonUser = UserItem(
  id: '',
  name: 'Loading user',
  phone: '01000000000',
  email: 'loading@example.com',
  registrationDate: '2026/01/01',
  parentName: 'Loading',
  classes: 'Loading class',
  roles: 'student',
  status: 'active',
  createdAt: '',
  updatedAt: '',
  curriculum: [],
  grade: [],
);
