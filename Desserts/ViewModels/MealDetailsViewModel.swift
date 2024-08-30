//
//  MealDetailsViewModel.swift
//  Desserts
//
//  Created by Chris Ray on 8/25/24.
//

import Foundation
import OSLog

class MealDetailsViewModel: ObservableObject {
    private let logger = Logger(subsystem: "com.cray2.Desserts", category: "MealDetails")
    private let provider: MealDetailsProviding
    private let mealID: String

    private(set) var details: MealDetails?
    @Published private(set) var isLoading: Bool = true

    init(provider: MealDetailsProviding, mealID: String) {
        self.provider = provider
        self.mealID = mealID
    }

    func fetchMealDetails() async {
        do {
            details = try await provider.fetchDetails(id: mealID)
        } catch {
            logger.error("Encountered error: \(error.localizedDescription)")
        }

        await MainActor.run {
            isLoading = false
        }
    }
}
