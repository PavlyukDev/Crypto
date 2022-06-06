//
//  ViewController.swift
//  MyCrypto
//
//  Created by Vitaliy Pavlyuk on 01.06.2022.
//

import UIKit
import RxSwift

enum TickerSection: Hashable {
    case main
}

final class ListViewController: UIViewController {
    private let tableView: UITableView = .init()
    private let viewModel: ListViewModel
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.showsSearchResultsController = true
        searchController.obscuresBackgroundDuringPresentation = false
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

    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }

    // MARK: - Private
    private func setupUI() {
        view.backgroundColor = .white
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

        searchController
            .searchBar.rx
            .text
            .bind(to: viewModel.searchSubject)
            .disposed(by: bag)

        viewModel.errorSignal
            .drive(onNext: { [weak self] error in
                guard let error = error else { return }
                self?.showToast(message: error.localizedDescription)
            })
            .disposed(by: bag)

        searchController
            .searchBar.rx
            .cancelButtonClicked
            .bind(onNext: { [weak self] _ in
                self?.viewModel.disableSearch()
            })
            .disposed(by: bag)

        viewModel.start()
    }
}
