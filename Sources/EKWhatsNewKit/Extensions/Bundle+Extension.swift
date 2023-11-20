//
//  Bundle+Extension.swift
//  EKWhatsNewKit
//
//  Created by Emil Karimov on 20.11.2023
//  Copyright © 2023 Emil Karimov. All rights reserved.
//

import UIKit

extension Bundle {

    static func version() -> String {
        let dictionary = Bundle.main.infoDictionary
        return (dictionary?["CFBundleShortVersionString"] as? String) ?? "1.0.0"
    }

    static func build() -> String {
        let dictionary = Bundle.main.infoDictionary
        return (dictionary?["CFBundleVersion"] as? String) ?? "1"
    }

}
