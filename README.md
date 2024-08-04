# minimal-android-app-cli-build
Very simple "Hello world" for Android, without AndroidStudiuo and SKotlin

# Requirements (in Debian)
```
apt-get install dexdump dalvik-exchange zipalign
ln -s /bin/dalvik-exchange /bin/dx
cd sdk
bash update.sh
```

# Building
```
bash icon_gen.sh
bash build.sh
```
