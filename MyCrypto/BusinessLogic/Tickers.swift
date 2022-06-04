//
//  Tickers.swift
//  MyCrypto
//
//  Created by Vitaliy Pavlyuk on 04.06.2022.
//

import Foundation

enum Ticker: String, CaseIterable {
    var id: String {
        return self.rawValue
    }
    case BTC = "tBTCUSD"
    case ETH = "tETHUSD"
    case CHSB = "tCHSB:USD"
    case LTC = "tLTCUSD"
    case XRP = "tXRPUSD"
    case DSH = "tDSHUSD"
    case RRT = "tRRTUSD"
    case EOS = "tEOSUSD"
    case SAN = "tSANUSD"
    case DAT = "tDATUSD"
    case SNT = "tSNTUSD"
    case DOGE = "tDOGE:USD"
    case LUNA = "tLUNA:USD"
    case MATIC = "tMATIC:USD"
    case NEXO = "tNEXO:USD"
    case OCEAN = "tOCEAN:USD"
    case BEST = "tBEST:USD"
    case AAVE = "tAAVE:USD"
    case PLU = "tPLUUSD"
    case FIL = "tFILUSD"
}
