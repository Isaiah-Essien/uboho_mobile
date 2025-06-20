# Required for TFLite GPU and NNAPI delegates
-keep class org.tensorflow.** { *; }
-dontwarn org.tensorflow.**

# Keep class members used by reflection
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}
