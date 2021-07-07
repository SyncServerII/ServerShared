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
    enum MoveFileGroupsError: Error {
        case noMainKey
        case couldNotGetData
    }
    
    required public init() {}

    // MARK: Properties for use in request message.
    
    public var fileGroupUUIDs:[String]!

    // Where the file groups are currently.
    public var sharingGroupUUID: String!
    
    // The place to move the file groups.
    public var destinationSharingGroupUUID: String!
    
    // This request is really exemplifying why I need to move away from purely URL encoded request parameters. `fileGroupUUIDs` doesn't encode using my method. I end with a dictionary:
    // queryDict: ["destinationSharingGroupUUID": "DADB4C1F-3F53-4D48-BE19-3A63E921BA6A", "fileGroupUUIDs": "[\"Foobar\"]", "sourceSharingGroupUUID": "BDDF3550-8626-4743-84B8-49CAE3ECC70F"]
    // I need to move generally to using the Codable and the request body.
    static let mainKey = "main"
    
    public func valid() -> Bool {
        guard let fileGroupUUIDs = fileGroupUUIDs, fileGroupUUIDs.count > 0 else {
            return false
        }
        
        for fileGroupUUID in fileGroupUUIDs {
            guard let _ = UUID(uuidString: fileGroupUUID) else {
                return false
            }
        }
        
        guard let sourceSharingGroupUUID = sharingGroupUUID,
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
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        
        let base64string = data.base64EncodedString()
        return [Self.mainKey: base64string]
    }

    public static func decode(_ dictionary: [String: Any]) throws -> RequestMessage {
        guard let base64string = dictionary[Self.mainKey] as? String else {
            throw MoveFileGroupsError.noMainKey
        }
        
        guard let data = Data(base64Encoded: base64string) else {
            throw MoveFileGroupsError.couldNotGetData
        }
        
        return try JSONDecoder().decode(Self.self, from: data)
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
