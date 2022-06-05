//
//  TickerResponse.swift
//  MyCrypto
//
//  Created by Vitaliy Pavlyuk on 04.06.2022.
//

import Foundation

struct TickerResponse: Decodable, Equatable {
    let id: String
    let price: NSDecimalNumber

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var id: String?
        var price: NSDecimalNumber?
    outerloop: while !container.isAtEnd {
        switch container.currentIndex {
        case 0:
            let idValue = try container.decode(String.self)
            if idValue.hasPrefix("f") {
                throw NSError(domain: "", code: 0)
            }
            id = idValue
        case 1:
            let priceValue = try container.decode(Float.self)
            price = NSDecimalNumber(value: priceValue)
        default:
            break outerloop
        }
    }
        if let id = id, let price = price {
            self.id = id
            self.price = price
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Can't parse ticker"))
        }
    }
}
