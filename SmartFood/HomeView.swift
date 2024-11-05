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
    @EnvironmentObject private var foodViewModel : FoodViewModel
    @State private var searchText: String = ""
    @State private var searchRes : [Food] = []
    
    private var filteredCategories: [FoodCategory] {
        if searchText.isEmpty {
            return foodCategoryViewModel.categories
        } else {
            return foodCategoryViewModel.categories.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    let columns = [
        GridItem(.fixed(170), spacing: 16),
        GridItem(.fixed(170), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                // Grid layout
                ScrollView {
                    Spacer()
                    LazyVGrid(columns: columns, spacing: 18) {
                        ForEach(filteredCategories, id: \.id) { category in
                            NavigationLink(destination: CategoryDetailsView(category: category)) {
                                CategoryCardView(category: category)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("What's In My Fridge")
            .onAppear {
                foodCategoryViewModel.fetchCategories() // Fetch categories when HomeView appears
            }
        }
        .searchable(text: $searchText)
    }
}

#Preview {
    HomeView()
        .environmentObject(FoodCategoryViewModel())
}
