//
//  EKWhatsNewKit.swift
//  EKWhatsNewKit
//
//  Created by Emil Karimov on 20.11.2023
//  Copyright © 2023 Emil Karimov. All rights reserved.
//

import UIKit
import SwiftUI

let cellBackground = Color(red: 0.945, green: 0.953, blue: 0.957)

let features: [WhatsNewConfig.Feature] = [
    WhatsNewConfig.Feature.init(iconName: "WN_nfc",
                                description: "Так шикарно подписываем документы, что даже электроника завидует нашему стилю!",
                                backgroundColor: cellBackground,
                                featureVersion: WhatsNewConfig.Version.init(major: 1, minor: 0, patch: 0),
                                detailsButton: WhatsNewConfig.FeatureDatailsButton(backgroundColor: Color(red: 0.4, green: 0.224, blue: 0.71),
                                                                                   action: {
                                                                                        print("Tapped!")
                                                                                   })),

    WhatsNewConfig.Feature.init(iconName: "WN_cup",
                                description: "Теперь оно стойко, как кофе, который ты забыл выпить, а потом нашёл через полдня.",
                                backgroundColor: cellBackground,
                                featureVersion: WhatsNewConfig.Version.init(major: 1, minor: 1, patch: 0)),
    WhatsNewConfig.Feature.init(iconName: "WN_phone-like",
                                description: "После тестирования делаем 'магию' кода, чтобы он чувствовал себя увереннее!",
                                backgroundColor: cellBackground,
                                featureVersion: WhatsNewConfig.Version.init(major: 1, minor: 2, patch: 1)),
    WhatsNewConfig.Feature.init(iconName: "WN_bugs",
                                description: "Иногда баги бывают настоящими ниндзя, прячущимися в тени кода.\nНо мы выявили и исправили их.",
                                backgroundColor: cellBackground,
                                featureVersion: WhatsNewConfig.Version.init(major: 2, minor: 0, patch: 0))
]


var attributedString: NSMutableAttributedString {

    let attributes1: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.black,
        .font: UIFont.boldSystemFont(ofSize: 34)
    ]
    let attributes2: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor(red: 0.4, green: 0.224, blue: 0.71, alpha: 1),
        .font: UIFont.boldSystemFont(ofSize: 34)
    ]

    let string = NSMutableAttributedString(string: "Серьезное Дело:\n", attributes: attributes1)
    string.append(NSAttributedString(string: "Наши Исправления", attributes: attributes2))
    return string
}

let demoConfig = WhatsNewConfig.init(version: WhatsNewConfig.Version(major: 1, minor: 0, patch: 0),
                                     title: attributedString,
                                     features: features,
                                     button: WhatsNewConfig.ContinueButton(title: "Начать работу",
                                                                           backgroundColor: Color(red: 0.4, green: 0.224, blue: 0.71),
                                                                           action: {
    print("Tapped!")
}), backgroundColor: .white, accentColor: .gray)

public final class WhatsNewConfig {

    let version: WhatsNewConfig.Version
    let title: NSAttributedString
    let features: [WhatsNewConfig.Feature]
    let button: ContinueButton
    let defaults: UserDefaults
    let backgroundColor: Color
    let accentColor: Color
    var storedVersion: WhatsNewConfig.Version?

    public init(version: WhatsNewConfig.Version,
                title: NSAttributedString,
                features: [WhatsNewConfig.Feature],
                button: ContinueButton,
                backgroundColor: Color,
                accentColor: Color,
                defaults: UserDefaults = UserDefaults.standard) {
        self.version = version
        self.title = title
        self.features = features
        self.button = button
        self.defaults = defaults
        self.backgroundColor = backgroundColor
        self.accentColor = backgroundColor

        guard let storedString = defaults.string(forKey: WhatsNewConfig.storageKey),
              let storedVersion = WhatsNewConfig.Version(from: storedString) else {
            self.storedVersion = nil
            return
        }
        self.storedVersion = storedVersion
    }
    
    public static let storageKey = "WhatsNew.presented.version"

    public var featuresFilteredForVersion: [WhatsNewConfig.Feature] {
        guard checkIfNeedPresent() else { return [] }
        guard let storedVersion = storedVersion else { return features }
        return features.filter {
            return $0.isActualForAllMinorVersions && version.minor == $0.featureVersion.minor && version.major == $0.featureVersion.major ||
                version == $0.featureVersion && storedVersion < $0.featureVersion
        }
    }

    public func presentIfNeeded(on viewController: UIViewController, completion: (() -> Void)? = nil) {
        guard checkIfNeedPresent() else { return }
        let vc = UIHostingController(rootView: EKWhatsNewView(config: self))
        viewController.present(vc, animated: true) {
            completion?()
        }
        defaults.set(version.string, forKey: WhatsNewConfig.storageKey)
    }

    public func presentOnTopWithoutCovering(on viewController: UIViewController, completion: (() -> Void)? = nil) {
        guard checkIfNeedPresent() else { return }
        let vc = UIHostingController(rootView: EKWhatsNewView(config: self))
        
        // Проверяем, есть ли текущий презентующий viewController
        if let presentedViewController = viewController.presentedViewController {
            // Если есть, добавляем наше новое презентационное окно к нему
            presentedViewController.present(vc, animated: true) {
                completion?()
            }
        } else {
            // Если нет, просто добавляем к текущему viewController
            viewController.present(vc, animated: true) {
                completion?()
            }
        }
        
        defaults.set(version.string, forKey: WhatsNewConfig.storageKey)
    }

    public func checkIfNeedPresent() -> Bool {
        guard let storedVersion = storedVersion else { return true }
        return storedVersion < version
    }

}

// MARK: - Public structs

public extension WhatsNewConfig {

    struct Version: Comparable {

        public let major: Int
        public let minor: Int
        public let patch: Int

        public var string: String { "\(major).\(minor).\(patch)" }
        public var current: String { Bundle.version() }

        public init(major: Int, minor: Int, patch: Int) {
            self.major = major
            self.minor = minor
            self.patch = patch
        }

        public init?(from string: String) {
            let components = string.split(separator: ".").compactMap { Int($0) }
            guard components.count == 3 else { return nil }

            self.major = components[0]
            self.minor = components[1]
            self.patch = components[2]
        }

        public static func < (lhs: Version, rhs: Version) -> Bool {
            if lhs.major != rhs.major {
                return lhs.major < rhs.major
            }
            if lhs.minor != rhs.minor {
                return lhs.minor < rhs.minor
            }
            return lhs.patch < rhs.patch
        }

        public static func == (lhs: Version, rhs: Version) -> Bool {
            return lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch == rhs.patch
        }

    }

    struct Feature: Identifiable {
        public let id: UUID = UUID()
        public let iconName: String
        public let description: String
        public let iconTintColor: Color?
        public let descriptionColor: Color
        public let backgroundColor: Color
        public let featureVersion: WhatsNewConfig.Version
        public let isActualForAllMinorVersions: Bool
        public let detailsButton: FeatureDatailsButton?
        public var hasDetailsButton: Bool {
            detailsButton != nil
        }

        public init(iconName: String,
                    description: String,
                    iconTintColor: Color? = nil,
                    descriptionColor: Color = .black,
                    backgroundColor: Color,
                    featureVersion: Version,
                    isActualForAllMinorVersions: Bool = false,
                    detailsButton: FeatureDatailsButton? = nil
        ) {
            self.iconName = iconName
            self.description = description
            self.iconTintColor = iconTintColor
            self.descriptionColor = descriptionColor
            self.backgroundColor = backgroundColor
            self.featureVersion = featureVersion
            self.isActualForAllMinorVersions = isActualForAllMinorVersions
            self.detailsButton = detailsButton
        }
    }

    struct ContinueButton {

        public let title: String
        public let buttonTextColor: Color
        public let backgroundColor: Color
        public var action: (() -> Void)?

        public init(title: String,
                    buttonTextColor: Color = Color.white,
                    backgroundColor: Color,
                    action: (() -> Void)? = nil) {
            self.title = title
            self.buttonTextColor = buttonTextColor
            self.backgroundColor = backgroundColor
            self.action = action
        }
    }
    
    struct FeatureDatailsButton {

        public let title: String
        public let buttonTextColor: Color
        public let backgroundColor: Color
        public var action: (() -> Void)?

        public init(title: String = "Подробнее",
                    buttonTextColor: Color = Color.white,
                    backgroundColor: Color,
                    action: (() -> Void)? = nil) {
            self.title = title
            self.buttonTextColor = buttonTextColor
            self.backgroundColor = backgroundColor
            self.action = action
        }
    }

    func compareVersions(_ version1: String, _ version2: String) -> ComparisonResult {
        let versionArray1 = version1.split(separator: ".").compactMap { Int($0) }
        let versionArray2 = version2.split(separator: ".").compactMap { Int($0) }

        for (v1, v2) in zip(versionArray1, versionArray2) {
            if v1 < v2 {
                return .orderedAscending
            } else if v1 > v2 {
                return .orderedDescending
            }
        }

        // Сравниваем длину массивов, если одна версия имеет больше чисел чем другая
        if versionArray1.count < versionArray2.count {
            return .orderedAscending
        } else if versionArray1.count > versionArray2.count {
            return .orderedDescending
        }

        return .orderedSame
    }
}
