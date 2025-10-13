# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.

# Keep Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep microchip service classes
-keep class com.chipcompanion.app.chip_companion.services.** { *; }

# Security: Obfuscate sensitive data
-keepclassmembers class * {
    @com.chipcompanion.app.chip_companion.annotations.SensitiveData *;
}

# Keep in-app purchase classes
-keep class io.flutter.plugins.inapppurchase.** { *; }
-keep class com.android.billingclient.** { *; }

# Keep Bluetooth plugin classes
-keep class com.boskokg.flutter_blue_plus.** { *; }
-keep class com.lib.flutter_blue_plus.** { *; }

# Remove debug information
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}
