//
//  MealSummary.swift
//  Desserts
//
//  Created by Chris Ray on 8/25/24.
//

import Foundation

struct MealSummary: Decodable, Equatable {
    var name: String
    var imageURL: String
    var id: String

    enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case imageURL = "strMealThumb"
        case id = "idMeal"
    }

    var previewURL: URL? { URL(string: imageURL + "/preview") }
}

extension MealSummary: Comparable {
    static func < (lhs: MealSummary, rhs: MealSummary) -> Bool {
        lhs.name < rhs.name
    }
}

struct MealListResponse: Decodable {
    var meals: [MealSummary]
}
