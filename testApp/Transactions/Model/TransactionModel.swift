//
//  TransactionModel.swift
//  testApp
//
//  Created by mac on 22.10.2022.
//

import Foundation

struct TransactionModel {
    let amount: Double
    var amountGBP: Double
    let currency: String
    var rate: Double = 1.0
    
    var amountString: String {
        let symbol = CurrencyType(rawValue: currency)?.symbol ?? "---"
        return symbol + String(format: "%.2f", amount)
    }
    
    var amountGBPString: String {
        let symbol = CurrencyType(rawValue: currency)?.symbol ?? "---"
        return symbol + String(format: "%.2f", amountGBP)
    }
    
}
