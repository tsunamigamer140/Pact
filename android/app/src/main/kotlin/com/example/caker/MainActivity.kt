package com.example.caker

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import androidx.annotation.NonNull
import android.view.WindowManager
import android.content.Intent
import android.app.Service
import android.os.Bundle

class MainActivity: FlutterActivity() {
    override fun onResume() {
        super.onResume()
        startService(Intent(this, AppLaunchDetectorService::class.java))
    }
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        window.setFlags(
            WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED// or
            //WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN or
            //WindowManager.LayoutParams.FLAG_LOCAL_FOCUS_MODE,
            ,
            WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED// or
            //WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN or
            //WindowManager.LayoutParams.FLAG_LOCAL_FOCUS_MODE
        )
        //window.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE or 
        //                  WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE)
    }
}