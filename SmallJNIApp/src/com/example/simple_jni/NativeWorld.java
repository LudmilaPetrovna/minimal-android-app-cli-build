package com.example.simple_jni;

import java.util.*;

public class NativeWorld{

static{
System.loadLibrary("nativeworld");
}

public native String wayFromSwitch(int i);
public native String wayFromArray(int i);
public native String wayFromSwitchGlobal();
public native String wayFromArrayGlobal();
public native void setGlobalId(int i);

}
