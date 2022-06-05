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
    var tickersObservable: Observable<Result<[TickerResponse], MyCryptoError>> { get }

    func startPolling()
}

enum MyCryptoError: Error, Equatable {
    case noInternet
    case unknown
}

final class TickersManagerImpl: TickersManager {
    private enum Consts {
        static let pollingInterval: Int = 5
    }
    private let api: ApiService
    private let tickersSubject: BehaviorSubject<Result<[TickerResponse], MyCryptoError>> = .init(value: .success([]))
    private let bag = DisposeBag()

    var tickersObservable: Observable<Result<[TickerResponse], MyCryptoError>> {
        tickersSubject.asObserver()
    }

    var selectedTickers: [Ticker] = Ticker.allCases


    init(api: ApiService = ApiService()) {
        self.api = api
    }

    func startPolling()  {
        let interval = Observable<Int>.interval(.seconds(Consts.pollingInterval), scheduler: MainScheduler.instance)
        interval.subscribe(onNext: { response in
//            self.tickersSubject.on(.next(.failure(.unknown)))
            self.api.getTickers(tikers: self.selectedTickers.map{ $0.id }) { response in
                self.tickersSubject.on(.next(.success(response)))
            } errorCallback: { error in
                self.tickersSubject.on(.next(.failure(.unknown)))
            }
        })
        .disposed(by: bag)
    }
}
