//
//  VFDocumnetReader.swift
//  VeriffAssignment
//
//  Created by psagc on 30/03/22.
//

import Foundation
import UIKit

/// `VFDocumentReader` takes the responsblity for all the document opertation
public class VFDocumentReader {
    
    // MARK: - Variables
    public static var shared: VFDocumentReader = VFDocumentReader()
    
    // MARK: - Helper Methods
    
    /// scan document details from provided image
    public func readDocument(image: UIImage,from viewController: UIViewController) {
        
        let viewModel: DocumentReaderViewModel = DocumentReaderViewModel()
        let docViewController: DocumentViewController = DocumentViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen
        viewController.present(docViewController, animated: true, completion: nil)
    }
    
    
    
    /// scan new document with camera
    public func scanNewDocument(from viewController: UIViewController,
                                didVerifiedWithText: @escaping ((_ document: DocumentDetails) -> Void),
                                errorVerifingDocument: @escaping ((_ document: DocumentDetails?, _ error: DocumentVerifyError) -> Void)) {
    
        let documentsTypeViewModle: DocumentTypesViewModel = DocumentTypesViewModel()
        let documentsViewController: DocumentTypesViewController = DocumentTypesViewController(viewModel: documentsTypeViewModle)
        let navigationViewController: VFNavigationController = VFNavigationController(rootViewController: documentsViewController)
        navigationViewController.modalPresentationStyle = .fullScreen
        viewController.present(navigationViewController, animated: true, completion: nil)
    }
    
    private func scanDocumentFromCamera(from viewController: UIViewController,
                                        didVerifiedWithText: @escaping ((_ document: DocumentDetails) -> Void),
                                        errorVerifingDocument: @escaping ((_ document: DocumentDetails?, _ error: DocumentVerifyError) -> Void)) {
        let scanViewController = ScanViewController(settings: 1)
        scanViewController.didVerifiedWithText = didVerifiedWithText
        scanViewController.errorVerifingDocument = errorVerifingDocument
        let navigationViewController: VFNavigationController = VFNavigationController(rootViewController: scanViewController)
        navigationViewController.modalPresentationStyle = .fullScreen
        navigationViewController.navigationBar.isHidden = true
        viewController.present(navigationViewController, animated: true, completion: nil)
    }
    
}
