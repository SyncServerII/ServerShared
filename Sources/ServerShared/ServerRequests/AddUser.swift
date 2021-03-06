//
//  AddUser.swift
//  Server
//
//  Created by Christopher Prince on 11/26/16.
//
//

import Foundation

public class AddUserRequest : RequestMessage {
    required public init() {}

    // A root-level folder in the cloud file service. This is only used by some of the cloud file services. E.g., Google Drive. It's not used by Dropbox.
    public var cloudFolderName:String?
    public static let maxCloudFolderNameLength = 256
    
    // The new users email address. Make every effort to populate this field-- we have occaisional need to contact the users of the system; without this we cannot do that. See https://github.com/SyncServerII/ServerMain/issues/16
    public var emailAddress: String?
    public static let emailAddessMaxLength = 512

    // You can optionally give the initial sharing group, created for the user, a name.
    public var sharingGroupName: String?
    
    public var sharingGroupUUID:String!
    
    public func valid() -> Bool {
        if let emailAddress = emailAddress {
            if emailAddress.count > Self.emailAddessMaxLength {
                return false
            }
        }
        return sharingGroupUUID != nil
    }
    
    public static func decode(_ dictionary: [String: Any]) throws -> RequestMessage {
        return try MessageDecoder.decode(AddUserRequest.self, from: dictionary)
    }
}

public class AddUserResponse : ResponseMessage {
    required public init() {}

    // Present only as means to help clients uniquely identify users. This is *never* passed back to the server. This id is unique across all users and is not specific to any sign-in type (e.g., Google).
    public var userId:UserId?
    private static let userIdKey = "userId"
    
    // If the already exists prior the addUser request, then this is returned with the value true and `userId` is nil.
    public var userAlreadyExisted:Bool?
    private static let userAlreadyExistedKey = "userAlreadyExisted"

    public var responseType: ResponseType {
        return .json
    }
    
    private static func customConversions(dictionary: [String: Any]) -> [String: Any] {
        var result = dictionary
        
        // Unfortunate customization due to https://bugs.swift.org/browse/SR-5249
        MessageDecoder.convert(key: userIdKey, dictionary: &result) {UserId($0)}
        MessageDecoder.convert(key: userAlreadyExistedKey, dictionary: &result) {Bool($0)}

        return result
    }

    public static func decode(_ dictionary: [String: Any]) throws -> AddUserResponse {
        return try MessageDecoder.decode(AddUserResponse.self, from: customConversions(dictionary: dictionary))
    }
}
