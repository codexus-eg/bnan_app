package com.bnanacademy.app

import android.content.Context
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.media.Ringtone
import android.media.RingtoneManager
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class NotificationSoundPlayer(
    private val context: Context,
    messenger: BinaryMessenger
) {
    private val channel = MethodChannel(messenger, "bnan/notification_sound")
    private var ringtone: Ringtone? = null
    private var sequencePlayer: MediaPlayer? = null

    fun register() {
        channel.setMethodCallHandler { call, result ->
            if (call.method == "playNudgeNotificationSequence") {
                playNudgeAlert()
                result.success(null)
                return@setMethodCallHandler
            }
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

    private fun playNudgeAlert() {
        if (sequencePlayer != null) return
        val resourceId = context.resources.getIdentifier(
            "nudge_alert",
            "raw",
            context.packageName
        )
        if (resourceId == 0) return
        val attributes = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_NOTIFICATION_RINGTONE)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .build()
        val uri = android.net.Uri.parse("android.resource://${context.packageName}/$resourceId")
        sequencePlayer = MediaPlayer.create(context, uri, null, attributes, 0)
            ?: return finishSequence()
        vibrate()
        sequencePlayer?.setOnCompletionListener { player ->
            player.release()
            sequencePlayer = null
        }
        sequencePlayer?.setOnErrorListener { player, _, _ ->
            player.release()
            sequencePlayer = null
            true
        }
        sequencePlayer?.start()
    }

    private fun vibrate() {
        val vibrator = context.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        val pattern = longArrayOf(
            0, 500, 300, 500, 300, 500, 300, 500,
            300, 500, 300, 500, 300, 500, 300, 500
        )
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            vibrator.vibrate(VibrationEffect.createWaveform(pattern, -1))
        } else {
            @Suppress("DEPRECATION")
            vibrator.vibrate(pattern, -1)
        }
    }

    private fun finishSequence() {
        sequencePlayer?.release()
        sequencePlayer = null
    }
}
