//
//  ContinueButtonView.swift
//  EKWhatsNewKit
//
//  Created by Emil Karimov on 20.11.2023.
//  Copyright © 2023 Emil Karimov. All rights reserved.
//

import Foundation
import SwiftUI

public struct ContinueButtonView: View {

    let config: WhatsNewConfig
    var dismisAction: (() -> ())?

    public var body: some View {
        Button(action: {
            config.button.action?()
            dismisAction?()
        }) {
            Text(config.button.title)
                .font(.callout)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
        }
        .background(config.accentColor)
        .cornerRadius(10)
    }
}

#Preview {
    ContinueButtonView(config: demoConfig)
}
