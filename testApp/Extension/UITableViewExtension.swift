//
//  UITableViewExtension.swift
//  testApp
//
//  Created by mac on 22.10.2022.
//

import UIKit

extension UITableView {
    /// Получить ячейку для tableView с конкретным классом
    func cell<T: UITableViewCell>(forClass cellClass: T.Type = T.self, reuseIdentifier: String = "") -> T {
        let className = String(describing: cellClass)
        let reuseIdentifier = className + reuseIdentifier
        var isRegistered = false
        
        while true {
            /// Если есть доступная ячейка для переиспользования - вернуть её
            if let cell = dequeueReusableCell(withIdentifier: reuseIdentifier) as? T {
                cell.selectionStyle = .none
                return cell
            }
            
            /// Зарегистрировать новую ячейку в tableView
            if isRegistered { return T() }
            let bundle = Bundle(for: cellClass)
            if bundle.path(forResource: className, ofType: "nib") != nil {
                register(UINib(nibName: className, bundle: bundle), forCellReuseIdentifier: reuseIdentifier)
            } else {
                register(cellClass, forCellReuseIdentifier: reuseIdentifier)
            }
            isRegistered = true
        }
    }
}
