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
    private var sequenceRemaining = 0

    fun register() {
        channel.setMethodCallHandler { call, result ->
            if (call.method == "playNudgeNotificationSequence") {
                if (sequenceRemaining == 0) {
                    sequenceRemaining = 3
                    playNudgeTone()
                }
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

    private fun playNudgeTone() {
        val uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
            ?: return finishSequence()
        val attributes = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_NOTIFICATION)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .build()
        sequencePlayer = MediaPlayer.create(context, uri, null, attributes, 0)
            ?: return finishSequence()
        vibrate()
        sequencePlayer?.setOnCompletionListener { player ->
            player.release()
            sequencePlayer = null
            sequenceRemaining--
            if (sequenceRemaining > 0) playNudgeTone() else finishSequence()
        }
        sequencePlayer?.setOnErrorListener { player, _, _ ->
            player.release()
            finishSequence()
            true
        }
        sequencePlayer?.start()
    }

    private fun vibrate() {
        val vibrator = context.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            vibrator.vibrate(VibrationEffect.createOneShot(250, VibrationEffect.DEFAULT_AMPLITUDE))
        } else {
            @Suppress("DEPRECATION")
            vibrator.vibrate(250)
        }
    }

    private fun finishSequence() {
        sequencePlayer?.release()
        sequencePlayer = null
        sequenceRemaining = 0
    }
}
