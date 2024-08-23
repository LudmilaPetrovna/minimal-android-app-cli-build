package com.example.simple_jni;

import java.io.*;
import java.util.*;
import android.app.*;
import android.content.*;
import android.os.*;
import android.text.*;
import android.util.*;
import android.view.*;
import android.widget.*;

public class MainActivity extends Activity{

TextView content=null;
NativeWorld n=null;

@Override
protected void onCreate(Bundle savedInstanceState){
super.onCreate(savedInstanceState);


LinearLayout l=new LinearLayout(this);
Button b1=new Button(this);
b1.setText("load lib");
b1.setOnClickListener(new View.OnClickListener(){

@Override
public void onClick(View arg0){
n=new NativeWorld();
}

});

Button b2=new Button(this);
b2.setText("access lib");
b2.setOnClickListener(new View.OnClickListener(){

@Override
public void onClick(View arg0){
n.setGlobalId((int)(Math.random()*3.0));
String p=n.wayFromSwitchGlobal()+"/"+n.wayFromArrayGlobal();
content.setText(p);
}

});

content=new TextView(this);

l.addView(b1);
l.addView(b2);
l.addView(content);

setContentView(l);

}

}
