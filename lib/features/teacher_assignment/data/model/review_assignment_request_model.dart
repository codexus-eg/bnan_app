class ReviewAssignmentRequestModel {
  final int score;

  const ReviewAssignmentRequestModel({
    required this.score,
  });

  Map<String, dynamic> toJson() {
    return {
      'score': score,
    };
  }
}