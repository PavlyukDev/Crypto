//
//  ViewController.swift
//  MyCrypto
//
//  Created by Vitaliy Pavlyuk on 01.06.2022.
//

import UIKit
import RxSwift

class ListViewController: UIViewController, UITableViewDataSource {
    let tableView: UITableView = .init()
    let viewModel = ListViewModel()

    private let bag = DisposeBag()

    private lazy var dataSource: UITableViewDiffableDataSource<TickerSection, TickerModel> = {
        let dataSource = UITableViewDiffableDataSource<TickerSection, TickerModel>(tableView: tableView) { tableView, indexPath, ticker in
            let cell = tableView.dequeueReusableCell(withIdentifier: "TickerCell", for: indexPath)

            var content = cell.defaultContentConfiguration()


//            content.image = UIImage(systemName: "star")
            content.text = ticker.name
            content.secondaryText = ticker.price

            // Customize appearance.
//            content.imageProperties.tintColor = .purple

            cell.contentConfiguration = content

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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TickerCell")

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.dataSource = self

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
            self?.dataSource.apply(snapshot)
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


final class TickerCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

    }
}
