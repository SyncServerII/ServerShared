//
//  RequestMessage.swift
//  Server
//
//  Created by Christopher Prince on 11/26/16.
//
//

import Foundation

public protocol RequestMessage : Codable {
    init()
    
    var toDictionary: [String: Any]? {get}

    func valid() -> Bool

    static func decode(_ dictionary: [String: Any]) throws -> RequestMessage
}

public extension RequestMessage {
    var toDictionary: [String: Any]? {
        return MessageEncoder.toDictionary(encodable: self)
    }

    func urlParameters(dictionary: [String: Any]) -> String? {
        var result = ""
        // Sort the keys so I get the key=value pairs in a canonical form, for testing.
        for key in dictionary.keys.sorted() {
            if let keyValue = dictionary[key] {
                if result.count > 0 {
                    result += "&"
                }
                
                let keyValueString = String(describing: keyValue)
                let newURLParameter = "\(key)=\(keyValueString)"
                
                if let escapedNewKeyValue = newURLParameter.escape() {
                    result += escapedNewKeyValue
                }
                else {
#if DEBUG
                    assert(false)
#endif
                }
            }
        }
        
        if result.count == 0 {
            return nil
        }
        else {
            return result
        }
    }
    
    func urlParameters() -> String? {
        guard let jsonDict = toDictionary else {
            return nil
        }
        
        return urlParameters(dictionary: jsonDict)
    }
}

