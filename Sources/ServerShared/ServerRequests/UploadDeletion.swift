//
//  DeleteFile.swift
//  Server
//
//  Created by Christopher Prince on 2/18/17.
//
//

import Foundation

// When uploaded, this causes the file, or group of files, to be removed from cloud storage. The files are marked as deleted in the FileIndex.
// An upload deletion request can be repeated for the same file/file group. This doesn't cause an error.

public class UploadDeletionRequest : RequestMessage {
    public required init() {
    }
    
    // MARK: Properties for use in request message.
    
    // *Must* be provided
    public var sharingGroupUUID: String!

    // Exactly one of the following two *must* be provided. If the file has a file group, only the file group *must* be provided*. In this case, you are requesting that all files in the file group are deleted. Otherwise, you are requesting that an individual file (which isn't in a file group, and hence has a nil fileGroupUUID) is deleted.
    public var fileUUID:String!
    public var fileGroupUUID: String!

    public func valid() -> Bool {
        guard sharingGroupUUID != nil else {
            return false
        }
        
        guard fileUUID != nil || fileGroupUUID != nil else {
            return false
        }
        
        if fileUUID != nil && fileGroupUUID != nil {
            return false
        }
        
        return true
    }
    
    private static func customConversions(dictionary: [String: Any]) -> [String: Any] {
        let result = dictionary
        return result
    }

    public static func decode(_ dictionary: [String: Any]) throws -> RequestMessage {
        return try MessageDecoder.decode(UploadDeletionRequest.self, from: customConversions(dictionary: dictionary))
    }
}

public class UploadDeletionResponse : ResponseMessage {
    required public init() {}

    public var responseType: ResponseType {
        return .json
    }

    // Upon an initial deletion request, this field has a value that can be used in GetUploadResults. If further requests are made for deletion of the same file, the request is successful, but this field will be nil.
    public var deferredUploadId: Int64?
    private static let deferredUploadIdKey = "deferredUploadId"

    private static func customConversions(dictionary: [String: Any]) -> [String: Any] {
        var result = dictionary
        MessageDecoder.convert(key: deferredUploadIdKey, dictionary: &result) {Int64($0)}
        return result
    }

    public static func decode(_ dictionary: [String: Any]) throws -> UploadDeletionResponse {
        return try MessageDecoder.decode(UploadDeletionResponse.self, from: customConversions(dictionary: dictionary))
    }
}
