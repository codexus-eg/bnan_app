import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_state.dart';
import 'package:flutter/widgets.dart';

String zoomSessionErrorMessage(BuildContext context, StartSessionState state) {
  final code = (state.eventCode ?? state.eventError ?? '').trim().toUpperCase();
  return switch (code) {
    'SCHEDULE_OCCURRENCE_NOT_FOUND' =>
      'موعد الحصة المحدد غير موجود في الجدول، يرجى تحديث الجدول',
    'SESSION_START_WINDOW_NOT_OPEN' ||
    'WINDOW_NOT_OPEN' ||
    'NOT_OPEN' =>
      'لم يحن وقت بدء الحصة بعد (يبدأ السماح قبل الموعد بـ 15 دقيقة)',
    'SESSION_NOT_DUE' => 'هذه الحصة ليست مستحقة للبدء الآن',
    'SESSION_OCCURRENCE_MISMATCH' =>
      'تاريخ الحصة لا يتطابق مع الموعد المجدول',
    'SESSION_NOT_ACTIVE' => 'لا توجد حصة مباشرة نشطة الآن',
    'CLASSROOM_SESSION_ALREADY_ACTIVE' => 'توجد حصة نشطة بالفعل لهذا الفصل',
    'WEEKLY_ZOOM_HOST_BUSY' =>
      'حساب Zoom للمضيف مشغول حالياً، يرجى إعادة المحاولة',
    'WEEKLY_ZOOM_HOST_UNAVAILABLE' =>
      'تعذر بدء الحصة، حساب Zoom للمضيف غير متوفر الآن',
    'WEEKLY_ZOOM_ASSIGNMENT_PENDING' ||
    'WEEKLY_ZOOM_ASSIGNMENT_UNALLOCATED' ||
    'WEEKLY_ZOOM_ASSIGNMENT_STALE' ||
    'WEEKLY_ZOOM_ASSIGNMENT_UNAVAILABLE' =>
      'جلسة Zoom قيد التجهيز، يرجى تحديث الجدول أو مراجعة الإدارة',
    'WEEKLY_ZOOM_SLOT_SESSION_NOT_ACTIVE' =>
      'موعد الحصة غير نشط حالياً، تم تحديث البيانات',
    'TEACHER_START_URL_UNAVAILABLE' =>
      'رابط بدء المعلم غير متاح حالياً، يرجى إعادة المحاولة',
    _ => state.eventError ?? 'حدث خطأ غير متوقع',
  };
}
