import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// โหลด key.properties อย่างปลอดภัย
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
val hasKeystore = if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
    listOf("storeFile","storePassword","keyAlias","keyPassword")
        .all { keystoreProperties.containsKey(it) && !keystoreProperties[it].toString().isBlank() }
} else {
    false
}

android {
    namespace = "com.example.moodi"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions { jvmTarget = JavaVersion.VERSION_11.toString() }

    defaultConfig {
        applicationId = "com.example.moodi"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasKeystore) {
            create("release") {
                storeFile = file(keystoreProperties["storeFile"]!!.toString())
                storePassword = keystoreProperties["storePassword"]!!.toString()
                keyAlias = keystoreProperties["keyAlias"]!!.toString()
                keyPassword = keystoreProperties["keyPassword"]!!.toString()
            }
        }
    }

    buildTypes {
        getByName("release") {
            if (hasKeystore) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                throw GradleException(
                    "key.properties ไม่พร้อมหรือคีย์หาย (storeFile/storePassword/keyAlias/keyPassword). " +
                    "ตรวจตำแหน่งไฟล์ android/key.properties และค่าข้างในให้ถูกต้อง"
                )
                // ถ้าอยากให้ build ผ่านด้วย debug key ชั่วคราว ให้ใช้บรรทัดนี้แทน throw:
                // signingConfig = signingConfigs.getByName("debug")
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

flutter { source = "../.." }
