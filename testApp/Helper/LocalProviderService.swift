//
//  LocalProviderService.swift
//  testApp
//
//  Created by mac on 22.10.2022.
//

import Foundation

class LocalProviderService {
    

    static let shared: LocalProviderService = { LocalProviderService() }()
    
// MARK: Parse data
    private var allRatesResponse: [RateResponseModel] = []
    private var allTransactionsResponse: [TransactionResponseModel] = []
    
// MARK: Ready data
    var allProducts: [ProductModel] = []
    var selectedProductTransactions: [TransactionModel] = []
    
    var totalAmountForSelectedTransactions = 0.0
    
// MARK: FOR Products SCREEN
    func getAllTransactionsList(completion: @escaping ((String?) -> Void)) {
        Parser.shared.parseTransactionData { [weak self] result in
            switch result {
            case .success(let transactions):
                self?.allTransactionsResponse = transactions
                self?.getProducts()
                completion(nil)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func getProducts() {
        allTransactionsResponse.forEach { transaction in
            if let product = allProducts.first(where: { $0.sku == transaction.sku }) {
                product.increment()
            } else {
                allProducts.append(ProductModel(sku: transaction.sku))
            }
        }
    }
    
// MARK: FOR Transactions SCREEN
    func getTransactions(for sku: String, completion: @escaping ((String?) -> Void)) {
        guard allRatesResponse.isEmpty else {
            calculateTransactions(sku: sku)
            completion(nil)
            return
        }
        
        Parser.shared.parseRateData { [weak self] result in
            switch result {
            case .success(let rates):
                self?.allRatesResponse = rates
                self?.calculateTransactions(sku: sku)
                completion(nil)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func calculateTransactions(sku: String) {
        let transactions = allTransactionsResponse.filter { $0.sku != sku }
        
        transactions.forEach { transaction in
            let amount = Double(transaction.amount) ?? 0
            var selectedProductTransaction = TransactionModel(amount: amount,
                                                              currency: transaction.currency)
            
            if transaction.currency != "GBP" {
                if let rateString = allRatesResponse.first(where: { $0.from == transaction.currency && $0.to == "GBP" })?.rate, let rate = Double(rateString) {
                    selectedProductTransaction.rate = rate
                }
            }
            selectedProductTransactions.append(selectedProductTransaction)
            self.totalAmountForSelectedTransactions += amount
        }
    }
}
