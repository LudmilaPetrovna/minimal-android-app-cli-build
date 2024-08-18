rm -r tmp tmp-not-align.apk
mkdir tmp

unzip -d tmp "$1"

cd tmp
rm -r META-INF
rm ../tmp-not-align.apk 2> /dev/null
zip -v0r ../tmp-not-align.apk assets classes.dex resources.arsc
zip -v9r ../tmp-not-align.apk . -x "assets" -x "classes.dex" -x "resources.arsc"
cd ..

# Generate new key, if here none

[ ! -e "shit.key" ] && keytool -genkey -keyalg rsa -keystore shit.key -storepass shit123 -keypass shit123 -alias shit -keysize 1024 -dname "CN=1, OU=2, O=shit" -validity 10000

rm $1-rebuilded.apk 2> /dev/null
jarsigner -verbose -keypass shit123 -storepass shit123 -keystore shit.key tmp-not-align.apk shit
zipalign -f -v 4 tmp-not-align.apk $1-rebuilded.apk
apksigner sign --ks shit.key --ks-pass=pass:shit123 --key-pass=pass:shit123 $1-rebuilded.apk

adb install -r --bypass-low-target-sdk-block $1-rebuilded.apk
