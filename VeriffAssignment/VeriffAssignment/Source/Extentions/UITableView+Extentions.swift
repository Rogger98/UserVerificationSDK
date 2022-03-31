//
//  UITableView+Extentions.swift
//  VeriffAssignment
//
//  Created by psagc on 31/03/22.
//

import UIKit

extension UITableView {
    
    func getCell<T: UITableViewCell>(_ type: T.Type) -> T? {        
        if let cell = dequeueReusableCell(withIdentifier: type.className) as? T {
            return cell
        }
        register(UINib(nibName: type.className, bundle: Bundle.shared), forCellReuseIdentifier: type.className)
        return getCell(type)
    }
}
