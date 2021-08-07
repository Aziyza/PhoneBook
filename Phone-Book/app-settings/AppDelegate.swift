//
//  AppDelegate.swift
//  Phone-Book
//
//  Created by Mac on 8/6/21.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        do {
            _ = try Realm()
        } catch {
            print("Realm Error: \(error.localizedDescription)")
        }
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        
        window = UIWindow()
        let vc = ContactsVC(nibName: "ContactsVC", bundle: nil)
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
        
        return true
    }

}

