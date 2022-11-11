import UIKit
import Flutter
import AVFoundation
import Firebase
import GoogleMaps
import CoreLocation
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,CLLocationManagerDelegate {
let locationManager=CLLocationManager()

var user_id=""
var player: AVAudioPlayer?


    override func applicationWillResignActive(_ application: UIApplication) {
//      print("applicationWillResignActive ");
//      self.track_location()
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    override func applicationDidEnterBackground(_ application: UIApplication) {
     print("applicationDidEnterBackground ");
     self.track_location()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    override func applicationWillEnterForeground(_ application: UIApplication) {
     print("applicationWillEnterForeground ");
     self.track_location()
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    override func applicationDidBecomeActive(_ application: UIApplication) {
//      print("applicationDidBecomeActive ");
//      self.track_location()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    override func applicationWillTerminate(_ application: UIApplication) {
    print("applicationWillTerminate ");
    self.track_location()
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    @objc func update() {
      self.locationManager.requestAlwaysAuthorization()
                self.locationManager.requestWhenInUseAuthorization()
                if(CLLocationManager.locationServicesEnabled()){
                print("Enabled ");
                 print("called ");
                        locationManager.delegate=self
                        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                        locationManager.startUpdatingLocation()
                }
                else
                {
                print("Disabled ");
                }

    }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
  FirebaseApp.configure()
   UNUserNotificationCenter.current().delegate = self
   let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
   UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })

   application.registerForRemoteNotifications()

   InstanceID.instanceID().instanceID { (result, _) in
       if result != nil {
           Messaging.messaging()
       }
   }

    print("Inside swift application ");
    do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [.mixWithOthers, .allowAirPlay])
                print("Playback OK")
                try AVAudioSession.sharedInstance().setActive(true)
                print("Session is Active")
            } catch {
                print(error)
            }

     let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let batteryChannel = FlutterMethodChannel(
        name: "Yacab",
        binaryMessenger: controller.binaryMessenger)

        batteryChannel.setMethodCallHandler({
          [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
          // Note: this method is invoked on the UI thread.
          guard call.method == "startService" else {
            result(FlutterMethodNotImplemented)
            return
          }
          guard let args = call.arguments as? [String : Any] else {return}
               self?.user_id = args["user_id"] as! String
               print(args["user_id"] as! String)
          self?.track_location()
        })
    GMSServices.provideAPIKey("AIzaSyCWzID_gJhk6KVT6xjs79zirn7QJGXpG-A")
    GeneratedPluginRegistrant.register(with: self)


        Messaging.messaging()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  private func stop()
  {
  if let player=player, player.isPlaying
  {
  print("Stopped");
    player.stop()

    }
  }

   private func play()
   {
   print("Inside play");
   if let player=player, player.isPlaying
   {


   }
   else
   {
   let url=Bundle.main.path(forResource: "notification",ofType:"mp3")
   do{
   try AVAudioSession.sharedInstance().setMode(.default)
   try AVAudioSession.sharedInstance().setActive(true,options: .notifyOthersOnDeactivation)
   guard let url=url else
   {
   print("null value in Url");
   print(url);
   return
   }
   player=try AVAudioPlayer(contentsOf: URL(fileURLWithPath:url))
    guard let player=player else
      {
      print("null value in player");
      return
      }
      player.play()
   }
   catch{
   print("Something went wrong")
   }
   }
   }

  private func track_location() {
  print("Ios specific code called ")
  print(self.user_id)
   self.locationManager.requestAlwaysAuthorization()
                     self.locationManager.requestWhenInUseAuthorization()
                     if(CLLocationManager.locationServicesEnabled()){
                     print("Enabled ");
                      print("called ");
                             locationManager.delegate=self
                             locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                             locationManager.startUpdatingLocation()
                     }
                     else
                     {
                     print("Disabled ");
                     }
  }
    func locationManager(_ manager : CLLocationManager,didUpdateLocations locations:[CLLocation])
          {
           print("locationManager called ");
              guard let fist=locations.first else {
              print("returning ");
                  return
              }
              print(locations.count)

              print(fist.coordinate.latitude)
              print(fist.coordinate.longitude)
              print(self.user_id)
              let object=[
              "latitude":fist.coordinate.latitude,
              "longitude":fist.coordinate.longitude
              ]
              let database = Database.database().reference().child("Bookings")
              .queryOrdered(byChild: "status").queryEqual(toValue : "Pending")
              database.observe(.childAdded, with: { (snapshot) in
                              if let dictionary = snapshot.value as? [String: AnyObject] {
                                  print("Key")
                                  print(snapshot.key)
                                  //Database.database().reference().child("order_requests").child(snapshot.key).updateChildValues(object);

                              }
                          })
                            let database2 = Database.database().reference().child("Bookings")
                                        .queryOrdered(byChild: "status").queryEqual(toValue : "Pending")
                                        database2.observe(.childAdded, with: { (snapshot) in
                                                        if let dictionary = snapshot.value as? [String: AnyObject] {
                                                            print("snapshot value")
                                                            print(snapshot.key)
                                                            guard let status = dictionary["status"] as? String else {return}
//                                                             guard let driver_id = dictionary["driver_id"] as? String else {return}
//                                                             print("Driver ID")
//                                                             print(driver_id)
                                                           if status == "Pending"
                                                           {
                                                           self.play()
                                                           }
                                                           else
                                                           {
                                                            self.stop()
                                                           print("Status is")
                                                           print(status)

                                                           }

                                                        }
                                                    })



//               database.child("0").setValue(object);
              print("Database updated")

          }
}
