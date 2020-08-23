//
//  String+Extras.swift
//  Server
//
//  Created by Christopher Prince on 2/12/17.
//
//

import Foundation

extension String {
    public func toJSONDictionary() -> [String:Any]? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        var json:Any?
        
        do {
            try json = JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: UInt(0)))
        } catch {
            return nil
        }
        
        guard let jsonDict = json as? [String:Any] else {
            return nil
        }
        
        return jsonDict
    }

    public func escape() -> String? {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
    
    public func unescape() -> String? {
        return removingPercentEncoding
    }    
}
