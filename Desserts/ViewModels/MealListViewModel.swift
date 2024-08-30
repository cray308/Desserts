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
            var meals = try await provider.fetchMeals()
            for i in 0..<meals.count {
                meals[i].name = meals[i].name.capitalized
            }
            self.meals = meals.sorted()
        } catch {
            logger.error("Encountered error: \(error.localizedDescription)")
            self.error = error as? DessertsError ?? .unexpected(error)
            self.meals = []
        }

        await MainActor.run {
            isLoading = false
        }
    }
}
