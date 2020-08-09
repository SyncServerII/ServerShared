//
//  RemoveUserFromSharingGroup.swift
//  SyncServer-Shared
//
//  Created by Christopher G Prince on 8/1/18.
//

import Foundation

public class RemoveUserFromSharingGroupRequest : RequestMessage {
    required public init() {}

    
    public var sharingGroupUUID:String!

    public func valid() -> Bool {
        return sharingGroupUUID != nil
    }
    
   private static func customConversions(dictionary: [String: Any]) -> [String: Any] {
        let result = dictionary
        return result
    }

    public static func decode(_ dictionary: [String: Any]) throws -> RequestMessage {
        return try MessageDecoder.decode(RemoveUserFromSharingGroupRequest.self, from: customConversions(dictionary: dictionary))
    }
}

public class RemoveUserFromSharingGroupResponse : ResponseMessage {
    required public init() {}

    public var responseType: ResponseType {
        return .json
    }
    
    // Unfortunate customization due to https://bugs.swift.org/browse/SR-5249
    private static func customConversions(dictionary: [String: Any]) -> [String: Any] {
        let result = dictionary
        return result
    }
    
    public static func decode(_ dictionary: [String: Any]) throws -> RemoveUserFromSharingGroupResponse {
        return try MessageDecoder.decode(RemoveUserFromSharingGroupResponse.self, from: customConversions(dictionary: dictionary))
    }
}
