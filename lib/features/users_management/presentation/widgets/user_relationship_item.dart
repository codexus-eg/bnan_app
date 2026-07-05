import 'package:bnan_app/features/users_management/data/models/user_model.dart';
import 'package:bnan_app/generated/l10n.dart';

typedef UserRelationshipItem = ({String label, String value});

List<UserRelationshipItem> userRelationshipItems(S s, UserItem user) {
  return switch (user.roles.toLowerCase()) {
    'parent' => [
        (label: s.children, value: _textOrDash(user.parentName)),
        (label: s.classes, value: _listOrText(user.grade, user.classes)),
        (label: s.curriculums, value: _listOrDash(user.curriculum)),
      ],
    'teacher' => [
        (label: s.curriculums, value: _listOrDash(user.curriculum)),
        (label: s.classes, value: _listOrText(user.grade, user.classes)),
      ],
    'supervisor' => [
        (
          label: s.supervisedClasses,
          value: _listOrText(user.grade, user.classes),
        ),
      ],
    _ => [
        (label: s.parent, value: _textOrDash(user.parentName)),
        (label: s.grade, value: _listOrText(user.grade, user.classes)),
        (label: s.curriculum, value: _listOrDash(user.curriculum)),
      ],
  };
}

String _listOrText(List<String> values, String fallback) {
  final listValue = _listOrDash(values);
  return listValue == '-' ? _textOrDash(fallback) : listValue;
}

String _listOrDash(List<String> values) {
  final visibleValues = values
      .map((value) => value.trim())
      .where((value) => value.isNotEmpty)
      .join(', ');
  return _textOrDash(visibleValues);
}

String _textOrDash(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? '-' : trimmed;
}
