//
//  UIView+Extentions.swift
//  VeriffAssignment
//
//  Created by psagc on 30/03/22.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        } get {
            return layer.cornerRadius
        }
    }
}


