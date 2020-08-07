//
//  AppMetaData.swift
//  
//
//  Created by Christopher G Prince on 8/6/20.
//

import Foundation

public struct AppMetaData: Codable, Equatable {
    private static let rootKey = "appMetaData"
    
    // Must be 0 (for new appMetaData) or N+1 where N is the current version of the appMetaData on the server. Each time you change the contents field and upload it, you must increment this version.
    public let version: AppMetaDataVersionInt
    private static let versionKey = "version"

    public let contents: String
    
    public static func ==(lhs: AppMetaData, rhs: AppMetaData) -> Bool {
        return lhs.version == rhs.version && lhs.contents == rhs.contents
    }

    public init(version: AppMetaDataVersionInt, contents: String) {
        self.version = version
        self.contents = contents
    }
    
    static func fromStringToDictionaryValue(dictionary: inout [String: Any]) {
        if let str = dictionary[rootKey] as? String,
            var appMetaDataDict = str.toJSONDictionary() {
            MessageDecoder.convert(key: versionKey, dictionary: &appMetaDataDict) {AppMetaDataVersionInt($0)}
            dictionary[rootKey] = appMetaDataDict
        }
    }
}
