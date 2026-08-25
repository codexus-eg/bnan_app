package com.bnanacademy.app

import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.core.content.ContextCompat
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingReceiver

class StudentCallFcmReceiver : FlutterFirebaseMessagingReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val key = intent.extras?.getString("key")?.trim()?.uppercase()
        if (key == StudentCallAlertContract.KEY) {
            startStudentCall(context, intent)
        }
        super.onReceive(context, intent)
    }

    private fun startStudentCall(context: Context, source: Intent) {
        val callId = source.extras?.getString("callId")
            ?: source.extras?.getString("requestId").orEmpty()
        val preferences = context.getSharedPreferences(
            StudentCallAlertContract.PREFERENCES, Context.MODE_PRIVATE
        )
        if (callId.isNotEmpty() && callId == preferences.getString(
                StudentCallAlertContract.LAST_REJECTED_CALL_ID, null
            )) return
        Log.i(StudentCallAlertContract.TAG, "FCM received callId=$callId")
        val service = Intent(context, StudentCallAlertService::class.java).apply {
            action = StudentCallAlertContract.ACTION_START
            putExtra(StudentCallAlertContract.EXTRA_CALL_ID, callId)
            putExtra(StudentCallAlertContract.EXTRA_TITLE, text(source, "title", "Bnan Academy"))
            putExtra(StudentCallAlertContract.EXTRA_BODY, text(source, "body", "Open Bnan"))
        }
        runCatching { ContextCompat.startForegroundService(context, service) }
            .onFailure { Log.e(StudentCallAlertContract.TAG, "service start failed", it) }
    }

    private fun text(intent: Intent, key: String, fallback: String) =
        intent.extras?.getString("gcm.n.$key")
            ?: intent.extras?.getString(key)
            ?: fallback
}
