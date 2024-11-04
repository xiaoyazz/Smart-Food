//
//  FoodViewModel.swift
//  SmartFood
//
//  Created by Xiaoya Zou on 2024-11-03.
//

import Foundation
import Firebase
import FirebaseFirestore

class FoodViewModel : ObservableObject {
    @Published var foods: [Food] = []
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
       
       // Create
       func addFood(_ food: Food) {
           do {
               _ = try db.addDocument(from: food)
           } catch let error {
               print("Error adding food: \(error)")
           }
       }
       
       // Update
       func updateFood(_ food: Food) {
           if let id = food.id {
               do {
                   try db.document(id).setData(from: food)
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
    
    
}
