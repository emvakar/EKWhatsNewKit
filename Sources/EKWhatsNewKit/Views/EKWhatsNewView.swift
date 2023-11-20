//
//  EKWhatsNewView.swift
//  EKWhatsNewKit
//
//  Created by Emil Karimov on 20.11.2023.
//  Copyright © 2023 Emil Karimov. All rights reserved.
//

import SwiftUI

public struct EKWhatsNewView: View {

    @Environment(\.presentationMode) var presentationMode

    let featureFont = Font.system(size: 17, weight: .regular)
    let config: WhatsNewConfig

    public init(config: WhatsNewConfig) {
        self.config = config
    }

    public var body: some View {
        VStack {
            AttributedTextLabel(attributedString: attributedString)
                .padding()
                .multilineTextAlignment(.center)
                .scaledToFit()

            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(config.features) { feature in
                        FeatureCell(feature: feature)
                            .padding(.horizontal)
                    }
                }
                .padding(.top)
            }

            Spacer()
            ContinueButtonView(config: config, dismisAction: {
                presentationMode.wrappedValue.dismiss()
            })
                .padding()
            Spacer()
        }
        .background(config.backgroundColor)
    }
}

#Preview {
    EKWhatsNewView(config: demoConfig)
}
