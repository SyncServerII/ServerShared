//
//  GetUploadsResults.swift
//  
//
//  Created by Christopher G Prince on 8/9/20.
//

import Foundation

import Foundation

// Request the results of an upload file or upload deletion request.

public class GetUploadsResultsRequest : RequestMessage {
    required public init() {}

    // MARK: Properties for use in request message.

    public var deferredUploadId: Int64?
    private static let deferredUploadIdKey = "deferredUploadId"
    
    public func valid() -> Bool {
        guard deferredUploadId != nil else {
            return false
        }
        
        return true
    }
    
    private static func customConversions(dictionary: [String: Any]) -> [String: Any] {
        var result = dictionary
        MessageDecoder.convert(key: deferredUploadIdKey, dictionary: &result) {Int64($0)}
        return result
    }

    public static func decode(_ dictionary: [String: Any]) throws -> RequestMessage {
        return try MessageDecoder.decode(GetUploadsResultsRequest.self, from: customConversions(dictionary: dictionary))
    }
}

public class GetUploadsResultsResponse : ResponseMessage {
    required public init() {}

    public var responseType: ResponseType {
        return .json
    }
    
    public static func decode(_ dictionary: [String: Any]) throws -> GetUploadsResponse {
        return try MessageDecoder.decode(GetUploadsResponse.self, from: dictionary)
    }
}
