//
//  MealDetailsProvider.swift
//  Desserts
//
//  Created by Chris Ray on 8/25/24.
//

import Foundation

protocol MealDetailsProviding {
    func fetchDetails(id: String) async throws -> MealDetails
}

struct MealDetailsProvider: MealDetailsProviding {
    private let urlPrefix: String = "https://themealdb.com/api/json/v1/1/lookup.php?i="

    func fetchDetails(id: String) async throws -> MealDetails {
        let url = URL(string: urlPrefix + id)!
        let response: MealDetailsResponse = try await URLSession.shared.fetchData(from: url)
        guard let details = response.meals.first else {
            throw DessertsError.missingDetails
        }
        return details
    }
}
