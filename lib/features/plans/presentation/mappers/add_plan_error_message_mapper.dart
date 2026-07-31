String mapAddPlanErrorMessage(
  String message, {
  required String duplicateMessage,
}) {
  if (message.trim() == 'قيمة مكررة') {
    return duplicateMessage;
  }
  return message;
}
