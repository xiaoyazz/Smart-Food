//
//  SmartFoodApp.swift
//  SmartFood
//
//  Created by Xiaoya Zou on 2024-11-02.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct SmartFoodApp: App {
    
    @StateObject private var foodViewModel = FoodViewModel()
    @StateObject private var foodCategoryViewModel = FoodCategoryViewModel()
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                        }

                AddFoodView()
                    .tabItem {
                        Label("Add", systemImage: "plus.circle")
                        }

                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                        }
                  }
            .environmentObject(foodCategoryViewModel)
            .environmentObject(foodViewModel)
        }
    }
}
