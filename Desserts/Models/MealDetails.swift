//
//  MealDetails.swift
//  Desserts
//
//  Created by Chris Ray on 8/25/24.
//

import Foundation

struct MealDetails: Decodable {
    var id: String
    var imageURL: String
    var name: String
    var instructions: String
    var ingredients: [String]

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case imageURL = "strMealThumb"
        case name = "strMeal"
        case instructions = "strInstructions"
    }

    enum IngredientKeys: String, CodingKey, CaseIterable {
        case strIngredient1
        case strIngredient2
        case strIngredient3
        case strIngredient4
        case strIngredient5
        case strIngredient6
        case strIngredient7
        case strIngredient8
        case strIngredient9
        case strIngredient10
        case strIngredient11
        case strIngredient12
        case strIngredient13
        case strIngredient14
        case strIngredient15
        case strIngredient16
        case strIngredient17
        case strIngredient18
        case strIngredient19
        case strIngredient20
    }

    enum MeasurementKeys: String, CodingKey, CaseIterable {
        case strMeasure1
        case strMeasure2
        case strMeasure3
        case strMeasure4
        case strMeasure5
        case strMeasure6
        case strMeasure7
        case strMeasure8
        case strMeasure9
        case strMeasure10
        case strMeasure11
        case strMeasure12
        case strMeasure13
        case strMeasure14
        case strMeasure15
        case strMeasure16
        case strMeasure17
        case strMeasure18
        case strMeasure19
        case strMeasure20
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        imageURL = try container.decode(String.self, forKey: .imageURL)
        name = try container.decode(String.self, forKey: .name)
        instructions = try container.decode(String.self, forKey: .instructions)
        ingredients = try Self.decodeIngredients(decoder: decoder)
    }

    private static func decodeIngredients(decoder: Decoder) throws -> [String] {
        var ingredients: [String] = []
        var encounteredIngredients: Set<String> = []

        let ingredientContainer = try decoder.container(keyedBy: IngredientKeys.self)
        let measurementContainer = try decoder.container(keyedBy: MeasurementKeys.self)

        for (ingredientKey, measurementKey) in zip(IngredientKeys.allCases, MeasurementKeys.allCases) {
            let ingredient = try ingredientContainer.decodeIfPresent(String.self, forKey: ingredientKey)
            let measurement = try measurementContainer.decodeIfPresent(String.self, forKey: measurementKey)

            if let combinedIngredients = combineIngredientComponents(
                ingredient: ingredient,
                measurement: measurement,
                encounteredIngredients: &encounteredIngredients
            ) {
                ingredients.append(combinedIngredients)
            }
        }

        return ingredients
    }

    private static func combineIngredientComponents(
        ingredient: String?,
        measurement: String?,
        encounteredIngredients: inout Set<String>
    ) -> String? {
        guard let ingredient, let measurement else { return nil }

        let trimmedMeasurement = measurement.trimmingCharacters(in: .whitespaces)

        guard !trimmedMeasurement.isEmpty, !ingredient.isEmpty else { return nil }

        let capitalizedIngredient = ingredient.capitalized

        guard !encounteredIngredients.contains(capitalizedIngredient) else { return nil }

        encounteredIngredients.insert(capitalizedIngredient)
        return "\(capitalizedIngredient): \(trimmedMeasurement.lowercased())"
    }
}

struct MealDetailsResponse: Decodable {
    var meals: [MealDetails]
}
