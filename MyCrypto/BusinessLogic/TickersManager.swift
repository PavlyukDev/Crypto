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
    init(api: ApiService = ApiService()) {
        self.api = api
    }

    func start() -> Observable<[TickerModel]> {
        return Observable<[TickerModel]>.create { observer -> Disposable in

            let interval = Observable<Int>.interval(.seconds(Consts.pollingInterval), scheduler: MainScheduler.instance)


            let subscription = interval
                .flatMap { _ in
                    return self.api.getTickers().asObservable()
                }
                .subscribe(onNext: { response in



                    let models = response.map { response in
                        TickerModel(name: response.id,
                                    price: response.price.stringValue,
                                    symbol: response.id)
                    }
                    observer.onNext(models)
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
