# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class com.google.firebase.** { *; }

# Keep your application class if you use it for Flutter initialization
-keep class com.yourpackage.** { *; }

# Prevent R8 from stripping interface information
-keep class **.R
-keep class **.R$* {
    <fields>;
}