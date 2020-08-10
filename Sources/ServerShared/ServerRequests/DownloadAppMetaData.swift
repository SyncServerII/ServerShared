//
//  DownloadAppMetaData.swift
//  SyncServer-Shared
//
//  Created by Christopher G Prince on 3/23/18.
//

import Foundation

public class DownloadAppMetaDataRequest : RequestMessage {
    required public init() {}

    // MARK: Properties for use in request message.
    
    public var fileUUID:String!
    
    public var sharingGroupUUID: String!
    
    public func valid() -> Bool {
        return fileUUID != nil && sharingGroupUUID != nil
    }
    
    private static func customConversions(dictionary: [String: Any]) -> [String: Any] {
        let result = dictionary
        return result
    }

    public static func decode(_ dictionary: [String: Any]) throws -> RequestMessage {
        return try MessageDecoder.decode(DownloadAppMetaDataRequest.self, from: customConversions(dictionary: dictionary))
    }
}

public class DownloadAppMetaDataResponse : ResponseMessage {
    required public init() {}

    public var responseType: ResponseType {
        return .json
    }
    
    // Just the appMetaData contents.
    public var appMetaData:String?
    
    private static func customConversions(dictionary: [String: Any]) -> [String: Any] {
        let result = dictionary
        return result
    }

    public static func decode(_ dictionary: [String: Any]) throws -> DownloadAppMetaDataResponse {
        return try MessageDecoder.decode(DownloadAppMetaDataResponse.self, from: customConversions(dictionary: dictionary))
    }
}
