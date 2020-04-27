package com.fascode.attributable

import android.content.Intent
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val mChannel = "com.fascode.attributable/installReferrer"
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, mChannel).setMethodCallHandler {
            call, result ->
            if("getInstallReferrer"==call.method){
                InstallReferrerHelper.readReferrer(this@MainActivity)?.let {
                    result.success(it)
                } ?: InstallReferrerHelper.start(context =this@MainActivity,
                onSuccess = { referrer ->
                    result.success(referrer)
                },
                onError = {
                    result.error("500", it, it);
                })
            }
        }
    }
}
