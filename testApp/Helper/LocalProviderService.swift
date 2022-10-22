//
//  LocalProviderService.swift
//  testApp
//
//  Created by mac on 22.10.2022.
//

import Foundation

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
        let transactions = allTransactionsResponse.filter { $0.sku == sku }
        
        transactions.forEach { transaction in
            let amount = Double(transaction.amount) ?? 0
            var selectedProductTransaction = TransactionModel(amount: amount,
                                                              amountGBP: amount,
                                                              currency: transaction.currency)
            
            if transaction.currency != CurrencyType.GBP.rawValue {
                if let rateString = allRatesResponse
                    .first(where: { $0.from == transaction.currency && $0.to == CurrencyType.GBP.rawValue })?.rate,
                   let rate = Double(rateString) {
                    selectedProductTransaction.amountGBP = amount * rate
                    
                } else if let rateString = allRatesResponse
                    .first(where: {
                        $0.from == transaction.currency && $0.to == CurrencyType.USD.rawValue
                    })?
                    .rate, let rate = Double(rateString) {
                    
                    let usdSum = amount * rate
                    if let usdRateString = allRatesResponse
                        .first(where: {
                            $0.from == CurrencyType.USD.rawValue && $0.to == CurrencyType.GBP.rawValue
                        })?
                        .rate, let usdRate = Double(usdRateString) {
                        selectedProductTransaction.amountGBP = usdSum * usdRate
                    }
                }
            }
            
            selectedProductTransactions.append(selectedProductTransaction)
            self.totalAmountForSelectedTransactions += selectedProductTransaction.amountGBP
        }
    }
}
