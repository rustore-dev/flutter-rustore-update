package ru.rustore.flutter_rustore_update

import android.content.Context
import android.util.Log
import io.flutter.plugin.common.EventChannel
import ru.rustore.flutter_rustore_update.pigeons.Rustore
import ru.rustore.sdk.appupdate.listener.InstallStateUpdateListener
import ru.rustore.sdk.appupdate.manager.factory.RuStoreAppUpdateManagerFactory
import ru.rustore.sdk.appupdate.model.AppUpdateInfo
import ru.rustore.sdk.appupdate.model.AppUpdateOptions
import ru.rustore.sdk.appupdate.model.InstallState
import ru.rustore.sdk.appupdate.model.AppUpdateType.Companion.FLEXIBLE
import ru.rustore.sdk.appupdate.model.AppUpdateType.Companion.IMMEDIATE
import ru.rustore.sdk.appupdate.model.AppUpdateType.Companion.SILENT

class FlutterRustoreUpdateClient(private val context: Context) : Rustore.RustoreUpdate {
    private val manager = RuStoreAppUpdateManagerFactory.create(context, mapOf("type" to "flutter"))
    private var info: AppUpdateInfo? = null
    private var eventSink: EventChannel.EventSink? = null
    private var installStateUpdateListener: InstallStateUpdateListener? = null
    private var pendingLegacyResult: Rustore.Result<Rustore.RequestResponse>? = null
    private var lastKnownState: Rustore.RequestResponse? = null

    override fun info(result: Rustore.Result<Rustore.UpdateInfo>) {
        manager.getAppUpdateInfo()
            .addOnSuccessListener { info ->
                val response = Rustore.UpdateInfo.Builder()
                    .setAvailableVersionCode(info.availableVersionCode.toLong())
                    .setPackageName(info.packageName)
                    .setUpdateAvailability(info.updateAvailability.toLong())
                    .setInstallStatus(info.installStatus.toLong())
                    .build()

                this.info = info
                result.success(response)
            }
            .addOnFailureListener { throwable ->
                result.error(throwable)
            }
    }

    override fun listener(result: Rustore.Result<Rustore.RequestResponse>) {
        val cachedState = lastKnownState
        if (cachedState != null) {
            lastKnownState = null
            result.success(cachedState)
            stopObservingIfIdle()
            return
        }

        pendingLegacyResult = result
        ensureStateObserver()
    }

    override fun immediate(result: Rustore.Result<Rustore.DownloadResponse>) {
        if (info == null) {
            result.error(Exception("app info not found"))
            return
        }

        manager.startUpdateFlow(info!!, AppUpdateOptions.Builder().appUpdateType(IMMEDIATE).build())
            .addOnSuccessListener { status ->
                val response = Rustore.DownloadResponse.Builder()
                    .setCode(status.toLong())
                    .build()

                result.success(response)
            }
            .addOnFailureListener { throwable ->
                Log.d("FlutterRustoreUpdate", throwable.toString())
                result.error(throwable)
            }
    }

    override fun silent(result: Rustore.Result<Rustore.DownloadResponse>) {
        if (info == null) {
            result.error(Exception("app info not found"))
            return
        }

        manager.startUpdateFlow(info!!, AppUpdateOptions.Builder().appUpdateType(SILENT).build())
            .addOnSuccessListener { status ->
                val response = Rustore.DownloadResponse.Builder()
                    .setCode(status.toLong())
                    .build()

                result.success(response)
            }
            .addOnFailureListener { throwable ->
                Log.d("FlutterRustoreUpdate", throwable.toString())
                result.error(throwable)
            }
    }

    override fun download(result: Rustore.Result<Rustore.DownloadResponse>) {
        if (info == null) {
            result.error(Exception("app info not found"))
            return
        }

        manager.startUpdateFlow(info!!, AppUpdateOptions.Builder().build())
            .addOnSuccessListener { status ->
                val response = Rustore.DownloadResponse.Builder()
                    .setCode(status.toLong())
                    .build()

                result.success(response)
            }
            .addOnFailureListener { throwable ->
                Log.d("FlutterRustoreUpdate", throwable.toString())
                result.error(throwable)
            }
    }

    override fun completeUpdateSilent(result: Rustore.VoidResult) {
        manager.completeUpdate(AppUpdateOptions.Builder().appUpdateType(SILENT).build())
            .addOnSuccessListener {
                result.success()
            }
            .addOnFailureListener { throwable ->
                result.error(throwable)
            }
    }

    override fun completeUpdateFlexible(result: Rustore.VoidResult) {
        manager.completeUpdate(AppUpdateOptions.Builder().appUpdateType(FLEXIBLE).build())
            .addOnSuccessListener {
                result.success()
            }
            .addOnFailureListener { throwable ->
                result.error(throwable)
            }
    }

    fun startStateStream(events: EventChannel.EventSink) {
        eventSink = events
        ensureStateObserver()
    }

    fun stopStateStream() {
        eventSink = null
        stopObservingIfIdle()
    }

    private fun ensureStateObserver() {
        if (installStateUpdateListener != null) {
            return
        }

        val listener = InstallStateUpdateListener { state ->
            val response = createRequestResponse(state)

            eventSink?.success(createStatePayload(response))

            val callback = pendingLegacyResult
            if (callback != null) {
                pendingLegacyResult = null
                callback.success(response)
            } else {
                lastKnownState = response
            }

            stopObservingIfIdle()
        }

        installStateUpdateListener = listener
        manager.registerListener(listener)
    }

    private fun stopObservingIfIdle() {
        if (eventSink != null || pendingLegacyResult != null || lastKnownState != null) {
            return
        }

        val listener = installStateUpdateListener ?: return
        manager.unregisterListener(listener)
        installStateUpdateListener = null
    }

    private fun createRequestResponse(state: InstallState): Rustore.RequestResponse {
        return Rustore.RequestResponse.Builder()
            .setBytesDownloaded(state.bytesDownloaded)
            .setInstallErrorCode(state.installErrorCode.toLong())
            .setInstallStatus(state.installStatus.toLong())
            .setPackageName(state.packageName)
            .setTotalBytesToDownload(state.totalBytesToDownload)
            .build()
    }

    private fun createStatePayload(state: Rustore.RequestResponse): List<Any> {
        return listOf(
            state.bytesDownloaded,
            state.installErrorCode,
            state.installStatus,
            state.packageName,
            state.totalBytesToDownload,
        )
    }
}
