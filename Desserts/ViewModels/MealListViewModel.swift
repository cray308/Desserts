//
//  MealListViewModel.swift
//  Desserts
//
//  Created by Chris Ray on 8/25/24.
//

import SwiftUI
import OSLog

class MealListViewModel: ObservableObject {
    private let logger = Logger(subsystem: "com.cray2.Desserts", category: "MealList")
    private let provider: MealListProviding

    private(set) var error: DessertsError?
    private(set) var meals: [MealSummary] = []
    @Published private(set) var isLoading: Bool = true

    init(provider: MealListProviding) {
        self.provider = provider
    }

    var errorBinding: Binding<Bool> {
        Binding(
            get: { self.error != nil },
            set: { _ in
                self.error = nil
            }
        )
    }

    func fetchMeals() async {
        await MainActor.run {
            isLoading = true
        }

        do {
            let meals = try await provider.fetchMeals()
            let sortedMeals = meals.sorted()
            await MainActor.run {
                self.meals = sortedMeals
                self.isLoading = false
            }
        } catch {
            logger.error("Encountered error: \(error.localizedDescription)")
            await MainActor.run {
                self.error = error as? DessertsError ?? .unexpected(error)
                self.meals = []
                self.isLoading = false
            }
        }
    }
}
