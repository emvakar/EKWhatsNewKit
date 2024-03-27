//
//  FeatureCell.swift
//  EKWhatsNewKit
//
//  Created by Emil Karimov on 20.11.2023.
//  Copyright © 2023 Emil Karimov. All rights reserved.
//

import SwiftUI

struct FeatureCell: View {

    let feature: WhatsNewConfig.Feature

    var body: some View {
        HStack {
            Image(feature.iconName, bundle: .main)
                .renderingMode(.template)
                .foregroundColor(feature.iconTintColor)
                .padding()
                .frame(width: 62, height: 62)
            VStack(alignment: .leading, spacing: 2) {
                Text(feature.description)
                    .font(.subheadline)
                    .foregroundColor(feature.descriptionColor)
                if feature.hasDetailsButton {
                    HStack {
                        Spacer()
                        Button(action: feature.detailsButton?.action ?? {}) {
                            Text(feature.detailsButton?.title ?? "Подробнее")
                                .padding(.vertical, 6)
                                .frame(width: 140, height: 28)
                                .foregroundColor(.white)
                                .background(feature.detailsButton?.backgroundColor)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .padding(.vertical)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .background(feature.backgroundColor)
        .cornerRadius(16)

    }

}

#Preview {
    FeatureCell(feature: features.first!)
}
