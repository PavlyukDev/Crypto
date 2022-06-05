//
//  TickersApiMock.swift
//  MyCryptoTests
//
//  Created by Vitaliy Pavlyuk on 05.06.2022.
//

@testable import MyCrypto

class TickersApiMock: TickersApi {

    var invokedGetTickers = false
    var invokedGetTickersCount = 0
    var invokedGetTickersParameters: (tikers: [String], Void)?
    var invokedGetTickersParametersList = [(tikers: [String], Void)]()
    var stubbedGetTickersResultCallbackResult: ([TickerResponse], Void)?
    var stubbedGetTickersErrorCallbackResult: (Error, Void)?

    func getTickers(tikers: [String],
        resultCallback: @escaping ([TickerResponse]) -> Void,
        errorCallback: @escaping (Error) -> Void) {
        invokedGetTickers = true
        invokedGetTickersCount += 1
        invokedGetTickersParameters = (tikers, ())
        invokedGetTickersParametersList.append((tikers, ()))
        if let result = stubbedGetTickersResultCallbackResult {
            resultCallback(result.0)
        }
        if let result = stubbedGetTickersErrorCallbackResult {
            errorCallback(result.0)
        }
    }
}
