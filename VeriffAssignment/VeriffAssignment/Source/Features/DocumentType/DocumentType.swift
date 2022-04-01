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
    var documentIcon : UIImage? { get }
    var shortName : String { get }
    var frontDescription: String { get }
}

enum VFDocumentType : DocumentType , CaseIterable {
    case passport
    case drivingLicence
    case residentIdentity
    case idCard
    case selfie
}

extension VFDocumentType {
    var documentName: String {
        switch self {
        case .drivingLicence:
            return StringConstants.DrivingLicence.name.localized
        case .passport:
            return StringConstants.Passport.name.localized
        case .residentIdentity:
            return StringConstants.ResidentCard.name.localized
        case .idCard:
            return StringConstants.IdentityCard.name.localized
        case .selfie:
            return StringConstants.Selfie.name.localized
        }
    }
}

extension VFDocumentType {
    var documentIcon: UIImage? {
        switch self {
        case .drivingLicence:
            return UIImage(named: "icon_drivingLicense", in: Bundle.shared, with: nil)
        case .passport:
            return UIImage(named: "icon_documentTypes", in: Bundle.shared, with: nil)
        case .residentIdentity:
            return UIImage(named: "icon_documentTypes", in: Bundle.shared, with: nil)
        case .idCard:
            return UIImage(named: "icon_idcard", in: Bundle.shared, with: nil)
        case .selfie:
            return nil
        }
    }
}

extension VFDocumentType {
    var shortName: String {
        switch self {
        case .drivingLicence:
            return StringConstants.DrivingLicence.shortName.localized
        case .passport:
            return StringConstants.Passport.shortName.localized
        case .residentIdentity:
            return StringConstants.ResidentCard.shortName.localized
        case .idCard:
            return StringConstants.IdentityCard.shortName.localized
        case .selfie:
            return StringConstants.Selfie.shortName.localized
        }
    }
}

extension VFDocumentType {
    var frontDescription: String {
        switch self {
        case .drivingLicence:
            return StringConstants.DrivingLicence.frontDescription.localized
        case .passport:
            return StringConstants.Passport.frontDescription.localized
        case .residentIdentity:
            return StringConstants.ResidentCard.frontDescription.localized
        case .idCard:
            return StringConstants.IdentityCard.frontDescription.localized
        case .selfie:
            return StringConstants.Selfie.frontDescription.localized
        }
    }
}
