package com.bnanacademy.app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import androidx.core.app.NotificationCompat

class StudentCallAlertService : Service() {
    private val handler = Handler(Looper.getMainLooper())
    private val player by lazy { StudentCallRingPlayer(applicationContext) }
    private val timeout = Runnable { finishCall(rejected = false) }
    private var activeCallId: String? = null

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == StudentCallAlertContract.ACTION_REJECT) {
            Log.i(StudentCallAlertContract.TAG, "reject")
            activeCallId = intent.getStringExtra(StudentCallAlertContract.EXTRA_CALL_ID)
                ?.trim()?.ifEmpty { null } ?: activeCallId
            finishCall(rejected = true)
            return START_NOT_STICKY
        }
        val callId = intent?.getStringExtra(StudentCallAlertContract.EXTRA_CALL_ID)
            ?.trim().orEmpty()
        if (callId.isNotEmpty() && callId == activeCallId) return START_NOT_STICKY
        activeCallId = callId.ifEmpty { null }
        createChannel()
        startForeground(
            StudentCallAlertContract.NOTIFICATION_ID,
            buildNotification(intent)
        )
        Log.i(StudentCallAlertContract.TAG, "foreground service started callId=$callId")
        player.play()
        handler.removeCallbacks(timeout)
        handler.postDelayed(timeout, StudentCallAlertContract.DURATION_MS)
        return START_NOT_STICKY
    }

    override fun onDestroy() {
        handler.removeCallbacks(timeout)
        activeCallId?.let(::saveRejectedCallId)
        player.stop()
        super.onDestroy()
    }

    private fun finishCall(rejected: Boolean) {
        Log.i(
            StudentCallAlertContract.TAG,
            if (rejected) "ring stopped by reject" else "ring stopped by timeout"
        )
        handler.removeCallbacks(timeout)
        player.stop()
        if (rejected) activeCallId?.let(::saveRejectedCallId)
        activeCallId = null
        getSystemService(NotificationManager::class.java)
            .cancel(StudentCallAlertContract.NOTIFICATION_ID)
        stopForeground(STOP_FOREGROUND_REMOVE)
        stopSelf()
    }

    private fun createChannel() {
        val channel = NotificationChannel(
            StudentCallAlertContract.CHANNEL_ID,
            "Student call alerts",
            NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = "Supervisor call alerts for students"
            setSound(null, null)
            enableVibration(true)
        }
        getSystemService(NotificationManager::class.java)
            .createNotificationChannel(channel)
    }

    private fun buildNotification(intent: Intent?): android.app.Notification {
        val openIntent = (packageManager.getLaunchIntentForPackage(packageName)
            ?: Intent(this, MainActivity::class.java)).apply {
            flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val open = PendingIntent.getActivity(
            this, 0, openIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val reject = PendingIntent.getService(
            this,
            1,
            Intent(this, StudentCallAlertService::class.java).apply {
                action = StudentCallAlertContract.ACTION_REJECT
                putExtra(StudentCallAlertContract.EXTRA_CALL_ID, activeCallId)
            },
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        return NotificationCompat.Builder(this, StudentCallAlertContract.CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_notification)
            .setContentTitle(intent?.getStringExtra(StudentCallAlertContract.EXTRA_TITLE))
            .setContentText(intent?.getStringExtra(StudentCallAlertContract.EXTRA_BODY))
            .setContentIntent(open)
            .setCategory(NotificationCompat.CATEGORY_CALL)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setOngoing(true)
            .setAutoCancel(false)
            .setTimeoutAfter(StudentCallAlertContract.DURATION_MS)
            .addAction(0, "Reject", reject)
            .build()
    }

    private fun saveRejectedCallId(callId: String) {
        getSharedPreferences(StudentCallAlertContract.PREFERENCES, MODE_PRIVATE).edit()
            .putString(StudentCallAlertContract.LAST_REJECTED_CALL_ID, callId)
            .apply()
    }

    companion object {
        fun stop(context: Context) {
            context.getSystemService(NotificationManager::class.java)
                .cancel(StudentCallAlertContract.NOTIFICATION_ID)
            context.stopService(Intent(context, StudentCallAlertService::class.java))
        }
    }
}
