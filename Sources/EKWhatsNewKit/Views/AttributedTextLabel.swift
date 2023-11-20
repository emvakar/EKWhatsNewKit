//
//  AttributedTextLabel.swift
//  EKWhatsNewKit
//
//  Created by Emil Karimov on 20.11.2023.
//  Copyright © 2023 Emil Karimov. All rights reserved.
//

import SwiftUI
import UIKit

// Обертка для UILabel, чтобы использовать NSAttributedString в SwiftUI
struct AttributedTextLabel: UIViewRepresentable {

    let attributedString: NSAttributedString

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.attributedText = attributedString
    }

}
