sealed class GetParentPlansState {}

final class GetParentPlansInitial extends GetParentPlansState {}

final class GetParentPlansLoading extends GetParentPlansState {}

final class GetParentPlansSuccess extends GetParentPlansState {}

final class GetParentPlansFailure extends GetParentPlansState {
  GetParentPlansFailure(this.message);

  final String message;
}
