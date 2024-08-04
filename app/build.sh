# prepare fresh space

rm -r bin obj
mkdir bin obj

# compile java class

javac -Xlint:deprecation,-options -d obj -sourcepath src -source 1.6 -target 1.6 --class-path ../sdk/android.jar ./src/com/example/simple_app/MainActivity.java

# convert to DEX
dx --dex --verbose --no-optimize --keep-classes --output=bin/classes.dex obj

# package to APK resources and add DEX
aapt p -f -F bin/out.apk -I ../sdk/android.jar -S res -M AndroidManifest.xml
zip -9j bin/out.apk bin/classes.dex

# Generate new key, if here none

[ ! -e "shit.key" ] && keytool -genkey -keyalg rsa -keystore shit.key -storepass shit123 -keypass shit123 -alias shit -keysize 1024 -dname "CN=1, OU=2, O=shit" -validity 10000

# Signing apk with our key

jarsigner -verbose -keypass shit123 -storepass shit123 -keystore shit.key bin/out.apk shit

# Align. Well, not very need, but can improve perfomance.

zipalign -f -v 4 bin/out.apk bin/out-aligned.apk

adb install -r --bypass-low-target-sdk-block bin/out-aligned.apk
