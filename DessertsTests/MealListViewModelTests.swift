//
//  MealListViewModelTests.swift
//  DessertsTests
//
//  Created by Chris Ray on 8/27/24.
//

import XCTest
@testable import Desserts

final class MealListViewModelTests: XCTestCase {
    private func createViewModel(fileName: String) -> MealListViewModel {
        let provider = MockMealListProvider(bundle: Bundle(for: type(of: self)), fileName: fileName)
        return MealListViewModel(provider: provider)
    }

    func testInvalidResponseResultsInNonNilError() async {
        let viewModel = createViewModel(fileName: "InvalidResponse")
        await viewModel.fetchMeals()
        XCTAssertTrue(viewModel.meals.isEmpty)
        XCTAssertNotNil(viewModel.error)
    }

    func testValidResponseHasItemsInAlphabeticalOrder() async {
        let viewModel = createViewModel(fileName: "MealList")
        await viewModel.fetchMeals()

        let expectedContents: [MealSummary] = [
            MealSummary(name: "Madeira Cake", imageURL: "", id: "52900"),
            MealSummary(name: "Mince Pies", imageURL: "", id: "52991"),
            MealSummary(name: "Nanaimo Bars", imageURL: "", id: "52924")
        ]

        XCTAssertNil(viewModel.error)
        XCTAssertEqual(expectedContents, viewModel.meals)
    }
}
