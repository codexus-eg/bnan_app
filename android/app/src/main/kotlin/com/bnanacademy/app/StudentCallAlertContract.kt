package com.bnanacademy.app

object StudentCallAlertContract {
    const val TAG = "StudentCallNative"
    const val KEY = "STUDENT_CALL_ALERT"
    const val NOTIFICATION_ID = 1128352844
    const val CHANNEL_ID = "bnan_student_call_native_v1"
    const val ACTION_START = "com.bnanacademy.app.STUDENT_CALL_START"
    const val ACTION_REJECT = "com.bnanacademy.app.STUDENT_CALL_REJECT"
    const val EXTRA_CALL_ID = "callId"
    const val EXTRA_TITLE = "title"
    const val EXTRA_BODY = "body"
    const val PREFERENCES = "student_call_alert"
    const val LAST_REJECTED_CALL_ID = "last_rejected_call_id"
    const val DURATION_MS = 60_000L
}
