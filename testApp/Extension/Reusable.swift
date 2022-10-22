//
//  Reusable.swift
//  testApp
//
//  Created by mac on 22.10.2022.
//

protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(reflecting: self)
    }
}

typealias NibReusable = NibLoadable & Reusable
