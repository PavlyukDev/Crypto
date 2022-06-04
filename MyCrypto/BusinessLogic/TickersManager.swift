//
//  TickersManager.swift
//  MyCrypto
//
//  Created by Vitaliy Pavlyuk on 02.06.2022.
//

import Foundation
import RxSwift
import Moya

protocol TickersManager {
    func start() -> Observable<[TickerModel]>
}

final class TickersManagerImpl: TickersManager {
    private enum Consts {
        static let pollingInterval: Int = 5
    }
    private let api: ApiService
    var tickers: [Ticker] = Ticker.allCases

    init(api: ApiService = ApiService()) {
        self.api = api
    }

    func start() -> Observable<[TickerModel]> {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 4
        formatter.minimumFractionDigits = 0
        formatter.numberStyle = .currency
//        formatter.positiveFormat = "###,###,###,###.#### ¤"
        formatter.currencySymbol = "$ "

        return Observable<[TickerModel]>.create { observer -> Disposable in

            let interval = Observable<Int>.interval(.seconds(Consts.pollingInterval), scheduler: MainScheduler.instance)


            let subscription = interval
                .flatMap { _ in
                    return self.api.getTickers(tikers: self.tickers.map{ $0.id }).asObservable()
                }
                .subscribe(onNext: { response in
                    do {
                        let models = try response
                            .map { response -> TickerModel in
                                guard let ticker = Ticker(rawValue: response.id) else {
                                    throw NSError(domain: "TickersManager.polling", code: 0)
                                }
                                return TickerModel(ticker: ticker,
                                                   price: formatter.string(for: response.price) ?? "")
                            }
                        observer.onNext(models)
                    } catch {
                        observer.onError(error)
                    }

//                    observer.onCompleted()
                },onError: { error in
                    print(error)

                })

            return Disposables.create{
                subscription.dispose()
            }
        }
    }
}
