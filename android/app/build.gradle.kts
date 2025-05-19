// Ajoute cette ligne après les autres plugins
plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.ecogestion"  // Modifier pour correspondre à AndroidManifest.xml
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.ecogestion"  // Modifier pour correspondre à AndroidManifest.xml
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true  // Ajouter cette ligne
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Import the Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:33.0.0"))
    
    // Add the dependency for Firebase Authentication
    implementation("com.google.firebase:firebase-auth")
    
    // Ajouter cette dépendance pour le support multidex
    implementation("androidx.multidex:multidex:2.0.1")
    
    // Ajouter cette dépendance pour le désucrage Java 8
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:1.1.5")
}

android {
    ndkVersion = "27.0.12077973"
    
    defaultConfig {
        minSdkVersion(23)  // Changer de 21 à 23
    }
}
