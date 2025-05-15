plugins {
    id("com.android.application")
    id("kotlin-android")// The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.rideconnect"
    compileSdk = 35
    ndkVersion = "29.0.13113456"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }

defaultConfig {
    applicationId = "com.example.rideconnect"
    minSdk = 23
    targetSdk = 35
    versionCode = 1
    versionName = "1.0"
}


    buildTypes {
        getByName("release") {
            isMinifyEnabled = true  // Enable code shrinking
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        getByName("debug") {
            isMinifyEnabled = false  // Disable for debug builds
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
dependencies {
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.11.0")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")
    
    // Add your Firebase dependencies here
    implementation(platform("com.google.firebase:firebase-bom:32.7.2"))
    implementation("com.google.firebase:firebase-analytics")
    // Add other Firebase products you need
}