//
//  MealDetailsViewModelTests.swift
//  DessertsTests
//
//  Created by Chris Ray on 8/27/24.
//

import XCTest
@testable import Desserts

final class MealDetailsViewModelTests: XCTestCase {
    private func createViewModel(fileName: String) -> MealDetailsViewModel {
        let provider = MockMealDetailsProvider(bundle: Bundle(for: type(of: self)), fileName: fileName)
        return MealDetailsViewModel(provider: provider, mealID: "0")
    }

    func testInvalidResponseResultsInNilDetails() async {
        let viewModel = createViewModel(fileName: "InvalidResponse")
        await viewModel.fetchMealDetails()
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.details)
    }

    func testValidResponseHasProperlyMappedProperties() async {
        let viewModel = createViewModel(fileName: "MealDetailsCombined")
        await viewModel.fetchMealDetails()
        XCTAssertFalse(viewModel.isLoading)

        let details = viewModel.details
        XCTAssertNotNil(details)
        XCTAssertEqual(details?.id, "52894")
        XCTAssertEqual(details?.imageURL, "https://www.themealdb.com/images/media/meals/ywwrsp1511720277.jpg")
        XCTAssertEqual(details?.instructions, "Instructions")
        XCTAssertEqual(details?.ingredients.isEmpty, false)
    }

    func testNullIngredientsAreFilteredOut() async {
        let viewModel = createViewModel(fileName: "MealDetailsWithNullValues")
        await viewModel.fetchMealDetails()

        let details = viewModel.details!
        XCTAssertEqual(details.ingredients, ["Almonds: 50g"])
    }

    func testEmptyIngredientsAreFilteredOut() async {
        let viewModel = createViewModel(fileName: "MealDetailsWithEmptyIngredients")
        await viewModel.fetchMealDetails()

        let details = viewModel.details!
        XCTAssertEqual(details.ingredients, ["Almonds: 50g"])
    }

    func testIngredientsWithExtraSpacesAreTrimmed() async {
        let viewModel = createViewModel(fileName: "MealDetailsWithExtraSpaces")
        await viewModel.fetchMealDetails()

        let details = viewModel.details!
        let expectedIngredients: [String] = [
            "Butter: 175g",
            "Caster Sugar: 175g",
            "Self-Raising Flour: 140g",
            "Almonds: 50g"
        ]
        XCTAssertEqual(details.ingredients, expectedIngredients)
    }

    func testDuplicateIngredientsAreRemoved() async {
        let viewModel = createViewModel(fileName: "MealDetailsWithDuplicateIngredients")
        await viewModel.fetchMealDetails()

        let details = viewModel.details!
        let expectedIngredients: [String] = [
            "Butter: 175g",
            "Caster Sugar: 175g",
            "Self-Raising Flour: 140g",
            "Almonds: 50g",
            "Baking Powder: ½ tsp",
            "Eggs: 3 medium",
            "Vanilla Extract: ½ tsp",
            "Almond Extract: ¼ teaspoon",
            "Pink Food Colouring: ½ tsp",
            "Apricot: 200g",
            "Marzipan: 1kg",
            "Icing Sugar: dusting"
        ]
        XCTAssertEqual(details.ingredients, expectedIngredients)
    }

    func testIngredientsAreCapitalizedAndMeasurementsAreLowercase() async {
        let viewModel = createViewModel(fileName: "MealDetailsWithMixedCasing")
        await viewModel.fetchMealDetails()

        let details = viewModel.details!
        let expectedIngredients: [String] = [
            "Eggs: 2",
            "Salt: 1 ½ tsp",
            "Flour: 2-1/2 cups",
            "Oil: for frying",
            "Lemon: garnish",
            "Sugar: garnish",
            "Cinnamon: garnish"
        ]
        XCTAssertEqual(details.ingredients, expectedIngredients)
    }

    func testCombinedCases() async {
        let viewModel = createViewModel(fileName: "MealDetailsCombined")
        await viewModel.fetchMealDetails()

        let details = viewModel.details!
        let expectedIngredients: [String] = [
            "Butter: 175g",
            "Caster Sugar: 175g",
            "Self-Raising Flour: 140g",
            "Almonds: 50g",
            "Baking Powder: ½ tsp",
            "Eggs: dozen",
            "Vanilla Extract: tsp",
            "Almond Extract: 1 teaspoon"
        ]
        XCTAssertEqual(details.ingredients, expectedIngredients)
    }
}
