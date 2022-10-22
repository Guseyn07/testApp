//
//  GenerealTableViewCell.swift
//  testApp
//
//  Created by mac on 22.10.2022.
//

import UIKit

class GenerealTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    func setupCell(firstText: String, secondText: String, accessoryType: UITableViewCell.AccessoryType = .none) {
        self.accessoryType = accessoryType
        self.nameLabel.text = firstText
        self.countLabel.text = secondText
    }
}
