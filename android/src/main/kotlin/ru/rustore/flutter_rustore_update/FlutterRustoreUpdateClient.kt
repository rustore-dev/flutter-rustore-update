package ru.rustore.flutter_rustore_update

import android.content.Context
import android.util.Log
import ru.rustore.flutter_rustore_update.pigeons.Rustore
import ru.rustore.sdk.appupdate.manager.factory.RuStoreAppUpdateManagerFactory
import ru.rustore.sdk.appupdate.model.AppUpdateInfo
import ru.rustore.sdk.appupdate.model.AppUpdateOptions
import ru.rustore.sdk.appupdate.model.InstallStatus
import ru.rustore.sdk.appupdate.model.UpdateAvailability
import java.lang.Exception

class FlutterRustoreUpdateClient(private val context: Context) : Rustore.RustoreUpdate {
    private val manager = RuStoreAppUpdateManagerFactory.create(context)
    private var info: AppUpdateInfo? = null
    var progress: Rustore.Result<Rustore.RequestResponse>? = null

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

    override fun request(result: Rustore.Result<Rustore.RequestResponse>) {
        if (progress == null) {
            progress = result
            manager.registerListener { state ->
                progress?.success(
                    Rustore.RequestResponse.Builder()
                        .setBytesDownloaded(state.bytesDownloaded)
                        .setInstallErrorCode(state.installErrorCode.toLong())
                        .setInstallStatus(state.installStatus.toLong())
                        .setPackageName(state.packageName)
                        .setTotalBytesToDownload(state.totalBytesToDownload)
                        .build()
                )
            }
        }

        progress = result
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

    override fun complete(result: Rustore.Result<Void>) {
        manager.completeUpdate()
            .addOnSuccessListener {
                result.success(null)
            }
            .addOnFailureListener { throwable ->
                result.error(throwable)
            }
    }
}