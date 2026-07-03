typedef UserItem = ({
  String name,
  String phone,
  String email,
  String registrationDate,
  String parentName,
  String classes,
  String roles,
});

const usersMock = <UserItem>[
  (
    name: 'سارة أحمد',
    phone: '010111123655',
    email: 'sara@gmail.com',
    registrationDate: '2026/06/20',
    parentName: 'أحمد',
    classes: 'الصف الأول الابتدائي',
    roles: 'طالب',
  ),
  (
    name: 'منة أحمد',
    phone: '010111123655',
    email: 'mona@gmail.com',
    registrationDate: '2026/06/20',
    parentName: 'أحمد',
    classes: 'الصف الخامس الابتدائي',
    roles: 'طالب',
  ),
  (
    name: 'سارة أحمد',
    phone: '010111123655',
    email: 'admin@gmail.com',
    registrationDate: '2026/06/20',
    parentName: 'أحمد',
    classes: 'الصف الأول الابتدائي',
    roles: 'ولى أمر',
  ),
];
