package com.example.caker

import io.flutter.embedding.android.FlutterActivity
import android.content.Intent
import android.app.Service
import android.os.Bundle

class MainActivity: FlutterActivity() {
    override fun onResume() {
        super.onResume()
        startService(Intent(this, AppLaunchDetectorService::class.java))
    }
}