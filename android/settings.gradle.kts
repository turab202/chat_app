pluginManagement {
    val flutterSdkPath = File(properties["flutter.sdk"]?.toString()
        ?: throw GradleException("Flutter SDK not found. Define location with flutter.sdk in the local.properties file."))

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-gradle-plugin") version "1.0.0" apply false
}

include(":app")