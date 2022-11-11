
package com.yacab.yacabadmin;
import com.yacab.yacabadmin.*;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
//import io.flutter.app.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.content.Intent;
import android.os.Build;
import android.content.pm.PackageManager;
import android.os.Bundle;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import android.view.View;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.Toast;




public class MainActivity extends FlutterActivity {
//    public static String restaurant_id;
    public static final int PERMISSION_REQUEST_CODE = 9001;
    private boolean mLocationPermissionGranted;
    private Intent forService;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        forService = new Intent(MainActivity.this,MyService.class);


        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(),"Yacab")
                .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                        if(methodCall.method.equals("startService")){
//                            MainActivity.restaurant_id =methodCall.argument("restaurant_id");
//                            System.out.println("Restaurant id = "+MainActivity.restaurant_id);

                            startService();
                            result.success("Service Started");
                        }
                    }
                });
    }
    @Override
    public void onRequestPermissionsResult(int requestCode,  String[] permissions,  int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        System.out.println("Entered into this");

        if(requestCode == PERMISSION_REQUEST_CODE && grantResults[0] == PackageManager.PERMISSION_GRANTED){
            mLocationPermissionGranted=true;
            System.out.println("Entered into this2");
        }else{
            System.out.println("Entered into this 3");

        }
    }
    @Override
    protected void onDestroy() {
        super.onDestroy();
        startService();
    }

    private void startService(){
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            startForegroundService(forService);
        } else {
            startService(forService);
        }
    }
   @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {

        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }
}
//import androidx.annotation.NonNull;
//import io.flutter.embedding.android.FlutterActivity;
//import io.flutter.embedding.engine.FlutterEngine;
//import io.flutter.plugins.GeneratedPluginRegistrant;
//
//public class MainActivity extends FlutterActivity {
//    @Override
//    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
//        System.out.println("Inside on Create method 2");
//        GeneratedPluginRegistrant.registerWith(flutterEngine);
//    }
//}
