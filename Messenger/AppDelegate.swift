//
//  AppDelegate.swift
//  Messenger
//
//  Created by wajih on 8/16/22.
//

import UIKit
import Firebase
@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var firstRun : Bool?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // we need to initialize firebase
        FirebaseApp.configure()
        firstRunCheck()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    // MARK: - FirstRun
    private func firstRunCheck(){
        print("first run check")
        //we are going to ckeck for something called first key in our userDefaults
        firstRun = userDefaults.bool(forKey: KFIRSTRUN)
        if !firstRun! {
            print("this is first run")
            
            let status = Status.array.map{ $0.rawValue }
            
            userDefaults.set(status, forKey: KSTATUS)
            
            userDefaults.set(true, forKey: KFIRSTRUN)
            userDefaults.synchronize()
        }
    }

}

