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

    private var hasError: Bool = false
    private(set) var error: DessertsError?
    @Published private(set) var meals: [MealSummary] = []

    init(provider: MealListProviding) {
        self.provider = provider
    }

    var errorBinding: Binding<Bool> {
        Binding(
            get: { self.hasError },
            set: { self.hasError = $0 }
        )
    }

    func fetchMeals() async {
        do {
            let meals = try await provider.fetchMeals()
            let sortedMeals = meals.sorted()
            await MainActor.run {
                self.meals = sortedMeals
            }
        } catch {
            logger.error("Encountered error: \(error.localizedDescription)")
            await MainActor.run {
                self.error = error as? DessertsError ?? .unexpected(error)
                self.meals = []
                self.hasError = true
            }
        }
    }
}
