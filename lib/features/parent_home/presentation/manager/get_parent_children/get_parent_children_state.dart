import 'package:bnan_app/features/parent_home/data/models/parent_child_model.dart';

sealed class GetParentChildrenState {}

final class GetParentChildrenInitial extends GetParentChildrenState {}

final class GetParentChildrenLoading extends GetParentChildrenState {}

final class GetParentChildrenSuccess extends GetParentChildrenState {
  GetParentChildrenSuccess(this.children);

  final List<ParentChildModel> children;
}

final class GetParentChildrenFailure extends GetParentChildrenState {
  GetParentChildrenFailure(this.errorMessage);

  final String errorMessage;
}
