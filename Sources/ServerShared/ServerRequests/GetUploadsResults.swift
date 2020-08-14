//
//  GetUploadsResults.swift
//  
//
//  Created by Christopher G Prince on 8/9/20.
//

import Foundation
#if SERVER
import LoggerAPI
#endif

// Request the results of an upload file or upload deletion request.

public class GetUploadsResultsRequest : RequestMessage {
    required public init() {}

    // MARK: Properties for use in request message.

    public var deferredUploadId: Int64?
    private static let deferredUploadIdKey = "deferredUploadId"
    
    public func valid() -> Bool {
        guard deferredUploadId != nil else {
#if SERVER
            Log.error("Nil deferredUploadId")
#endif
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
    
    // If no DeferredUpload record is found with the given deferredUploadId, this is returned as nil.
    public var status:DeferredUploadStatus?
    public static let statusKey = "status"
    
    public static func decode(_ dictionary: [String: Any]) throws -> GetUploadsResultsResponse {
        return try MessageDecoder.decode(GetUploadsResultsResponse.self, from: dictionary)
    }
}
