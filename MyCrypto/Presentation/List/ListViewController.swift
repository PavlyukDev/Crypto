//
//  ViewController.swift
//  MyCrypto
//
//  Created by Vitaliy Pavlyuk on 01.06.2022.
//

import UIKit
import RxSwift

class ListViewController: UIViewController {
    private let tableView: UITableView = .init()
    private let viewModel = ListViewModel()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.showsSearchResultsController = true
        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Filter"
        return searchController
    }()

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
        navigationItem.searchController = searchController
        definesPresentationContext = true

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

        if let vc = searchController.searchResultsController as? FilterViewController {

            viewModel.tickers.asObservable()
                .bind(to: vc.sourceSubject)
                .disposed(by: bag)

        }
        viewModel.start()

        searchController
            .searchBar.rx
            .text
            .bind(to: viewModel.searchSubject)
            .disposed(by: bag)
    }
}

extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {

    }
}
