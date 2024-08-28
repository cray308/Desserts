//
//  MockMealListProvider.swift
//  Desserts
//
//  Created by Chris Ray on 8/26/24.
//

import Foundation

struct MockMealListProvider: MealListProviding {
    var bundle: Bundle = .main
    var fileName: String = "Desserts"

    func fetchMeals() async throws -> [MealSummary] {
        guard let response: MealListResponse = bundle.loadFile(fileName) else {
            throw DessertsError.failedRequest
        }
        return response.meals
    }
}
