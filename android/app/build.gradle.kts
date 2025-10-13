import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.nickotmazgin.chipcompanion"
    compileSdk = 36
    ndkVersion = "26.3.11579264"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // Unique Application ID for Chip Companion
        applicationId = "com.chipcompanion.app.chip_companion"
        minSdk = flutter.minSdkVersion
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Load keystore properties if present. Support multiple common locations
    // (android/, android/app/, or project root one level above android/).
    val keystorePropertiesFile = listOf(
        // Typical location recommended by Android docs
        rootProject.file("key.properties"),
        // Some projects keep secrets one level above the android/ folder
        rootProject.file("../key.properties"),
        // Fallbacks relative to the :app module directory
        file("key.properties"),
        file("../../key.properties"),
    ).firstOrNull { it.exists() }

    signingConfigs {
        keystorePropertiesFile?.let { ksFile ->
            create("release") {
                val props = Properties().apply {
                    load(FileInputStream(ksFile))
                }
                // Resolve the storeFile relative to the key.properties location first,
                // falling back to rootProject if needed.
                val storeFilePath = props.getProperty("storeFile")
                val resolvedStoreFile = ksFile.parentFile?.resolve(storeFilePath)
                storeFile = when {
                    resolvedStoreFile != null && resolvedStoreFile.exists() -> resolvedStoreFile
                    rootProject.file(storeFilePath).exists() -> rootProject.file(storeFilePath)
                    else -> file(storeFilePath)
                }
                // Allow overriding keystore type via properties (e.g., pkcs12)
                props.getProperty("storeType")?.let { st ->
                    storeType = st
                }
                storePassword = props.getProperty("storePassword")
                keyAlias = props.getProperty("keyAlias")
                keyPassword = props.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            // Security: Disabled minification to avoid compatibility issues
            // For production, enable with proper ProGuard rules
            isMinifyEnabled = false
            isShrinkResources = false
            // proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            // Apply signing config only if key.properties was found
            keystorePropertiesFile?.let {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }
}

flutter {
    source = "../.."
}
