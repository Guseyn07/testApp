//
//  TransactionResponseModel.swift
//  testApp
//
//  Created by mac on 22.10.2022.
//

import Foundation

struct TransactionResponseModel: Decodable, Hashable {
    let amount: String
    let currency: String
    let sku: String
}
