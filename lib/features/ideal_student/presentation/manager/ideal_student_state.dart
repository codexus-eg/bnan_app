sealed class IdealStudentState {
  const IdealStudentState();
}

class IdealStudentInitial extends IdealStudentState {
  const IdealStudentInitial();
}

class IdealStudentLoading extends IdealStudentState {
  const IdealStudentLoading();
}

class IdealStudentLoaded extends IdealStudentState {
  const IdealStudentLoaded();
}

class IdealStudentLoadingMore extends IdealStudentState {
  const IdealStudentLoadingMore();
}

class IdealStudentEmpty extends IdealStudentState {
  const IdealStudentEmpty();
}

class IdealStudentFailure extends IdealStudentState {
  const IdealStudentFailure(this.message);
  final String message;
}

class IdealStudentRefreshFailure extends IdealStudentState {
  const IdealStudentRefreshFailure(this.message);
  final String message;
}

class IdealStudentLoadMoreFailure extends IdealStudentState {
  const IdealStudentLoadMoreFailure(this.message);
  final String message;
}
