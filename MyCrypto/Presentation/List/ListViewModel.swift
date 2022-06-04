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
    let ticker: Ticker
    let price: String
    var name: String {
        switch ticker {
        case .BTC:
            return "Bitcoin"
        case .ETH:
            return "Ethereum"
        case .CHSB:
            return "SwissBorg"
        case .LTC:
            return "Litecoin"
        case .XRP:
            return "XRP"
        case .DSH:
            return "Dashcoin"
        case .RRT:
            return "Recovery Right Token"
        case .EOS:
            return "EOS"
        case .SAN:
            return "Santiment Network Token"
        case .DAT:
            return "Datum"
        case .SNT:
            return "Status"
        case .DOGE:
            return "Dogecoin"
        case .LUNA:
            return "Terra"
        case .MATIC:
            return "Polygon"
        case .NEXO:
            return "Nexo"
        case .OCEAN:
            return "Ocean Protocol"
        case .BEST:
            return "Bitpanda Ecosystem Token"
        case .AAVE:
            return "Aave"
        case .PLU:
            return "Pluton"
        case .FIL:
            return "Filecoin"
        }
    }
    var symbol: String {
        let chars = ticker.rawValue
            .replacingOccurrences(of: ":", with: "")
            .dropFirst()
            .dropLast(3)
        return String(chars)
    }
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
