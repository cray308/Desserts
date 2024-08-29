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
    @State private var didFetchMeals: Bool = false

    init(mealListProvider: MealListProviding, mealDetailsProvider: T) {
        _viewModel = StateObject(wrappedValue: MealListViewModel(provider: mealListProvider))
        self.mealDetailsProvider = mealDetailsProvider
    }

    var body: some View {
        NavigationView {
            mainContent
            .navigationTitle("Desserts")
            .toolbar(content: { toolbarContent })
            .task {
                // Fetch meals initially without requiring a refresh
                if !didFetchMeals {
                    await viewModel.fetchMeals()
                    didFetchMeals = true
                }
            }
        }
        .alert(isPresented: viewModel.errorBinding, error: viewModel.error) {}
    }

    @ViewBuilder var mainContent: some View {
        if viewModel.isLoading {
            ProgressView()
        } else {
            List {
                ForEach(viewModel.meals, id: \.id) { summary in
                    NavigationLink {
                        MealDetailsView(provider: mealDetailsProvider, summary: summary)
                    } label: {
                        MealSummaryView(data: summary)
                    }
                }
            }
        }
    }

    @ToolbarContentBuilder var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                Task {
                    // Allows reloading in case fetching the meal list fails
                    await viewModel.fetchMeals()
                }
            } label: {
                Label("Refresh", systemImage: "arrow.clockwise")
            }
            .disabled(viewModel.isLoading)
        }
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
