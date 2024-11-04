//
//  Food.swift
//  SmartFood
//
//  Created by Xiaoya Zou on 2024-11-03.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore

struct Food : Identifiable, Codable {
    
    @DocumentID var id: String?
    var name : String
    var quantity: Int
    var expirationDate: Date
    var category: String
}
