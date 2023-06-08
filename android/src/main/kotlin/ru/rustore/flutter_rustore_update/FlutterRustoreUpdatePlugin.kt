package ru.rustore.flutter_rustore_update

import android.content.Context
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import ru.rustore.flutter_rustore_update.pigeons.Rustore

/** FlutterRustoreUpdatePlugin */
class FlutterRustoreUpdatePlugin : FlutterPlugin {
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext

        val client = FlutterRustoreUpdateClient(context)
        Rustore.RustoreUpdate.setup(binding.binaryMessenger, client)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {

    }
}
