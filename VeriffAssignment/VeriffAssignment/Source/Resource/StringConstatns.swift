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
        return NSLocalizedString(key, tableName: "Localizable", value: "**\(key)**", comment: "")
    }
}

struct StringConstants {

    enum Common: String, StringLocalizable {
        case verifying
        static var prefix: String { return "Common" }
    }
    
    enum DocumentTypesScreen: String, StringLocalizable {
        case title
        static var prefix: String { return "DocumentTypesScreen" }
    }
}
