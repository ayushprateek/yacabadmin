package com.yacab.yacabadmin;
import android.app.NotificationManager;
import androidx.annotation.NonNull;
import com.yacab.yacabadmin.*;
import android.app.Notification;
import android.app.NotificationChannel;

import android.content.Intent;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.firebase.database.ValueEventListener;
import android.os.Build;
import android.os.IBinder;
import android.os.Bundle;
import android.content.Context;
//import android.location.Location;
//import android.location.LocationListener;
//import android.location.LocationManager;
import android.graphics.Color;
import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;
import android.widget.Toast;
import android.app.Service;
import android.os.Looper;
import android.util.Log;
import java.util.*;

//import com.google.android.gms.location.FusedLocationProviderClient;
//import com.google.android.gms.location.LocationCallback;
//import com.google.android.gms.location.LocationRequest;
//import com.google.android.gms.location.LocationResult;
//import com.google.android.gms.location.LocationServices;
import com.google.android.gms.tasks.Task;
import com.google.firebase.database.ChildEventListener;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import android.media.MediaPlayer;

import java.util.HashMap;
import com.google.firebase.database.DataSnapshot;

//class MyThread extends Thread {
//    static Thread mt;
//    static MyService o;
//
//    MediaPlayer player;
//    DatabaseReference databaseReference, bookings;
//    public void run()
//    {
//        try
//        {
//            for(int i=0; ;i++)
//            {
//                System.out.println("Sleeping Thread");
//                bookings = FirebaseDatabase.getInstance().getReference("Bookings");
//
//
//                bookings.get().addOnCompleteListener(new OnCompleteListener<DataSnapshot>() {
//                    @Override
//                    public void onComplete(@NonNull Task<DataSnapshot> task) {
//
//                        if (task.isSuccessful()){
//
//                            if (task.getResult().exists()){
//                                System.out.println("Database exists");
//                                DataSnapshot dataSnapshot = task.getResult();
//
//                                for (DataSnapshot ds: dataSnapshot.getChildren()){
//                                    String key = ds.getKey();
//                                    bookings.child(key).get().addOnCompleteListener(new OnCompleteListener<DataSnapshot>() {
//                                        @Override
//                                        public void onComplete(@NonNull Task<DataSnapshot> task) {
//                                            if (task.isSuccessful()){
//                                                if (task.getResult().exists()){
//                                                    DataSnapshot dataSnapshot = task.getResult();
//                                                    String restaurant_id = String.valueOf(dataSnapshot.child("restaurant_id").getValue());
//                                                    String status = String.valueOf(dataSnapshot.child("status").getValue());
//                                                    String driver_id = String.valueOf(dataSnapshot.child("driver_id").getValue());
//                                                    System.out.println("Status = "+status);
//                                                    System.out.println("Driver ID = "+driver_id);
//                                                    //if(restaurant_id.equals(MainActivity.restaurant_id) && status.equals("Pending"))
//                                                    if(status.equals("Pending") && driver_id.equals("null"))
//                                                    {
//                                                        System.out.println("Playing = ");
//
//                                                        play();
//                                                    }
//
//
//
//                                                }
//
//
//                                            }
//
//                                        }
//                                    });
//                                }
//
//
//
//                            }
//
//
//                        }
//
//                    }
//                });
//                Thread.sleep(2000);
//            }
//        }
//        catch(Exception e)
//        {
//
//        }
//    }
//    public void play() {
//        System.out.println("Inside play");
//        if (player == null) {
//            System.out.println("player is null");
//            player = MediaPlayer.create(o, R.raw.notification);
//            player.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
//                @Override
//                public void onCompletion(MediaPlayer mp) {
//                    stopPlayer();
//                }
//            });
//        }
//
//        player.start();
//    }
//    private void stopPlayer() {
//        if (player != null) {
//            player.release();
//            player = null;
////            Toast.makeText(this, "MediaPlayer released", Toast.LENGTH_SHORT).show();
//        }
//    }
//}
public class MyService extends Service {
    MediaPlayer player;
//    private LocationManager mLocationManager;
//    private LocationListener mLocationListener;
//    FusedLocationProviderClient fusedLocationProviderClient;
    private static double currentLat =0;
    private static double currentLon =0;
    DatabaseReference databaseReference,bookings;
    MyService o;
    private static int  count =0;
    public void play() {
        System.out.println("Inside play");
        if (player == null) {
            System.out.println("player is null");
            player = MediaPlayer.create(o, R.raw.notification);
            System.out.println("Playing Notification");
            player.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
                @Override
                public void onCompletion(MediaPlayer mp) {
                    play();
                }
            });
        }

        player.start();
    }

    private void stopPlayer() {
        if (player != null) {
            player.release();
            player = null;
        }
    }
//    LocationCallback locationCallback = new LocationCallback() {
//        @Override
//        public void onLocationResult(LocationResult locationResult) {
//            List<Location> locationList = locationResult.getLocations();
//            if (locationList.size() > 0) {
//                //The last location in the list is the newest
//                Location location = locationList.get(locationList.size() - 1);
//                Log.i("MapsActivity", "Location: " + location.getLatitude() + " " + location.getLongitude());
//
//                count++;
//                HashMap User = new HashMap();
//                User.put("latitude",location.getLatitude());
//                User.put("longitude",location.getLongitude());
//                order_requests = FirebaseDatabase.getInstance().getReference("order_requests");
//
//
//                order_requests.get().addOnCompleteListener(new OnCompleteListener<DataSnapshot>() {
//                    @Override
//                    public void onComplete(@NonNull Task<DataSnapshot> task) {
//
//                        if (task.isSuccessful()){
//
//                            if (task.getResult().exists()){
//                                DataSnapshot dataSnapshot = task.getResult();
//
//                                for (DataSnapshot ds: dataSnapshot.getChildren()){
//                                    String key = ds.getKey();
//                                    order_requests.child(key).get().addOnCompleteListener(new OnCompleteListener<DataSnapshot>() {
//                                        @Override
//                                        public void onComplete(@NonNull Task<DataSnapshot> task) {
//
//                                            if (task.isSuccessful()){
//
//                                                if (task.getResult().exists()){
//                                                    DataSnapshot dataSnapshot = task.getResult();
//                                                    String restaurant_id = String.valueOf(dataSnapshot.child("restaurant_id").getValue());
//                                                    String status = String.valueOf(dataSnapshot.child("status").getValue());
//
//                                                    if(restaurant_id.equals(MainActivity.restaurant_id) && status.equals("Pending"))
//                                                    {
//                                                       play();
//                                                    }
//
//
//
//                                                }
//
//
//                                            }
//
//                                        }
//                                    });
//                                }
//
//
//
//                            }
//
//
//                        }
//
//                    }
//                });
//
//
////                databaseReference = FirebaseDatabase.getInstance().getReference("delivery_boys");
////                databaseReference.get().addOnCompleteListener(new OnCompleteListener<DataSnapshot>() {
////                    @Override
////                    public void onComplete(@NonNull Task<DataSnapshot> task) {
////
////                        if (task.isSuccessful()){
////
////                            if (task.getResult().exists()){
////                                DataSnapshot dataSnapshot = task.getResult();
////
////                                for (DataSnapshot ds: dataSnapshot.getChildren()){
////                                    String key = ds.getKey();
////
////
////
////
////                                    databaseReference.child(key).get().addOnCompleteListener(new OnCompleteListener<DataSnapshot>() {
////                                        @Override
////                                        public void onComplete(@NonNull Task<DataSnapshot> task) {
////
////                                            if (task.isSuccessful()){
////
////                                                if (task.getResult().exists()){
//////
////
////                                                    DataSnapshot dataSnapshot = task.getResult();
////                                                    String restaurant_id = String.valueOf(dataSnapshot.child("restaurant_id").getValue());
////
////                                                    if(restaurant_id.equals(MainActivity.restaurant_id))
////                                                    {
////
////
////
////
////                                                        databaseReference.child(key).updateChildren(User);
////                                                    }
////
////
////
////                                                }
////
////
////                                            }
////
////                                        }
////                                    });
////
////
////
////
////
////
////
////
////
////
////                                }
////
////
////
////
////                            }
////
////
////                        }
////
////                    }
////                });
//            }
//        }
//    };
    @Override
    public void onCreate() {
        super.onCreate();
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

                String NOTIFICATION_CHANNEL_ID = "com.yacab.yacabadmin";
                String channelName = "Ya Cab admin";
                NotificationChannel chan = new NotificationChannel(NOTIFICATION_CHANNEL_ID, channelName, NotificationManager.IMPORTANCE_NONE);
                chan.setLightColor(Color.BLUE);
                chan.setLockscreenVisibility(Notification.VISIBILITY_PRIVATE);
                NotificationManager manager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
                assert manager != null;
                manager.createNotificationChannel(chan);

                NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID);
                Notification notification = notificationBuilder.setOngoing(true)
                        .setContentTitle("Ya Cab Admin is running in background")
                        .setPriority(NotificationManager.IMPORTANCE_MIN)
                        .setCategory(Notification.CATEGORY_SERVICE)
                        .build();
                startForeground(2, notification);
            }
            o = this;
            bookings = FirebaseDatabase.getInstance().getReference("Bookings");
            bookings.addChildEventListener(new ChildEventListener() {
                public void onChildAdded(DataSnapshot dataSnapshot, String previousKey) {
                    System.out.println("Add " + dataSnapshot.getKey() + " to UI after " + previousKey);
                    String status = String.valueOf(dataSnapshot.child("status").getValue());
                    String driver_id = String.valueOf(dataSnapshot.child("driver_id").getValue());
                    System.out.println("Status = " + status);
                    if (status.equals("Pending") /*|| driver_id.equals("null")*/) {
                        System.out.println("Playing = ");
                        play();
                    } else {
                        stopPlayer();
                    }
                }

                public void onChildChanged(DataSnapshot dataSnapshot, String s) {
                    System.out.println("Updated " + dataSnapshot.getKey() + " to UI after " + s);
                    String status = String.valueOf(dataSnapshot.child("status").getValue());
                    String driver_id = String.valueOf(dataSnapshot.child("driver_id").getValue());
                    System.out.println("Status = " + status);

                    if (status.equals("Pending") /*|| driver_id.equals("null")*/) {
                        System.out.println("Playing = ");
                        play();
                    } else {
                        stopPlayer();
                    }
                }

                public void onChildRemoved(DataSnapshot dataSnapshot) {
                }

                public void onChildMoved(DataSnapshot dataSnapshot, String s) {
                    System.out.println("Moved " + dataSnapshot.getKey() + " to UI after " + s);
                }

                public void onCancelled(DatabaseError firebaseError) {
                }
            });


        } catch (Exception e) {
            System.out.println("Stack Trace");
            e.printStackTrace();
            System.out.println("InterruptedException Occurred");
        }
    }
//    private void addListenerLocation() {
//        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
//
//            LocationManager lm = (LocationManager)getSystemService(Context.LOCATION_SERVICE);
//            Location location = lm.getLastKnownLocation(LocationManager.GPS_PROVIDER);
//            if(location!=null)
//            {
//                currentLat = location.getLongitude();
//                currentLon = location.getLatitude();
//            }
//
//            NotificationCompat.Builder builder = new NotificationCompat.Builder(this,"messages")
//                    .setContentText("to provide you nearby leads")
//                    .setContentTitle("Shuchi for Business is running in background")
//                    .setSmallIcon(R.drawable.launch_background);
//
//            startForeground(101,builder.build());
//
//        }
//
//        Context context = getApplicationContext();
//        mLocationManager = (LocationManager)
//                getSystemService(Context.LOCATION_SERVICE);
//        mLocationListener = new LocationListener() {
//            @Override
//            public void onLocationChanged(Location location) {
//
//
//                if(location!=null)
//                {
//
//
//
//                    currentLat = location.getLongitude();
//                    currentLon = location.getLatitude();
//                }
//
//
//
//
//
//
//
//            }
//
//            @Override
//            public void onStatusChanged(String provider, int status, Bundle extras) {
//            }
//
//            @Override
//            public void onProviderEnabled(String provider) {
//                Location lastKnownLocation = mLocationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
//                if(lastKnownLocation!=null){
//                    currentLat = lastKnownLocation.getLatitude();
//                    currentLon = lastKnownLocation.getLongitude();
//                }
//            }
//            @Override
//            public void onProviderDisabled(String provider) {
//            }
//
//        };
//        mLocationManager.requestLocationUpdates(
//                LocationManager.GPS_PROVIDER, 500, 10, mLocationListener);
//    }
//    @Override
//    public int onStartCommand(Intent intent, int flags, int startId) {
//        requestLocation();
//        return super.onStartCommand(intent, flags, startId);
//    }
//
//    private void requestLocation() {
//
//        LocationRequest locationRequest = new LocationRequest();
//        locationRequest.setInterval(5000);
//
//        locationRequest.setPriority(LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY);
//        fusedLocationProviderClient.requestLocationUpdates(locationRequest, locationCallback, Looper.myLooper());
//
//
//
//    }
    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}




