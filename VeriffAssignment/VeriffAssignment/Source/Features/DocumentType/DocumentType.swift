//
//  DocumentType.swift
//  VeriffAssignment
//
//  Created by psagc on 31/03/22.
//

import Foundation
import UIKit


protocol DocumentType {
    var documentName: String { get }
    var documentIcon : UIImage { get }
}

enum VFDocumentType : DocumentType , CaseIterable {
    case passport
    case drivingLicence
    case residentIdentity
}

extension VFDocumentType {
    var documentName: String {
        switch self {
        case .drivingLicence:
            return "Driving Licence"
        case .passport:
            return "Passport"
        case .residentIdentity:
            return "Resident Permenent Card"
        }
    }
}

extension VFDocumentType {
    var documentIcon: UIImage {
        return UIImage()
    }
}
