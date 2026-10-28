plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.vmo.mod"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.vmo.mod"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildFeatures {
        // AGP 9 disables resValue by default; flavors use it for app_name.
        resValues = true
    }

    // Flavors must match `--flavor <name>` and config/<name>.json.
    flavorDimensions += "environment"
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            resValue("string", "app_name", "Mod Dev")
        }
        create("stg") {
            dimension = "environment"
            applicationIdSuffix = ".stg"
            resValue("string", "app_name", "Mod Stg")
        }
        create("prod") {
            dimension = "environment"
            resValue("string", "app_name", "Mod")
        }
    }

    buildTypes {
        release {
            // TODO: Add a release signing config (key.properties) before shipping.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
