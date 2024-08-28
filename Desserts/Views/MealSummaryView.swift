//
//  MealSummaryView.swift
//  Desserts
//
//  Created by Chris Ray on 8/26/24.
//

import SwiftUI

struct MealSummaryView: View {
    var data: MealSummary

    var body: some View {
        HStack(spacing: 8) {
            AsyncImage(url: data.previewURL) { image in
                image.resizable()
            } placeholder: {
                Image(systemName: "photo").resizable()
            }
            .frame(width: 50, height: 50)

            Text(data.name)

            Spacer()
        }
    }
}

struct MealSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        MealSummaryView(data: MealSummary(name: "Cheesecake", imageURL: "", id: "0"))
    }
}
