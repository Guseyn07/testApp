//
//  TransactionsViewController.swift
//  testApp
//
//  Created by mac on 22.10.2022.
//

import UIKit

class TransactionsViewController: UIViewController {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    var sku: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.loadData()
    }
    
    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        if let sku {
            self.title = "Transactions for " + String(describing: sku)
        }
    }
    
    private func loadData() {
        LocalProviderService.shared.getTransactions(for: sku) { [weak self] error in
            guard let self = self else { return }
            if error != nil {
                AlertUtility.showError(message: error!, fromVC: self)
            } else {
                self.activity.stopAnimating()
                self.totalAmountLabel.text = "Total: \(LocalProviderService.shared.totalAmountForSelectedTransactions)"
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: Delegate&DataSource
extension TransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocalProviderService.shared.selectedProductTransactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GenerealTableViewCell = tableView.cell()
        let model = LocalProviderService.shared.selectedProductTransactions[indexPath.row]
        cell.setupCell(firstText: model.amountString,
                       secondText: model.amountGBP,
                       accessoryType: .disclosureIndicator)
        return cell
    }
}
