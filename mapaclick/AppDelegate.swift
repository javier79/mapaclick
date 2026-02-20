//
//  AppDelegate.swift
//  mapaclick
//
//  Created by javier pizarro on 9/21/23.
//

import UIKit
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //UserDefaults.standard.set(true, forKey: "removeAdsPurchased")
        //UserDefaults.standard.removeObject(forKey: "removeAdsPurchased")
        // Initialize Google Mobile Ads SDK
        MobileAds.shared.start()
        StoreManager.shared.fetchProduct()
        AdManager.shared.checkForExistingPaidUser()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

