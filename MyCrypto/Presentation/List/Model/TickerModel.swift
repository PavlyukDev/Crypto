//
//  TickerModel.swift
//  MyCrypto
//
//  Created by Vitaliy Pavlyuk on 06.06.2022.
//

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
