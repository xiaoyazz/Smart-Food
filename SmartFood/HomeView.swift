//
//  HomeView.swift
//  SmartFood
//
//  Created by Xiaoya Zou on 2024-11-03.
//

import SwiftUI

// HomeView - show food vategory list
struct HomeView: View {
    
    // Initialize Food Categoruy ViewModel
    @EnvironmentObject private var foodCategoryViewModel : FoodCategoryViewModel
    
    let foodImages = ["food1", "food2", "food3", "food4", "food5"]
    
    var body: some View {
        NavigationStack {
            VStack {
                
                // Horizontal Image Carousel
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(foodImages, id: \.self) { imageName in
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 250, height: 150)
                                .clipped()
                                .cornerRadius(10)
                                .shadow(radius: 4)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 10)
                
                List{
                    // Filter out the nil IDs
                    ForEach(foodCategoryViewModel.categories.compactMap { $0.id != nil ? $0 : nil }, id: \.id) { category in
                        NavigationLink(destination: CategoryDetailsView(category: category)) {
                            Text(category.name)
                        }
                    }
                }
                .navigationTitle("Home")
                .listStyle(.grouped)
            }
            .onAppear {
                foodCategoryViewModel.fetchCategories() // Fetch categories when HomeView appears
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(FoodCategoryViewModel())
}
