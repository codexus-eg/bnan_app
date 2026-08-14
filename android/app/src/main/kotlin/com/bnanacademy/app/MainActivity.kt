package com.bnanacademy.app

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ApplicationInfo
import android.util.Log
import android.os.Build
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var pendingSave: SaveRequest? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "bnan/device_file_saver"
        ).setMethodCallHandler { call, result ->
            if (call.method == "openFile") {
                result.success(openFile(
                    call.argument<String>("reference").orEmpty(),
                    call.argument<String>("mimeType").orEmpty()
                ))
                return@setMethodCallHandler
            }
            if (call.method != "saveFile") {
                result.notImplemented()
                return@setMethodCallHandler
            }
            debugLog("saveFile called")
            val request = SaveRequest(
                call.argument<String>("sourcePath").orEmpty(),
                call.argument<String>("fileName").orEmpty(),
                call.argument<String>("mimeType").orEmpty(),
                call.argument<Boolean>("isImage") == true,
                result
            )
            if (needsLegacyPermission()) requestLegacyPermission(request)
            else save(request)
        }
        debugLog("channel registered")
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode != STORAGE_PERMISSION_REQUEST) return
        val request = pendingSave ?: return
        pendingSave = null
        if (grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED) save(request)
        else request.result.error("STORAGE_PERMISSION_DENIED", "Storage access denied", null)
    }

    private fun needsLegacyPermission() =
        Build.VERSION.SDK_INT in Build.VERSION_CODES.M until Build.VERSION_CODES.Q &&
            checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) !=
            PackageManager.PERMISSION_GRANTED

    private fun requestLegacyPermission(request: SaveRequest) {
        if (pendingSave != null) {
            request.result.error("SAVE_IN_PROGRESS", "Another save is active", null)
            return
        }
        pendingSave = request
        requestPermissions(
            arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE),
            STORAGE_PERMISSION_REQUEST
        )
    }

    private fun save(request: SaveRequest) = Thread {
        val reference = MediaStoreFileSaver.save(
            this, request.path, request.name, request.mime, request.image
        )
        runOnUiThread {
            if (reference == null) {
                request.result.error("SAVE_FAILED", "Unable to save file", null)
            } else {
                request.result.success(mapOf(
                    "status" to "saved",
                    "location" to if (request.image) "Pictures/Bnan" else "Downloads/Bnan",
                    "reference" to reference,
                    "canOpen" to reference.startsWith("content://")
                ))
            }
        }
    }.start()

    private fun openFile(reference: String, mime: String): Boolean = try {
        if (!reference.startsWith("content://")) false
        else openContentUri(reference, mime)
    } catch (_: Exception) {
        false
    }

    private fun openContentUri(reference: String, mime: String): Boolean {
        val intent = Intent(Intent.ACTION_VIEW).apply {
            setDataAndType(Uri.parse(reference), mime)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }
        if (intent.resolveActivity(packageManager) == null) return false
        startActivity(intent)
        return true
    }

    private fun debugLog(message: String) {
        if (applicationInfo.flags and ApplicationInfo.FLAG_DEBUGGABLE != 0) {
            Log.d("BNAN_FILE_SAVER", message)
        }
    }

    private data class SaveRequest(
        val path: String,
        val name: String,
        val mime: String,
        val image: Boolean,
        val result: MethodChannel.Result
    )

    private companion object {
        const val STORAGE_PERMISSION_REQUEST = 7314
    }
}
