//
//  MealListProvider.swift
//  Desserts
//
//  Created by Chris Ray on 8/25/24.
//

import Foundation

protocol MealListProviding {
    func fetchMeals() async throws -> [MealSummary]
}

struct MealListProvider: MealListProviding {
    private let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")!

    func fetchMeals() async throws -> [MealSummary] {
        let response: MealListResponse = try await URLSession.shared.fetchData(from: url)
        return response.meals
    }
}
