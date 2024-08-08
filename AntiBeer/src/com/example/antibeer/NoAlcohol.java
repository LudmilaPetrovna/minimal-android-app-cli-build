package com.example.antibeer;

import de.robv.android.xposed.*;
import de.robv.android.xposed.callbacks.*;



public class NoAlcohol implements IXposedHookLoadPackage{


@Override
public void handleLoadPackage(XC_LoadPackage.LoadPackageParam param) throws Throwable {

// patch "test-keys" in TAGS
Object tags_object=XposedHelpers.getStaticObjectField(android.os.Build.class, "TAGS");
String tags=(String)tags_object;
XposedBridge.log("We found build tags: "+tags);
String tags_new=tags.replace("test-key","release-key");
if(!tags.equals(tags_new)){
XposedHelpers.setStaticObjectField(android.os.Build.class, "TAGS",tags_new);
}

// patch "which" tool
XposedHelpers.findAndHookMethod("java.lang.Runtime", param.classLoader, "exec", String[].class, new XC_MethodHook() {
protected void afterHookedMethod(MethodHookParam mparam) throws Throwable {
Object[] args=mparam.args;
if(args.length>0){
String[] path=(String[])args[0];
XposedBridge.log("AFTER Runtime EXEC filename: "+path[0]);
if(path[0].startsWith("which")){
mparam.setResult(null);
}
}
}

});

XposedHelpers.findAndHookConstructor("java.io.File", param.classLoader, String.class, String.class, new XC_MethodHook() {
@Override
protected void beforeHookedMethod(MethodHookParam mparam) throws Throwable {
Object[] args=mparam.args;
if(args.length>1){
String path=(String)args[0];
String filename=(String)args[1];

XposedBridge.log("BEFORE File opened filename: "+path+"/"+filename);
if(filename.equals("su") || filename.equals("busybox") || filename.equals("magisk")){
XposedBridge.log("try to set null");
args[0]=(Object)"/Not_a_file_here";
args[1]=(Object)"Not_a_file_here";
}
}
}

protected void afterHookedMethod(MethodHookParam mparam) throws Throwable {
Object[] args=mparam.args;
if(args.length>1){
String path=(String)args[0];
String filename=(String)args[1];
XposedBridge.log("AFTER File opened filename: "+path+"/"+filename);
}
}

});


// patch native method
XposedHelpers.findAndHookMethod("com.scottyab.rootbeer.RootBeerNative", param.classLoader, "checkForRoot", Object[].class, new XC_MethodHook() {
@Override
protected void afterHookedMethod(MethodHookParam mparam) throws Throwable {
mparam.setResult(0);
}
});


} // /handleLoadPackage


} // /main class