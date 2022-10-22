//
//  TransactionModel.swift
//  testApp
//
//  Created by mac on 22.10.2022.
//

import Foundation

struct TransactionModel {
    let amount: Double
    let currency: String
    var rate: Double = 1.0
    
    enum CurrencyType: String {
        case USD
        case AUD
        case GBP
        case CAD
        
        var symbol: String {
            switch self {
            case .USD:
                return "$"
            case .AUD:
                return "A$"
            case .GBP:
                return "£"
            case .CAD:
                return "CA$"
            }
        }
    }
    
    var amountString: String {
        let symbol = CurrencyType(rawValue: currency)?.symbol ?? "---"
        return symbol + "\(amount)"
    }
    
    var amountGBP: String {
        
        return CurrencyType.GBP.symbol + "\(amount * rate)"
    }
}
