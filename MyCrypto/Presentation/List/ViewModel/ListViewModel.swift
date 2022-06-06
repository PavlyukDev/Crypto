//
//  ListViewModel.swift
//  MyCrypto
//
//  Created by Vitaliy Pavlyuk on 02.06.2022.
//

import Foundation
import RxSwift
import RxCocoa

protocol ListViewModel {
    var tickers: Driver<[TickerModel]> { get }
    var searchSubject: BehaviorRelay<String?> { get }
    var errorSignal: Driver<Error?> { get }

    func start()
    func disableSearch()
}

final class ListViewModelImpl: ListViewModel {
    private let manager: TickersManager
    private let bag = DisposeBag()
    private let tickersSubject: BehaviorRelay<[TickerModel]> = .init(value: [])
    private lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 4
        formatter.minimumFractionDigits = 0
        formatter.numberStyle = .currency
        formatter.decimalSeparator = "."
        formatter.currencySymbol = "$"
        return formatter
    }()

    private var selectedTickers: Set<TickerModel> = []
    private var isSearchEnabled: Bool = false
    private let errorSubject: BehaviorRelay<Error?> = .init(value: nil)

    let searchSubject: BehaviorRelay<String?> = .init(value: nil)

    var tickers: Driver<[TickerModel]> {
        tickersSubject
            .asDriver()
            .map({ [weak self] models in
                return self?.filter(with: models) ?? models
            })
            .distinctUntilChanged()
    }

    var errorSignal: Driver<Error?> {
        errorSubject.asDriver()
    }

    init(manager: TickersManager = TickersManagerImpl()) {
        self.manager = manager
    }

    func start() {
        manager.startPolling()
        manager.tickersObservable
            .observe(on: MainScheduler())
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let models):
                    self?.processResponse(models)
                case .failure(let error):
                    self?.processError(error)
                }
            })
            .disposed(by: bag)

        searchSubject
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                defer {
                    self?.updateModels()
                }
                guard let text = text, !text.isEmpty else {
                    self?.isSearchEnabled = false
                    return
                }
                self?.isSearchEnabled = true
                self?.chooseSelected(with: text)
            })
            .disposed(by: bag)
    }

    func disableSearch() {
        selectedTickers.removeAll()
        isSearchEnabled = false
    }

    // MARK: - Private

    private func processResponse(_ response: [TickerResponse]) {
        do {
            let models = try response
                .map { response -> TickerModel in
                    guard let ticker = Ticker(rawValue: response.id) else {
                        throw MyCryptoError.unknown
                    }
                    return TickerModel(ticker: ticker,
                                       price: formatter.string(for: response.price) ?? "")
                }
            tickersSubject.accept(models)
        } catch {
            processError(MyCryptoError.unknown)
        }
    }

    private func processError(_ error: Error) {
        errorSubject.accept(error)
    }

    private func updateModels() {
        let models = tickersSubject.value
        tickersSubject.accept(models)
    }

    private func chooseSelected(with text: String) {
        let models = tickersSubject.value
            .filter { model in
                return model.name.lowercased()
                    .contains(text.lowercased())
                || model.symbol.lowercased()
                    .contains(text.lowercased())
            }
        selectedTickers = Set(models)
    }

    private func filter(with models: [TickerModel]) -> [TickerModel] {
        guard isSearchEnabled else {
            return models
        }
        let filtered = models.filter { [weak self] model in
            return self?.selectedTickers.contains(model) ?? false
        }
        return filtered
    }
}

