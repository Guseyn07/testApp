//
//  AlertUtility.swift
//  testApp
//
//  Created by mac on 22.10.2022.
//

import UIKit

public class AlertUtility: NSObject {
    static func showError(message: String, fromVC: UIViewController) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        fromVC.present(alert, animated: true)
    }
}
