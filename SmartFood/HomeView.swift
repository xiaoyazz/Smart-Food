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
    
    var body: some View {
        NavigationStack {
            VStack {
                List{
                    // Filter out the nil IDs
                    ForEach(foodCategoryViewModel.categories.compactMap { $0.id != nil ? $0 : nil }, id: \.id) { category in
                        NavigationLink(destination: CategoryDetailsView(category: category)) {
                            Text(category.name)
                        }
                    }
                }
                .navigationTitle("Home")
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
