//
//  UIViewController+Extentions.swift
//  VeriffAssignment
//
//  Created by psagc on 31/03/22.
//

import UIKit

extension UIViewController {
    
    func showLoader(title: String) {
        SwiftLoader.show(title: title, animated: true)
    }
    
    func hideLoader() {
        SwiftLoader.hide()
    }
    
    func showAlert(title: String,message: String,actions: UIAlertAction...) {
        
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if actions.isEmpty {
            alertController.addAction(UIAlertAction(title: StringConstants.Common.ok.localized, style: .default, handler: nil))
        } else {
            actions.forEach(alertController.addAction(_:))
        }
        present(alertController, animated: true, completion: nil)
    }
}


