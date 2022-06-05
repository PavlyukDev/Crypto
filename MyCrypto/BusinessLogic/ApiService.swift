//
//  ApiService.swift
//  MyCrypto
//
//  Created by Vitaliy Pavlyuk on 02.06.2022.
//

import Foundation
import Alamofire
import Moya
import RxSwift

struct ApiService {
    private let provider: MoyaProvider<Crypto>
    //plugins: [NetworkLoggerPlugin()]
    init(provider: MoyaProvider<Crypto> = MoyaProvider<Crypto>() ) {
        self.provider = provider
    }

    func getTickers(tikers: [String],
                    resultCallback: @escaping ([TickerResponse]) -> Void,
                    errorCallback: @escaping (Error) -> Void){
        provider.request(.tickers(symbols: tikers)) { result in
//            errorCallback(NSError(domain: "some", code: 0))

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


enum Crypto {
    case tickers(symbols: [String])
}

extension Crypto: TargetType {
    var baseURL: URL {
        return URL(string: "https://api-pub.bitfinex.com/v2/")!
    }

    var path: String {
        switch self {
        case .tickers:
            return "tickers"
        }
    }

    var method: Moya.Method {
        switch self {
        case .tickers:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .tickers(let symbols):
            return .requestParameters(parameters: ["symbols": symbols.joined(separator: ",")], encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
            return ["Content-type": "application/json"]
        }
}

