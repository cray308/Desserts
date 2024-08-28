//
//  MealDetailsView.swift
//  Desserts
//
//  Created by Chris Ray on 8/26/24.
//

import SwiftUI

struct MealDetailsView: View {
    @StateObject private var viewModel: MealDetailsViewModel
    private var title: String

    init(provider: MealDetailsProviding, summary: MealSummary) {
        _viewModel = StateObject(wrappedValue: MealDetailsViewModel(
            provider: provider,
            mealID: summary.id
        ))
        self.title = summary.name
    }

    var body: some View {
        ScrollView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if let details = viewModel.details {
                    detailView(details)
                } else {
                    Text("Failed to retrieve meal details. Please try again later.")
                }
            }
            .padding()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchMealDetails()
        }
    }

    func detailView(_ details: MealDetails) -> some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: details.imageURL)) { image in
                image.resizable()
            } placeholder: {
                // Makes an "empty view" to avoid a large placeholder if fetching the image fails
                Color.clear.frame(height: 1)
            }
            .aspectRatio(contentMode: .fill)

            sectionHeader("Ingredients")

            ForEach(details.ingredients) {
                Text("• " + $0)
            }

            sectionHeader("Instructions")

            Text(details.instructions)
        }
    }

    func sectionHeader(_ text: String) -> some View {
        VStack {
            Spacer(minLength: 16)

            Text(text)
                .font(.title2)

            Spacer(minLength: 8)
        }
    }
}

struct MealDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailsView(
            provider: MockMealDetailsProvider(),
            summary: MealSummary(name: "Apam balik", imageURL: "", id: "0")
        )
    }
}
