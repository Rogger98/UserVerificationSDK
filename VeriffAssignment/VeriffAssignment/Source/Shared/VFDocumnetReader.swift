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
    
    
}
