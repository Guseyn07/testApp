//
//  RateResponseModel.swift
//  testApp
//
//  Created by mac on 22.10.2022.
//

import Foundation

struct RateResponseModel: Decodable, Hashable {
    let from: String
    let rate: String
    let to: String
}
