//
//  AppDelegate.swift
//  MEPontaj
//
//  Created by Robert Oană on 08.08.2024.
//

import Foundation
import SwiftUI
import GoogleMaps
import netfox

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NFX.sharedInstance().start()
        GMSServices.provideAPIKey("AIzaSyBSPayaTcB4DSYEiMlzwXV42_atSKUfeSI")
        return true
    }
    
    private func eagerInit() { // MARK: REMOVE, THIS IF FOR EAGER INIT
//        let _ = resolve(InstallationService.self)
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
}

