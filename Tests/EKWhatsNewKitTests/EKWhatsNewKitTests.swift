import XCTest
import SwiftUI
@testable import EKWhatsNewKit

final class EKWhatsNewKitTests: XCTestCase {
    
    func testFetureFilteredForAllTestVersions() {
        for configTestCaseModel in configTestCaseModels {
            testFeaturesFilteredForVersion(testModel: configTestCaseModel)
        }
    }
    
    func testCheckIfNeedPresent() {
        for configTestCaseModel in configTestCaseModels {
            testCheckIfNeedPresent(testModel: configTestCaseModel)
        }
    }
    
    // MARK: - Private
    
    private func testFeaturesFilteredForVersion(testModel: СonfigTestCaseModel) {
        let config = WhatsNewConfig(version: testModel.currentTestVersion,
                                    title: NSAttributedString(string: "title"),
                                    features: testModel.features,
                                    button: button,
                                    backgroundColor: .white,
                                    accentColor: .blue)
        config.storedVersion = testModel.storedTestVersion
        let expectedFeatures = testModel.testFeaturesFilteredForVersionExpectedResult
        let actualFeatures = config.featuresFilteredForVersion.compactMap { $0.featureVersion.string }
        XCTAssertEqual(actualFeatures, expectedFeatures, "Features should be filtered based on storedVersion & version")
    }
    
    private func testCheckIfNeedPresent(testModel: СonfigTestCaseModel) {
        let config = WhatsNewConfig(version: testModel.currentTestVersion,
                                    title: NSAttributedString(string: "title"),
                                    features: testModel.features,
                                    button: button,
                                    backgroundColor: .white,
                                    accentColor: .blue)
        config.storedVersion = testModel.storedTestVersion
        let expectedNeedPresent = testModel.testCheckIfNeedPresentExpectedResult
        let actualNeedPresent = config.checkIfNeedPresent()
        XCTAssertEqual(expectedNeedPresent, actualNeedPresent, "Wrong isNeedToPresentState")
    }
    
    private struct СonfigTestCaseModel {
        var currentTestVersionString: String
        var storedTestVersionString: String
        var features: [WhatsNewConfig.Feature]
        var testFeaturesFilteredForVersionExpectedResult: [String]
        var testCheckIfNeedPresentExpectedResult: Bool
        
        var currentTestVersion: WhatsNewConfig.Version {
            WhatsNewConfig.Version(from: currentTestVersionString)!
        }
        
        var storedTestVersion: WhatsNewConfig.Version {
            WhatsNewConfig.Version(from: storedTestVersionString)!
        }
    }
    
    private var configTestCaseModels: [СonfigTestCaseModel] {
        [СonfigTestCaseModel(currentTestVersionString: "2.2.3",
                             storedTestVersionString: "2.0.0",
                             features: features,
                             testFeaturesFilteredForVersionExpectedResult: ["2.2.1", "2.2.3"],
                             testCheckIfNeedPresentExpectedResult: true),
         СonfigTestCaseModel(currentTestVersionString: "2.2.0",
                             storedTestVersionString: "2.2.0",
                             features: features,
                             testFeaturesFilteredForVersionExpectedResult: [],
                             testCheckIfNeedPresentExpectedResult: false),
         СonfigTestCaseModel(currentTestVersionString: "2.0.3",
                             storedTestVersionString: "1.0.0",
                             features: features,
                             testFeaturesFilteredForVersionExpectedResult: ["2.0.0", "2.0.2"],
                             testCheckIfNeedPresentExpectedResult: true)]
    }
    
    private var featureMainInfoTestModels: [FeatureMainInfoTest] {
        [FeatureMainInfoTest(versionString: "1.0.0", isActualForAllMinorVersions: false),
         FeatureMainInfoTest(versionString: "1.0.1", isActualForAllMinorVersions: true),
         FeatureMainInfoTest(versionString: "1.6.6", isActualForAllMinorVersions: false),
         FeatureMainInfoTest(versionString: "2.0.0", isActualForAllMinorVersions: true),
         FeatureMainInfoTest(versionString: "2.0.1", isActualForAllMinorVersions: false),
         FeatureMainInfoTest(versionString: "2.0.2", isActualForAllMinorVersions: true),
         FeatureMainInfoTest(versionString: "2.2.0", isActualForAllMinorVersions: false),
         FeatureMainInfoTest(versionString: "2.2.1", isActualForAllMinorVersions: true),
         FeatureMainInfoTest(versionString: "2.2.2", isActualForAllMinorVersions: false),
         FeatureMainInfoTest(versionString: "2.2.3", isActualForAllMinorVersions: true),
         FeatureMainInfoTest(versionString: "3.2.0", isActualForAllMinorVersions: false)]
    }

    private var features: [WhatsNewConfig.Feature] {
        featureMainInfoTestModels.map {
        WhatsNewConfig.Feature.init(iconName: "",
                                    description: "",
                                    backgroundColor: cellBackground,
                                    featureVersion: $0.version,
                                    isActualForAllMinorVersions: $0.isActualForAllMinorVersions)
        }
    }
    
    private let button = WhatsNewConfig.ContinueButton(title: "Button",
                                                       backgroundColor: Color(red: 0.4, green: 0.224, blue: 0.71),
                                                       action: { })
    
    private struct FeatureMainInfoTest {
        var versionString: String
        var isActualForAllMinorVersions: Bool
        
        var version: WhatsNewConfig.Version {
            WhatsNewConfig.Version(from: versionString)!
        }
    }
    
}
