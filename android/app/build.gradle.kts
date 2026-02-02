plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.humandesign.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.humandesign.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            // Release signing configuration
            // Before release, create a keystore and configure these properties
            // in ~/.gradle/gradle.properties or as environment variables:
            //   HUMAN_DESIGN_KEYSTORE_FILE=/path/to/keystore.jks
            //   HUMAN_DESIGN_KEYSTORE_PASSWORD=your_password
            //   HUMAN_DESIGN_KEY_ALIAS=your_alias
            //   HUMAN_DESIGN_KEY_PASSWORD=your_key_password
            val keystoreFile = System.getenv("HUMAN_DESIGN_KEYSTORE_FILE")
            if (keystoreFile != null && file(keystoreFile).exists()) {
                storeFile = file(keystoreFile)
                storePassword = System.getenv("HUMAN_DESIGN_KEYSTORE_PASSWORD")
                keyAlias = System.getenv("HUMAN_DESIGN_KEY_ALIAS")
                keyPassword = System.getenv("HUMAN_DESIGN_KEY_PASSWORD")
            }
        }
    }

    buildTypes {
        release {
            // Use release signing if configured, otherwise fall back to debug for development
            val releaseConfig = signingConfigs.findByName("release")
            signingConfig = if (releaseConfig?.storeFile != null) {
                releaseConfig
            } else {
                // Warning: Using debug keys - not suitable for production
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}
