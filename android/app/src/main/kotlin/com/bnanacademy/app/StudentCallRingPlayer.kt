package com.bnanacademy.app

import android.content.Context
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.os.PowerManager
import android.util.Log

class StudentCallRingPlayer(private val context: Context) {
    private val handler = Handler(Looper.getMainLooper())
    private val stopTask = Runnable(::stop)
    private var player: MediaPlayer? = null

    fun play() {
        stop()
        val id = context.resources.getIdentifier("chat_ring", "raw", context.packageName)
        if (id == 0) return
        val attributes = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_NOTIFICATION_RINGTONE)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .build()
        val uri = Uri.parse("android.resource://${context.packageName}/$id")
        player = MediaPlayer.create(context, uri, null, attributes, 0)?.apply {
            isLooping = true
            setWakeMode(context, PowerManager.PARTIAL_WAKE_LOCK)
            start()
            Log.i(StudentCallAlertContract.TAG, "MediaPlayer started")
        }
        handler.postDelayed(stopTask, 60_000)
    }

    fun stop() {
        handler.removeCallbacks(stopTask)
        player?.run {
            if (isPlaying) stop()
            release()
        }
        player = null
        Log.i(StudentCallAlertContract.TAG, "MediaPlayer stopped")
    }
}
