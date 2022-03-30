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
        viewController.present(docViewController, animated: true, completion: nil)
    }
    
    /// scan new document with camera
    public func scanNewDocument(from viewController: UIViewController) {
        
    }
    
}
