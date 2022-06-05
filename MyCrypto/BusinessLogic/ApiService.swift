//
//  ApiService.swift
//  MyCrypto
//
//  Created by Vitaliy Pavlyuk on 02.06.2022.
//

import Foundation
import Alamofire
import Moya



struct ApiService {
    let provider: MoyaProvider<Crypto>

    init(provider: MoyaProvider<Crypto> = MoyaProvider<Crypto>() ) {
        self.provider = provider
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

