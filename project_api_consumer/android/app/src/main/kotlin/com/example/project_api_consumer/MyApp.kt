package com.example.flutter_example

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import com.tekartik.sqflite.SqflitePlugin

class MyApp : FlutterApplication(), PluginRegistrantCallback {

    override fun registerWith(registry: PluginRegistry) {
        com.tekartik.sqflite.SqflitePlugin.registerWith(
                registry.registrarFor("com.tekartik.sqflite.SqflitePlugin"))
    }
}