# minimal-android-app-cli-build
Very simple "Hello world" for Android, without AndroidStudiuo and SKotlin

# Requirements (in Debian)
```
apt-get install dexdump dalvik-exchange zipalign
ln -s /bin/dalvik-exchange /bin/dx
cd sdk
bash update.sh
```

# for native part

```
apt-get install p7zip-full gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu
cd ~
mkdir ndk
cd ndk
wget https://dl.google.com/android/ndk/android-ndk-r10e-linux-x86.bin
7z x android-ndk-r10e-linux-x86.bin
```

# Building
```
bash icon_gen.sh
bash build.sh
```
