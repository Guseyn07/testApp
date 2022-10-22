//
//  ViewController.swift
//  testApp
//
//  Created by mac on 22.10.2022.
//

import UIKit

class ProductsViewController: UIViewController {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.loadData()
    }
    
    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func loadData() {
        LocalProviderService.shared.getAllTransactionsList { [weak self] error in
            guard let self = self else { return }
            if error != nil {
                AlertUtility.showError(message: error!, fromVC: self)
            } else {
                self.activity.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
//MARK: Route
    private func pushToTransactions(sku: String) {
        guard let navVC = UIStoryboard(name: "Transactions", bundle: nil).instantiateInitialViewController() as? UINavigationController else { return }
        guard let transactionVC = navVC.topViewController as? TransactionsViewController else { return }
        transactionVC.sku = sku
        self.navigationController?.pushViewController(transactionVC, animated: true)
    }
}

//MARK: Delegate&DataSource
extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocalProviderService.shared.allProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GenerealTableViewCell = tableView.cell()
        let model = LocalProviderService.shared.allProducts[indexPath.row]
        cell.setupCell(firstText: model.sku,
                       secondText: model.countTitle,
                       accessoryType: .disclosureIndicator)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = LocalProviderService.shared.allProducts[indexPath.row]
        self.pushToTransactions(sku: model.sku)
    }
}
