//
//  CategoryCardView.swift
//  SmartFood
//
//  Created by Xiaoya Zou on 2024-11-04.
//

import SwiftUI

struct CategoryCardView: View {
    var category: FoodCategory

    var body: some View {
        VStack {
            Image(category.imageName)
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(category.name)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .frame(width: 150, height: 150) // Set fixed width and height for consistency
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray, lineWidth: 0.5) // Add border with specified color and width
        )
        .cornerRadius(12)
//        .shadow(radius: 2)
    }
}

#Preview {
    CategoryCardView(category: FoodCategory(name: "Default Category", imageName: "image"))
}
