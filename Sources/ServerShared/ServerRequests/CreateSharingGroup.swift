//
//  CreateSharingGroup.swift
//  SyncServer-Shared
//
//  Created by Christopher G Prince on 7/30/18.
//

import Foundation

// The current signed in user is requesting creation of a sharing group. A sharing group name is optional because some clients may not need or want a name per sharing group. Only owning users can create sharing groups.

public class CreateSharingGroupRequest : RequestMessage {
    required public init() {}

    // I'm having problems uploading complex objects in url parameters. So not sending a SharingGroup object yet. If I need to do this, looks like I'll have to use the request body and am not doing that yet.
    public var sharingGroupName: String?
    
    // Generated by the client.
    public var sharingGroupUUID:String!
    
    public func valid() -> Bool {
        return sharingGroupUUID != nil
    }
    
    public static func decode(_ dictionary: [String: Any]) throws -> RequestMessage {
        return try MessageDecoder.decode(CreateSharingGroupRequest.self, from: dictionary)
    }
}

public class CreateSharingGroupResponse : ResponseMessage {
    required public init() {}

    public var responseType: ResponseType {
        return .json
    }
    
    public static func decode(_ dictionary: [String: Any]) throws -> CreateSharingGroupResponse {
        return try MessageDecoder.decode(CreateSharingGroupResponse.self, from: dictionary)
    }
}
