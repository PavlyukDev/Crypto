//
//  ListViewModel.swift
//  MyCrypto
//
//  Created by Vitaliy Pavlyuk on 02.06.2022.
//

import Foundation
import RxSwift
import RxCocoa

enum TickerSection: Hashable {
    case main
}

struct TickerModel: Hashable {
    let name: String
    let price: String
    let symbol: String
}

final class ListViewModel {
    private let manager: TickersManager
    private let bag = DisposeBag()
    private let tickersSubject: BehaviorRelay<[TickerModel]> = .init(value: [])

    var tickers: Driver<[TickerModel]> {
        tickersSubject.asDriver()
    }

    init(manager: TickersManager = TickersManagerImpl()) {
        self.manager = manager
    }

    func start() {
        manager.start()
            .observe(on: MainScheduler())
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] result in
                self?.tickersSubject.accept(result)
            }, onError: { error in
                print(error)
            })
            .disposed(by: bag)
    }
}
