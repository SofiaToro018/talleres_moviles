plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // Firebase Plugin
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.talleres_moviles"
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
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.talleres_moviles"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
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

// DEPENDENCIAS DE FIREBASE (COMENTADAS - ACTIVAR SI NECESITAS)
/*
dependencies {
    // Import the Firebase BoM (Bill of Materials)
    // Esto asegura que todas las dependencias de Firebase sean compatibles entre sí
    implementation(platform("com.google.firebase:firebase-bom:34.4.0"))

    // Firebase Core (requerido para todos los servicios)
    implementation("com.google.firebase:firebase-core")

    // Firebase Analytics (análisis de eventos de usuario)
    implementation("com.google.firebase:firebase-analytics")

    // Firebase Authentication (autenticación de usuarios)
    // implementation("com.google.firebase:firebase-auth")

    // Firebase Firestore (base de datos NoSQL)
    // implementation("com.google.firebase:firebase-firestore")

    // Firebase Storage (almacenamiento de archivos)
    // implementation("com.google.firebase:firebase-storage")

    // Firebase Cloud Messaging (notificaciones push)
    // implementation("com.google.firebase:firebase-messaging")

    // Firebase Realtime Database (base de datos en tiempo real)
    // implementation("com.google.firebase:firebase-database")

    // Firebase Crashlytics (reporte de errores)
    // implementation("com.google.firebase:firebase-crashlytics")

    // Firebase Remote Config (configuración remota)
    // implementation("com.google.firebase:firebase-config")

    // Nota: Descomenta las dependencias que necesites según tu proyecto
}
*/