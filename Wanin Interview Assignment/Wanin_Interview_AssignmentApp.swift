//
//  Wanin_Interview_AssignmentApp.swift
//  Wanin Interview Assignment
//
//  Created by Dogpa's MBAir M1 on 2021/12/28.
//

import SwiftUI
import Firebase

@main
struct Wanin_Interview_AssignmentApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
