String mapAddPlanErrorMessage(
  String message, {
  required String duplicateMessage,
}) {
  if (message.trim() == 'قيمة مكررة') {
    return duplicateMessage;
  }
  return message;
}

String mapUploadPlanErrorMessage(
  String message, {
  required String teacherRequiredMessage,
}) {
  if (message.trim() == 'تعيين المادة بالفصل غير موجود') {
    return teacherRequiredMessage;
  }
  return message;
}
