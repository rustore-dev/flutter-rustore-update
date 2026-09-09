package ru.rustore.flutter_rustore_update

import android.content.Context
import io.flutter.plugin.common.EventChannel
import io.flutter.embedding.engine.plugins.FlutterPlugin
import ru.rustore.flutter_rustore_update.pigeons.Rustore

/** FlutterRustoreUpdatePlugin */
class FlutterRustoreUpdatePlugin : FlutterPlugin {
    private lateinit var context: Context
    private var stateEventChannel: EventChannel? = null
    private var client: FlutterRustoreUpdateClient? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext

        client = FlutterRustoreUpdateClient(context)
        val streamClient = client ?: return
        stateEventChannel = EventChannel(binding.binaryMessenger, "ru.rustore.flutter_rustore_update/state")
        stateEventChannel?.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                streamClient.startStateStream(events)
            }

            override fun onCancel(arguments: Any?) {
                streamClient.stopStateStream()
            }
        })
        Rustore.RustoreUpdate.setUp(binding.binaryMessenger, streamClient)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        client?.stopStateStream()
        stateEventChannel?.setStreamHandler(null)
        stateEventChannel = null
        client = null
    }
}
