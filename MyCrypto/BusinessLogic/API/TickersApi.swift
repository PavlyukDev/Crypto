//
//  TickersApi.swift
//  MyCrypto
//
//  Created by Vitaliy Pavlyuk on 05.06.2022.
//

import Foundation


protocol TickersApi {
    func getTickers(tikers: [String],
                    resultCallback: @escaping ([TickerResponse]) -> Void,
                    errorCallback: @escaping (Error) -> Void)
}

extension ApiService: TickersApi {
    func getTickers(tikers: [String],
                    resultCallback: @escaping ([TickerResponse]) -> Void,
                    errorCallback: @escaping (Error) -> Void) {
        provider.request(.tickers(symbols: tikers)) { result in
            switch result {
            case .success(let response):
                do {
                    let tickers = try response.map([TickerResponse].self)
                    resultCallback(tickers)
                } catch {
                    errorCallback(error)
                }
            case .failure(let error):
                errorCallback(error)
            }
        }
    }
}
