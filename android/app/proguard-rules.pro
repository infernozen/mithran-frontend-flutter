# Flutter wrapper
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**

# ML Kit keep rules
-keep class com.google.mlkit.vision.text.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_text_common.** { *; }

# Optional: Prevent obfuscation for other important classes
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**
