//
//  ContentView.swift
//  Desserts
//
//  Created by Chris Ray on 8/25/24.
//

import SwiftUI

struct ContentView<T: MealDetailsProviding>: View {
    @StateObject private var viewModel: MealListViewModel
    private var mealDetailsProvider: T

    init(mealListProvider: MealListProviding, mealDetailsProvider: T) {
        _viewModel = StateObject(wrappedValue: MealListViewModel(provider: mealListProvider))
        self.mealDetailsProvider = mealDetailsProvider
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.meals, id: \.id) { summary in
                    NavigationLink {
                        MealDetailsView(provider: mealDetailsProvider, summary: summary)
                    } label: {
                        MealSummaryView(data: summary)
                    }
                }
            }
            .navigationTitle("Desserts")
            .refreshable {
                // Allows reloading in case fetching the meal list fails
                await viewModel.fetchMeals()
            }
            .task {
                // Fetch meals initially without requiring a refresh
                await viewModel.fetchMeals()
            }
        }
        .alert(isPresented: viewModel.errorBinding, error: viewModel.error) {}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            mealListProvider: MockMealListProvider(),
            mealDetailsProvider: MockMealDetailsProvider()
        )
    }
}
