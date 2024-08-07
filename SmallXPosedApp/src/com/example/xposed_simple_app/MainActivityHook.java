package com.example.xposed_simple_app;

import de.robv.android.xposed.*;
import de.robv.android.xposed.callbacks.*;



public class MainActivityHook implements IXposedHookLoadPackage{


    @Override
    public void handleLoadPackage(XC_LoadPackage.LoadPackageParam param) throws Throwable {
if(param.packageName.equals("com.example.simple_app")){


XposedHelpers.findAndHookMethod("com.example.simple_app.MainActivity", param.classLoader,"getColor", new XC_MethodHook() {

    @Override
    protected void afterHookedMethod(MethodHookParam mparam) throws Throwable {
mparam.setResult(getMeGreenColor());
    }
});


}
    }


private int getMeGreenColor(){
return(0xFF00FF00);
}


}
