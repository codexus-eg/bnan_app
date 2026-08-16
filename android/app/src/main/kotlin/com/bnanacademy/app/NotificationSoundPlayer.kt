package com.bnanacademy.app

import android.content.Context
import android.media.AudioAttributes
import android.media.Ringtone
import android.media.RingtoneManager
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class NotificationSoundPlayer(
    private val context: Context,
    messenger: BinaryMessenger
) {
    private val channel = MethodChannel(messenger, "bnan/notification_sound")
    private var ringtone: Ringtone? = null

    fun register() {
        channel.setMethodCallHandler { call, result ->
            if (call.method != "playDefaultNotificationSound") {
                result.notImplemented()
                return@setMethodCallHandler
            }
            try {
                val uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
                    ?: error("Default notification sound is unavailable")
                ringtone = RingtoneManager.getRingtone(context, uri)
                    ?: error("Notification ringtone could not be created")
                ringtone?.audioAttributes = AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .build()
                ringtone?.play()
                result.success(null)
            } catch (error: Exception) {
                result.error("NOTIFICATION_SOUND_FAILED", error.message, null)
            }
        }
    }
}
