# prepare fresh space

rm -r bin obj
mkdir bin obj

ANDROID_JAR=../../sdk/android.jar

# compile native part

export NDK=/root/ndk/android-ndk-r10e
export TOOLCHAIN=$NDK/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86/

export CC=$TOOLCHAIN/bin/aarch64-linux-android-gcc
export AR=$TOOLCHAIN/bin/aarch64-linux-android-ar
export AS=$TOOLCHAIN/bin/aarch64-linux-android-as
export STRINGS=$TOOLCHAIN/bin/aarch64-linux-android-strings
export STRIP=$TOOLCHAIN/bin/aarch64-linux-android-strip
export RANLIB=$TOOLCHAIN/bin/aarch64-linux-android-ranlib
export OBJDUMP=$TOOLCHAIN/bin/aarch64-linux-android-objdump
export NM=$TOOLCHAIN/bin/aarch64-linux-android-nm
export LINKER=$TOOLCHAIN/bin/aarch64-linux-android-ld
export LD=$TOOLCHAIN/bin/aarch64-linux-android-ld
export CXX=$TOOLCHAIN/bin/aarch64-linux-android-g++
export OBJCOPY=$TOOLCHAIN/bin/aarch64-linux-android-objcopy

export PLATFORM_ROOT=$NDK/platforms/android-21/arch-arm64/
export CFLAGS="--sysroot $PLATFORM_ROOT"

mkdir -p lib/arm64-v8a
$CC $CFLAGS -DANDROID -ggdb3 -shared jni/1.c -o lib/arm64-v8a/libnativeworld.so

# compile java class

javac -h jni -d obj -source 1.7 -target 1.7 -cp src src/com/example/simple_jni/NativeWorld.java
javac -Xlint:deprecation,-options -d obj -sourcepath src -source 1.7 -target 1.7 --class-path $ANDROID_JAR ./src/com/example/simple_jni/MainActivity.java

# convert to DEX
dx --dex --verbose --no-optimize --keep-classes --output=bin/classes.dex obj

# package to APK resources and add DEX
aapt p -f -F bin/out.apk -I $ANDROID_JAR -S res -M AndroidManifest.xml
zip -9j bin/out.apk bin/classes.dex
zip -0r bin/out.apk lib

# Generate new key, if here none

[ ! -e "shit.key" ] && keytool -genkey -keyalg rsa -keystore shit.key -storepass shit123 -keypass shit123 -alias shit -keysize 1024 -dname "CN=1, OU=2, O=shit" -validity 10000

# Signing apk with our key

jarsigner -verbose -keypass shit123 -storepass shit123 -keystore shit.key bin/out.apk shit

# Align. Well, not very need, but can improve perfomance.

zipalign -f -v 4 bin/out.apk bin/out-aligned.apk

adb install -r --bypass-low-target-sdk-block bin/out-aligned.apk
