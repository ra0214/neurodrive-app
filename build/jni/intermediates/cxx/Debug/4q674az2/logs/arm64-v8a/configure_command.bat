@echo off
"C:\\Users\\Asus\\AppData\\Local\\Android\\Sdk\\cmake\\3.22.1\\bin\\cmake.exe" ^
  "-HC:\\Users\\Asus\\AppData\\Local\\Pub\\Cache\\hosted\\pub.dev\\jni-1.0.0\\src" ^
  "-DCMAKE_SYSTEM_NAME=Android" ^
  "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" ^
  "-DCMAKE_SYSTEM_VERSION=21" ^
  "-DANDROID_PLATFORM=android-21" ^
  "-DANDROID_ABI=arm64-v8a" ^
  "-DCMAKE_ANDROID_ARCH_ABI=arm64-v8a" ^
  "-DANDROID_NDK=C:\\Users\\Asus\\AppData\\Local\\Android\\sdk\\ndk\\28.2.13676358" ^
  "-DCMAKE_ANDROID_NDK=C:\\Users\\Asus\\AppData\\Local\\Android\\sdk\\ndk\\28.2.13676358" ^
  "-DCMAKE_TOOLCHAIN_FILE=C:\\Users\\Asus\\AppData\\Local\\Android\\sdk\\ndk\\28.2.13676358\\build\\cmake\\android.toolchain.cmake" ^
  "-DCMAKE_MAKE_PROGRAM=C:\\Users\\Asus\\AppData\\Local\\Android\\Sdk\\cmake\\3.22.1\\bin\\ninja.exe" ^
  "-DCMAKE_LIBRARY_OUTPUT_DIRECTORY=C:\\Users\\Asus\\AndroidStudioProjects\\NeuroDrive\\build\\jni\\intermediates\\cxx\\Debug\\4q674az2\\obj\\arm64-v8a" ^
  "-DCMAKE_RUNTIME_OUTPUT_DIRECTORY=C:\\Users\\Asus\\AndroidStudioProjects\\NeuroDrive\\build\\jni\\intermediates\\cxx\\Debug\\4q674az2\\obj\\arm64-v8a" ^
  "-DCMAKE_BUILD_TYPE=Debug" ^
  "-BC:\\Users\\Asus\\AppData\\Local\\Pub\\Cache\\hosted\\pub.dev\\jni-1.0.0\\android\\.cxx\\Debug\\4q674az2\\arm64-v8a" ^
  -GNinja
