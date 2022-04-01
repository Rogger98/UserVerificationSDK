import Foundation

/// Helper for Localizing strings.
protocol StringLocalizable {

    /// The namespace used in the Localizable.strings files
    static var prefix: String { get }
}

extension StringLocalizable where Self: RawRepresentable, Self.RawValue == String {

    /// Formatted key used in the Localizable.strings files.
    var localized: String {
        let key = "\(Self.prefix).\(rawValue)"
        return NSLocalizedString(key, tableName: "Localizable", bundle: Bundle.shared, value:"**\(key)**", comment: "")        
    }
}

struct StringConstants {

    enum Common: String, StringLocalizable {
        case verifying
        case ok
        case cancel
        static var prefix: String { return "Common" }
    }
    
    enum DocumentTypesScreen: String, StringLocalizable {
        case title
        static var prefix: String { return "DocumentTypesScreen" }
    }
    
    enum AlertTitle: String, StringLocalizable {
        case noCamera
        static var prefix: String { return "AlertTitle" }
    }
    
    enum AlertMessages: String, StringLocalizable {
        case cameraNotAvailable
        static var prefix: String { return "AlertMessages" }
    }
    
    enum IdentityCard: String, StringLocalizable {
        case name
        case shortName
        case frontDescription
        static var prefix: String { return "IdentityCard" }
    }
    
    enum Passport: String, StringLocalizable {
        case name
        case shortName
        case frontDescription
        static var prefix: String { return "Passport" }
    }
    
    enum DrivingLicence: String, StringLocalizable {
        case name
        case shortName
        case frontDescription
        static var prefix: String { return "DrivingLicence" }
    }
    
    enum ResidentCard: String, StringLocalizable {
        case name
        case shortName
        case frontDescription
        static var prefix: String { return "ResidentCard" }
    }
    
    enum Selfie: String, StringLocalizable {
        case name
        case shortName
        case frontDescription
        static var prefix: String { return "Selfie" }
    }
    
    enum DocumentErrors: String, StringLocalizable {
        case noPhotoIdentity
        case noDocumentDetails
        case faceNotRecognize        
        static var prefix: String { return "DocumentErrors" }
    }
}

