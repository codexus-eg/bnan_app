import 'package:bnan_app/features/parent_home/data/models/parent_child_model.dart';

sealed class GetParentChildrenState {}

final class GetParentChildrenInitial extends GetParentChildrenState {}

final class GetParentChildrenLoading extends GetParentChildrenState {}

final class GetParentChildrenSuccess extends GetParentChildrenState {
  GetParentChildrenSuccess(this.children, {this.selectedChildId});

  final List<ParentChildModel> children;
  final String? selectedChildId;

  ParentChildModel? get selectedChild {
    for (final child in children) {
      if (child.id == selectedChildId) return child;
    }
    return null;
  }
}

final class GetParentChildrenFailure extends GetParentChildrenState {
  GetParentChildrenFailure(this.errorMessage);

  final String errorMessage;
}
