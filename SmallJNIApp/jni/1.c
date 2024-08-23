#ifdef ANDROID

#include <stdio.h>
#include "com_example_simple_jni_NativeWorld.h"

#else

#include <stdio.h>

#endif



char* way1(){
return("Way 1");
}

char* way2(){
return("Way 2");
}

char* way3(){
return("Way 3");
}

static char*(*ways[])()={way1,way2,way3,0,0};

static int global_id=-1;

char *way_switch(int i){
printf("access way_switch\n");
char *ret=0;
switch(i){
case 0:
ret=way1();
break;

case 1:
ret=way2();
break;

case 2:
ret=way3();
break;

default:
break;
}
return(ret);
}

char *way_switch_global(){
printf("access way_switch_global\n");
char *ret=0;
switch(global_id){
case 0:
ret=way1();
break;

case 1:
ret=way2();
break;

case 2:
ret=way3();
break;

default:
break;
}
return(ret);
}

char *way_array(int i){
printf("access way_array\n");
return(ways[i]());
}

char *way_array_global(){
printf("access way_array_global\n");
return(ways[global_id]());
}

void set_id(int i){
printf("access set_id\n");
global_id=i;
}

#ifdef ANDROID
JNIEXPORT jstring JNICALL Java_com_example_simple_1jni_NativeWorld_wayFromSwitch(JNIEnv *e, jobject t, jint v){
return (*e)->NewStringUTF(e,way_switch(v));
}
JNIEXPORT jstring JNICALL Java_com_example_simple_1jni_NativeWorld_wayFromArray(JNIEnv *e, jobject t, jint v){
return (*e)->NewStringUTF(e,way_array(v));
}
JNIEXPORT jstring JNICALL Java_com_example_simple_1jni_NativeWorld_wayFromSwitchGlobal(JNIEnv *e, jobject t){
return (*e)->NewStringUTF(e,way_switch_global());
}
JNIEXPORT jstring JNICALL Java_com_example_simple_1jni_NativeWorld_wayFromArrayGlobal(JNIEnv *e, jobject t){
return (*e)->NewStringUTF(e,way_array_global());
}
JNIEXPORT void JNICALL Java_com_example_simple_1jni_NativeWorld_setGlobalId(JNIEnv *e, jobject t, jint v){
set_id(v);
}

#else

int main(void){
printf("Hello, this is a main func!\n");
printf("This is way switch 2: %s\n",way_switch(2));
printf("This is way array 1: %s\n",way_array(1));
printf("Now set global value 1\n");
set_id(1);
printf("This is global way switch 2: %s\n",way_switch_global());
printf("This is global way array 1: %s\n",way_array_global());
printf("End of program!\n");

return 0;
}

#endif


