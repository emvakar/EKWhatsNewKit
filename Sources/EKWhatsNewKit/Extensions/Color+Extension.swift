//
//  Color+Extension.swift
//  EKWhatsNewKit
//
//  Created by Emil Karimov on 20.11.2023.
//  Copyright © 2023 Emil Karimov. All rights reserved.
//

import SwiftUI
import UIKit

extension Color {

    init(_ uiColor: UIColor) {
        self.init(red: Double(uiColor.redValue), green: Double(uiColor.greenValue), blue: Double(uiColor.blueValue), opacity: Double(uiColor.blueValue))
    }

}

extension UIColor {
    var redValue: CGFloat { cgColor.components?[0] ?? 0 }
    var greenValue: CGFloat { cgColor.components?[1] ?? 0 }
    var blueValue: CGFloat { (cgColor.components?.count ?? 0) > 2 ? cgColor.components?[2] ?? 0 : cgColor.components?[0] ?? 0 }
    var alphaValue: CGFloat { cgColor.components?.last ?? 1 }
}

