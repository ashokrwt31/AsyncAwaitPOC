//
//  ARAPI.swift
//  AsyncAwaitPOC
//
//  Created by Ashok Rawat on 03/10/22.
//

import Foundation

enum ARAPI {
    static let baseURL = Bundle.infoPlistAPIValue(forKey: "baseURL",
        valueType: String.self)
    static let apiKey = Bundle.infoPlistAPIValue(forKey: "apiKey",
        valueType: String.self)
    static let movieCredit = Bundle.infoPlistAPIValue(forKey: "movieCredit",
        valueType: String.self)
    static let movieReview = Bundle.infoPlistAPIValue(forKey: "movieReview",
        valueType: String.self)
    
    static let isAsyncType = false
    
    static let sourceService = "sources.json"
}

extension Bundle {
    static func infoPlistAPIValue<T>(forKey key: String, valueType: T.Type) ->
    T? {
        guard let path = Bundle.main.path(forResource: "ServiceAPI", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let value = dict.object(forKey: key) as? T else {
            return nil
        }
        return value
    }
}
