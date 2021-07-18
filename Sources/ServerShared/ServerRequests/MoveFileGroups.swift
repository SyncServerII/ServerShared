//
//  MoveFileGroups.swift
//  
//
//  Created by Christopher G Prince on 7/3/21.
//

import Foundation

// Move file groups (album items) from one sharing group (album) to another.
// See https://github.com/SyncServerII/Neebla/issues/23

// This request is really exemplifying why I need to move away from purely URL encoded request parameters. `fileGroupUUIDs` doesn't encode using my method. I end with a dictionary:
// queryDict: ["destinationSharingGroupUUID": "DADB4C1F-3F53-4D48-BE19-3A63E921BA6A", "fileGroupUUIDs": "[\"Foobar\"]", "sourceSharingGroupUUID": "BDDF3550-8626-4743-84B8-49CAE3ECC70F"]
// I need to move generally to using the Codable and the request body.
    
public class MoveFileGroupsRequest : RequestMessage, NeedingRequestBodyData {
    enum MoveFileGroupsError: Error {
        case couldNotGetData
    }
    
    required public init() {}

    // MARK: Properties for use in request message.
    
    // The file groups being moved from source sharing group to destination.
    public var fileGroupUUIDs:[String]!
    
    // The server will ensure that all of these users are in the destination group if the user is still a member of the source sharing group.
    public var usersThatMustBeInDestination: Set<UserId>!

    // Where the file groups are currently.
    public var sourceSharingGroupUUID: String!
    
    // The place to move the file groups.
    public var destinationSharingGroupUUID: String!

    // Eliminate data and sizeOfDataIn bytes from Codable coding
    private enum CodingKeys: String, CodingKey {
        case fileGroupUUIDs
        case sourceSharingGroupUUID
        case destinationSharingGroupUUID
        case usersThatMustBeInDestination
    }
    
    // MARK: Properties NOT used by the client in the request message. The request body is copied into these by the server.
    
    public var data: Data!
    public var sizeOfDataInBytes: Int!
    
    // FAKE
    public func valid() -> Bool {
        return true
    }
    
    public func reallyValid() -> Bool {
        guard let fileGroupUUIDs = fileGroupUUIDs, fileGroupUUIDs.count > 0 else {
            return false
        }
        
        for fileGroupUUID in fileGroupUUIDs {
            guard let _ = UUID(uuidString: fileGroupUUID) else {
                return false
            }
        }
        
        guard let sourceSharingGroupUUID = sourceSharingGroupUUID,
            let destinationSharingGroupUUID = destinationSharingGroupUUID else {
            return false
        }
        
        guard let _ = UUID(uuidString: sourceSharingGroupUUID),
            let _ = UUID(uuidString: destinationSharingGroupUUID) else {
            return false
        }
        
        return true
    }
    
    public var toDictionary: [String: Any]?  {
        return nil
    }

    public static func decode(_ dictionary: [String: Any]) throws -> RequestMessage {
        // Fake
        return MoveFileGroupsRequest()
    }
    
    public static func decode(data: Data!) throws -> MoveFileGroupsRequest {
        guard let data = data else {
            throw MoveFileGroupsError.couldNotGetData
        }
        return try JSONDecoder().decode(Self.self, from: data)
    }
}

public class MoveFileGroupsResponse : ResponseMessage {
    required public init() {}

    public var responseType: ResponseType {
        return .json
    }

    public enum MoveFileGroupsResult: String, Codable {
        case success
        
        // Not all of the v0 uploaders of the file groups given in the request were members of the target sharing group.
        case failedWithNotAllOwnersInTarget
    }
    
    public var result: MoveFileGroupsResult!

    public static func decode(_ dictionary: [String: Any]) throws -> MoveFileGroupsResponse {
        return try MessageDecoder.decode(MoveFileGroupsResponse.self, from: dictionary)
    }
}
