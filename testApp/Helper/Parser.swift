//
//  Parser.swift
//  testApp
//
//  Created by mac on 22.10.2022.
//

import Foundation

class Parser {
    
    static let shared: Parser = { Parser() }()
    
    enum ParserError: Error {
        case decodeError
    }
    
    func parseRateData(completion: @escaping (Result<Set<RateResponseModel>, Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: "rates", withExtension: "plist") else { return }
        do {
            let data = try Data(contentsOf: url)
            guard let result = self.decodePropertyList(type: [RateResponseModel].self, from: data) else {
                completion(.failure(ParserError.decodeError))
                return
            }
            completion(.success(Set(result)))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func parseTransactionData(completion: @escaping (Result<Set<TransactionResponseModel>, Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: "transactions", withExtension: "plist") else { return }
        do {
            let data = try Data(contentsOf: url)
            guard let result = self.decodePropertyList(type: [TransactionResponseModel].self, from: data) else {
                completion(.failure(ParserError.decodeError))
                return
            }
            completion(.success(Set(result)))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    private func decodePropertyList<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = PropertyListDecoder()
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
}
