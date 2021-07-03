//
//  MoveFileGroups.swift
//  
//
//  Created by Christopher G Prince on 7/3/21.
//

import Foundation

// Move file groups (album items) from one sharing group (album) to another.
// See https://github.com/SyncServerII/Neebla/issues/23

public class MoveFileGroupsRequest : RequestMessage {
    required public init() {}

    // MARK: Properties for use in request message.
    
    public var fileGroupUUIDs:[String]!

    // Where the file groups are currently.
    public var sourceSharingGroupUUID: String!
    
    // The place to move the file groups.
    public var destinationSharingGroupUUID: String!
    
    public func valid() -> Bool {
        guard let fileGroupUUIDs = fileGroupUUIDs, fileGroupUUIDs.count > 0 else {
            return false
        }
        
        guard sourceSharingGroupUUID != nil && destinationSharingGroupUUID != nil else {
            return false
        }
        
        return true
    }

    public static func decode(_ dictionary: [String: Any]) throws -> RequestMessage {
        return try MessageDecoder.decode(MoveFileGroupsRequest.self, from: dictionary)
    }
}

public class MoveFileGroupsResponse : ResponseMessage {
    required public init() {}

    public var responseType: ResponseType {
        return .header
    }

    public enum MoveFileGroupsResult: String, Codable {
        case success
        case failedWithNotAllOwnersInTarget
    }
    
    public var result: MoveFileGroupsResult!

    public static func decode(_ dictionary: [String: Any]) throws -> MoveFileGroupsResponse {
        return try MessageDecoder.decode(MoveFileGroupsResponse.self, from: dictionary)
    }
}
