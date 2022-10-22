//
//  ProductModel.swift
//  testApp
//
//  Created by mac on 22.10.2022.
//

import Foundation

class ProductModel {
    
    let sku: String
    
    init(sku: String) {
        self.sku = sku
    }
   
    var countTitle: String {
        return "\(count) transactions"
    }
    
    private var count: Int = 1
    
    func increment(count: Int = 1) {
        self.count += 1
    }
}
