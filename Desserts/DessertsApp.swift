//
//  DessertsApp.swift
//  Desserts
//
//  Created by Chris Ray on 8/25/24.
//

import SwiftUI

@main
struct DessertsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                mealListProvider: MealListProvider(),
                mealDetailsProvider: MealDetailsProvider()
            )
        }
    }
}
