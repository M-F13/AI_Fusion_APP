plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.maheen.fyp"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.maheen.fyp"
        minSdk = 23
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        vectorDrawables.useSupportLibrary = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    // 👇 Prevent compression of `.traineddata` files (correct way in Kotlin DSL)
//    applicationVariants.all {
//        val variant = this
//        variant.outputs.forEach {
//            (it as com.android.build.gradle.internal.api.BaseVariantOutputImpl)
//                .processResourcesProvider.configure {
//                    it.aaptOptions.noCompress += "traineddata"
//                }
//        }
//    }
}

flutter {
    source = "../.."
}


