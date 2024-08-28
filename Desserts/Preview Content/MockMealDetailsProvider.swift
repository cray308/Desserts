//
//  MockMealDetailsProvider.swift
//  Desserts
//
//  Created by Chris Ray on 8/26/24.
//

import Foundation

struct MockMealDetailsProvider: MealDetailsProviding {
    var bundle: Bundle = .main
    var fileName: String = "DessertDetails"

    func fetchDetails(id: String) async throws -> MealDetails {
        guard let response: MealDetailsResponse = bundle.loadFile(fileName) else {
            throw DessertsError.failedRequest
        }
        guard let details = response.meals.first else {
            throw DessertsError.missingDetails
        }
        return details
    }
}
