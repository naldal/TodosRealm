//
//  AppDelegate.swift
//  Todeuy
//
//  Created by 송하민 on 2021/08/04.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        do {
            _ = try Realm()
        } catch {
            print("Error initializing new realm \(error)")
        }
        
        return true
    }


}

