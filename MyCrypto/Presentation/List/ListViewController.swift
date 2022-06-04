//
//  ViewController.swift
//  MyCrypto
//
//  Created by Vitaliy Pavlyuk on 01.06.2022.
//

import UIKit
import RxSwift

class ListViewController: UIViewController {
    let tableView: UITableView = .init()
    let viewModel = ListViewModel()

    private let bag = DisposeBag()

    private lazy var dataSource: UITableViewDiffableDataSource<TickerSection, TickerModel> = {
        let dataSource = UITableViewDiffableDataSource<TickerSection, TickerModel>(tableView: tableView) { tableView, indexPath, ticker in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TickerCell", for: indexPath) as? TickerCell else {
                return UITableViewCell()
            }
            cell.update(with: ticker)
            return cell
        }

        return dataSource
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }

    // MARK: - Private
    private func setupUI() {
        tableView.register(TickerCell.self, forCellReuseIdentifier: "TickerCell")
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }

    private func bind() {
        viewModel.tickers.drive { [weak self] models in
            var snapshot = NSDiffableDataSourceSnapshot<TickerSection, TickerModel>()
            snapshot.appendSections([.main])
            snapshot.appendItems(models)
            self?.dataSource.apply(snapshot, animatingDifferences: false)
        }.disposed(by: bag)
        viewModel.start()
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}


