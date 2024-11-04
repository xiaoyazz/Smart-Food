//
//  FoodCategories.swift
//  SmartFood
//
//  Created by Xiaoya Zou on 2024-11-03.
//

import Foundation
import FirebaseFirestore

struct FoodCategory: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var name: String
}
