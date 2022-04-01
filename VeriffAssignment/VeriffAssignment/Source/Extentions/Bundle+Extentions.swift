//
//  Bundle+Extentions.swift
//  VeriffAssignment
//
//  Created by psagc on 30/03/22.
//

import Foundation

extension Bundle {
 
    static var shared: Bundle { Bundle(for: DocumentViewController.self)}
}

extension NSObject {
    class var className: String {
        return "\(self)"
    }
}
