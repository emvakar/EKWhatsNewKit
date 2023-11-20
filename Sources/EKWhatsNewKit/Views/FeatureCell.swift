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
                .foregroundColor(.blue) // Подберите цвет под вашу палитру
                .padding()
                .frame(width: 62, height: 62)
            VStack(alignment: .leading, spacing: 2) {
                Text(feature.description)
                    .font(.subheadline)
                    .foregroundColor(.black)
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
