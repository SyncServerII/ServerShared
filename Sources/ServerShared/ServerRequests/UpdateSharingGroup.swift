//
//  UpdateSharingGroup.swift
//  SyncServer-Shared
//
//  Created by Christopher G Prince on 8/4/18.
//

import Foundation

// Request to rename a sharing group.

public class UpdateSharingGroupRequest : RequestMessage {
    required public init() {}
    
    // I'm having problems uploading complex objects in url parameters. So not sending a SharingGroup object yet. If I need to do this, looks like I'll have to use the request body and am not doing that yet.
    public var sharingGroupUUID:String!
    
    public var sharingGroupName: String?

    public func valid() -> Bool {
        return sharingGroupUUID != nil && sharingGroupName != nil
    }
    
   private static func customConversions(dictionary: [String: Any]) -> [String: Any] {
        let result = dictionary
        return result
    }

    public static func decode(_ dictionary: [String: Any]) throws -> RequestMessage {
        return try MessageDecoder.decode(UpdateSharingGroupRequest.self, from: customConversions(dictionary: dictionary))
    }
}

public class UpdateSharingGroupResponse : ResponseMessage {
    required public init() {}

    public var responseType: ResponseType {
        return .json
    }
    
    // Unfortunate customization due to https://bugs.swift.org/browse/SR-5249
    private static func customConversions(dictionary: [String: Any]) -> [String: Any] {
        let result = dictionary
        return result
    }
    
    public static func decode(_ dictionary: [String: Any]) throws -> UpdateSharingGroupResponse {
        return try MessageDecoder.decode(UpdateSharingGroupResponse.self, from: customConversions(dictionary: dictionary))
    }
}
