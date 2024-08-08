
PACKAGE_NAME="com.example.antibeer"


ANDROID_JAR=../sdk/android.jar
XPOSED_JAR=libs/XposedBridgeApi-89.jar

# prepare fresh space

rm -r bin obj
mkdir bin obj res

# prepare manifest?

find src/ -iname "*.java" | tr "/" "." | sed "s,.java$,,g;s,^src.,,g" > assets/xposed_init

# compile java class

SRCFILES=`find src -iname "*.java" | tr "\n" " "`
javac -Xlint:-deprecation,-options -d obj -source 8 -target 8 -sourcepath src --class-path "$ANDROID_JAR":"$XPOSED_JAR" $SRCFILES

[ `find obj/ -iname "*.class" | wc -l` -lt 1 ] && exit

# convert to DEX
dx --dex --verbose --no-optimize --keep-classes --output=bin/classes.dex obj

# package to APK resources and add DEX
aapt p -f -F bin/out.apk -I "$ANDROID_JAR" -S "res" -M "AndroidManifest.xml"

zip -0r bin/out.apk assets
zip -9j bin/out.apk bin/classes.dex

# Generate new key, if here none

[ ! -e "shit.key" ] && keytool -genkey -keyalg rsa -keystore shit.key -storepass shit123 -keypass shit123 -alias shit -keysize 1024 -dname "CN=1, OU=2, O=shit" -validity 10000

# Signing apk with our key

jarsigner -verbose -keypass shit123 -storepass shit123 -keystore shit.key bin/out.apk shit

# Align. Well, not very need, but can improve perfomance.

zipalign -f -v 4 bin/out.apk bin/out-aligned.apk

# install now

adb shell kill force-stop com.scottyab.rootbeer.sample
adb shell am force-stop com.scottyab.rootbeer.sample

adb uninstall "$PACKAGE_NAME"
adb install -r --bypass-low-target-sdk-block bin/out-aligned.apk
