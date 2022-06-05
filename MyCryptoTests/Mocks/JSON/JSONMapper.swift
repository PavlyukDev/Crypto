//
//  JSONMapper.swift
//  MyCryptoTests
//
//  Created by Vitaliy Pavlyuk on 05.06.2022.
//

import Foundation

class JSONMapper {
    static func getObject<T: Decodable>(fromJson file: String) -> T {
        let url = Bundle(for: JSONMapper.self)
            .url(forResource: file, withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder().decode(T.self, from: data)
    }
}
