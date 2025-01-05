package com.example.caker;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.os.IBinder;
import android.util.Log;
import androidx.core.app.NotificationCompat;
import android.app.usage.UsageEvents;
import android.app.usage.UsageStats;
import android.app.usage.UsageStatsManager;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.FlutterEngineCache;

public class AppLaunchDetectorService extends Service {
    private static final String CHANNEL_ID = "AppLaunchServiceChannel";
    private static final String METHOD_CHANNEL = "com.example.caker/overlay";
    private MethodChannel methodChannel;
    private FlutterEngine flutterEngine;

    @Override
    public void onCreate() {
        super.onCreate();
        
        flutterEngine = new FlutterEngine(this);
        flutterEngine.getDartExecutor().executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
        );
        if(flutterEngine != null){
            methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), METHOD_CHANNEL);
        } else {
            Log.e("AppLaunchDetector", "FlutterEngine is not initialized or not found in cache.");
        }
        /*flutterEngine.getDartExecutor().executeDartEntryPoint(
            DartExecutor.DartEntryPoint.createDefault()
        );
        */

        //createNotificationChannel();
        //startForeground(1, getNotification("Monitoring app launches NOW..."));

        //Initialize the MethodChannel for communication with Flutter
        //methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), METHOD_CHANNEL);
    }

    /*
    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel serviceChannel = new NotificationChannel(
                    CHANNEL_ID,
                    "App Launch Service Channel",
                    NotificationManager.IMPORTANCE_DEFAULT
            );
            NotificationManager manager = getSystemService(NotificationManager.class);
            manager.createNotificationChannel(serviceChannel);
        }
    }
    */

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        new Thread(() -> {
            UsageStatsManager usageStatsManager = (UsageStatsManager) getSystemService(Context.USAGE_STATS_SERVICE);
            long lastCheckedTime = System.currentTimeMillis(); // Start tracking from service start time
 
            while (true) {
                long currentTime = System.currentTimeMillis();
                UsageEvents usageEvents = usageStatsManager.queryEvents(lastCheckedTime, currentTime); // Query events since last checked
                UsageEvents.Event event = new UsageEvents.Event();
 
                while (usageEvents.hasNextEvent()) {
                    usageEvents.getNextEvent(event);
                    if (event.getEventType() == UsageEvents.Event.MOVE_TO_FOREGROUND) {
                        String packageName = event.getPackageName();
                        Log.d("AppLaunchDetector", "App in foreground: " + packageName);

                        // Send the app package name to Flutter
                        if(packageName.equals("com.instagram.android")) {
                            Log.d("AppLaunchDetector", "Attempting to Launch overlay after detecting: " + packageName);
                            triggerOverlay(packageName);
                        }
                    }
                }
 
                lastCheckedTime = currentTime; // Update the last checked time
 
                try {
                    Thread.sleep(1000); // Sleep for 1 second before checking again
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }).start();

        return START_STICKY;
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();

        if (flutterEngine != null) {
            flutterEngine.destroy();
        }

        Log.d("AppLaunchDetector","Service stopped");
        // Clean up resources if needed
    }

    private Notification getNotification(String content) {
        return new Notification.Builder(this, CHANNEL_ID)
                .setContentTitle("App Monitoring Service NOW NOW NOW")
                .setContentText(content)
                .setSmallIcon(android.R.drawable.ic_menu_info_details)
                .build();
    }

    private void triggerOverlay(String packer) {
        new Handler(Looper.getMainLooper()).post(() -> {
            if (methodChannel != null) {
                methodChannel.invokeMethod(packer, null);
                Log.d("AppLaunchDetector", "Message sent: "+packer);
            }
        });
    }
}