//
//  FoodViewModel.swift
//  SmartFood
//
//  Created by Xiaoya Zou on 2024-11-03.
//

import Foundation
import Firebase
import FirebaseFirestore
import UserNotifications

class FoodViewModel : ObservableObject {
    
    @Published var foods: [Food] = []
    @Published var isNotificationEnabled: Bool = true
    
    private var db = Firestore.firestore().collection("Food")
    
    init() {

    }
    
    // Read
    func fetchFoods(forCategory categoryName: String) {
        db.whereField("category", isEqualTo: categoryName).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching foods for category \(categoryName): \(error)")
                return
            }
            
            self.foods = snapshot?.documents.compactMap { document in
                try? document.data(as: Food.self)
            } ?? []
        }
    }
    
    // fecth food by name string
    func fetchFoodByName() {
        db.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching food by name: \(error)")
                return
            }
            
            self.foods = snapshot?.documents.compactMap { document in
                var name = try? document.data(as: Food.self)
                name?.id = document.documentID
                if name?.id == nil {
                    print("Warning: Food name fetched without an id.")
                }
                return name
            } ?? []
        }
    }
       
       // Create
       func addFood(_ food: Food) {
           do {
               _ = try db.addDocument(from: food)
               
               if isNotificationEnabled {
                   scheduleExpiryNotification(for: food.name, expiryDate: food.expirationDate)
               }
           } catch let error {
               print("Error adding food: \(error)")
           }
       }
       
       // Update
       func updateFood(_ food: Food) {
           if let id = food.id {
               do {
                   try db.document(id).setData(from: food)
                   
                   if isNotificationEnabled {
                       scheduleExpiryNotification(for: food.name, expiryDate: food.expirationDate)
                   }
               } catch let error {
                   print("Error updating food: \(error)")
               }
           }
       }
       
       // Delete
    func deleteFood(_ food: Food) {
        if let id = food.id {
            db.document(id).delete { error in
                if let error = error {
                    print("Error deleting food: \(error)")
                }
            }
        }
    }
    
    // Request user notification
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error)")
            }
            print("Notification permission granted: \(granted)")
        }
    }
    
    // schedule a local notification
    func scheduleExpiryNotification(for foodName: String, expiryDate: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Food Expiry Reminder"
        content.body = "\(foodName) will expire tomorrow. Consider using it soon!"
        content.sound = .default

        // Calculate the time interval to trigger the notification 1 day (24 hours) before expiry
//        let oneDayBeforeExpiry = expiryDate.addingTimeInterval(-86400) // 86,400 seconds in a day
//        let timeInterval = oneDayBeforeExpiry.timeIntervalSinceNow
//
//        // Check if the interval is positive, meaning the expiry date is still in the future
//        if timeInterval > 0 {
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
//            let request = UNNotificationRequest(identifier: "\(foodName)_expiryReminder", content: content, trigger: trigger)
        
        if let imageURL = Bundle.main.url(forResource: "AppIcon", withExtension: "png") {
            let attachment = try? UNNotificationAttachment(identifier: "image", url: imageURL, options: nil)
            if let attachment = attachment {
                content.attachments = [attachment]
            }
        }

        
        // Set trigger to 5 seconds for testing
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "\(foodName)_testReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Test notification scheduled to trigger in 5 seconds.")
            }
        }

//            UNUserNotificationCenter.current().add(request) { error in
//                if let error = error {
//                    print("Error scheduling notification: \(error)")
//                } else {
//                    print("Notification scheduled 1 day before \(foodName)'s expiry.")
//                }
//            }
//        } else {
//            print("Expiry date has already passed or is within 24 hours.")
//        }
    }


    
    
}
