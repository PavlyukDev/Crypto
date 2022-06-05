//
//  TickersManagerMock.swift
//  MyCryptoTests
//
//  Created by Vitaliy Pavlyuk on 05.06.2022.
//

import Foundation
import RxSwift
@testable import MyCrypto

class TickersManagerMock: TickersManager {

    var invokedTickersObservableGetter = false
    var invokedTickersObservableGetterCount = 0
    var stubbedTickersObservableSubject: BehaviorSubject<Result<[TickerResponse], MyCryptoError>> = .init(value: .success([]))

    var tickersObservable: Observable<Result<[TickerResponse], MyCryptoError>> {
        invokedTickersObservableGetter = true
        invokedTickersObservableGetterCount += 1
        return stubbedTickersObservableSubject.asObservable()
    }

    var invokedStartPolling = false
    var invokedStartPollingCount = 0

    func startPolling() {
        invokedStartPolling = true
        invokedStartPollingCount += 1
    }
}
