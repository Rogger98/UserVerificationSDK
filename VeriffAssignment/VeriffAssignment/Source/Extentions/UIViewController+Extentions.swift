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
}


