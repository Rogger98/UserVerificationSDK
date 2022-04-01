//
//  DispatchHelper.swift
//  SwiftExample
//
//  Created by psagc on 01/04/22.
//

import Foundation

protocol DispatchHelper {
    static func dispatchHelper(block: @escaping(() -> Void))
}

extension DispatchQueue : DispatchHelper {
    static func dispatchHelper(block: @escaping (() -> Void)) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
}
