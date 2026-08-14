package com.bnanacademy.app

import android.content.ContentValues
import android.content.Context
import android.media.MediaScannerConnection
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import java.io.File

object MediaStoreFileSaver {
    fun save(
        context: Context,
        sourcePath: String,
        fileName: String,
        mimeType: String,
        isImage: Boolean
    ): String? = try {
        val source = File(sourcePath)
        if (!source.isFile || source.length() == 0L || fileName.isBlank()) null
        else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            saveWithMediaStore(context, source, fileName, mimeType, isImage)
        } else {
            saveLegacy(context, source, fileName, mimeType, isImage)
        }
    } catch (_: Exception) {
        null
    }

    private fun saveWithMediaStore(
        context: Context,
        source: File,
        name: String,
        mime: String,
        image: Boolean
    ): String? {
        val resolver = context.contentResolver
        val collection = if (image) MediaStore.Images.Media.EXTERNAL_CONTENT_URI
        else MediaStore.Downloads.EXTERNAL_CONTENT_URI
        val folder = if (image) Environment.DIRECTORY_PICTURES
        else Environment.DIRECTORY_DOWNLOADS
        val values = ContentValues().apply {
            put(MediaStore.MediaColumns.DISPLAY_NAME, name)
            put(MediaStore.MediaColumns.MIME_TYPE, mime)
            put(MediaStore.MediaColumns.RELATIVE_PATH, "$folder/Bnan")
            put(MediaStore.MediaColumns.IS_PENDING, 1)
        }
        val uri = resolver.insert(collection, values) ?: return null
        return try {
            resolver.openOutputStream(uri)?.use { output ->
                source.inputStream().use { it.copyTo(output) }
            } ?: return null
            values.clear()
            values.put(MediaStore.MediaColumns.IS_PENDING, 0)
            if (resolver.update(uri, values, null, null) <= 0) {
                resolver.delete(uri, null, null)
                return null
            }
            val savedSize = resolver.query(
                uri,
                arrayOf(MediaStore.MediaColumns.SIZE),
                null,
                null,
                null
            )?.use { cursor ->
                if (cursor.moveToFirst()) cursor.getLong(0) else -1L
            } ?: -1L
            if (savedSize != source.length()) {
                resolver.delete(uri, null, null)
                null
            } else uri.toString()
        } catch (error: Exception) {
            resolver.delete(uri, null, null)
            throw error
        }
    }

    @Suppress("DEPRECATION")
    private fun saveLegacy(
        context: Context,
        source: File,
        name: String,
        mime: String,
        image: Boolean
    ): String? {
        val type = if (image) Environment.DIRECTORY_PICTURES
        else Environment.DIRECTORY_DOWNLOADS
        val directory = File(Environment.getExternalStoragePublicDirectory(type), "Bnan")
        if (!directory.exists() && !directory.mkdirs()) return null
        val target = File(directory, name)
        source.copyTo(target, overwrite = true)
        MediaScannerConnection.scanFile(context, arrayOf(target.path), arrayOf(mime), null)
        return if (target.isFile && target.length() == source.length()) target.path else null
    }
}
