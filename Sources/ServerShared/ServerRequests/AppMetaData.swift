//
//  AppMetaData.swift
//  
//
//  Created by Christopher G Prince on 8/6/20.
//

import Foundation

public struct AppMetaData: Codable, Equatable {
    private static let rootKey = "appMetaData"

    public let contents: String
    
    public static func ==(lhs: AppMetaData, rhs: AppMetaData) -> Bool {
        return lhs.contents == rhs.contents
    }

    public init(contents: String) {
        self.contents = contents
    }
    
    static func fromStringToDictionaryValue(dictionary: inout [String: Any]) {
        if let str = dictionary[rootKey] as? String,
            let appMetaDataDict = str.toJSONDictionary() {
            dictionary[rootKey] = appMetaDataDict
        }
    }
}
