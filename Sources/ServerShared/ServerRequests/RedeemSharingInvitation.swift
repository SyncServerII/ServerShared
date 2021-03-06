//
//  RedeemSharingInvitation.swift
//  Server
//
//  Created by Christopher Prince on 4/12/17.
//
//

import Foundation

// Create a new user as part of redeeming a sharing invitation, or redeem an invitation for an existing user.

// A 403 HTTP status code (forbidden) is given as the response if a social user (e.g., Facebook) attempts to redeem a sharing invitation for which social users are not allowed.

public class RedeemSharingInvitationRequest : RequestMessage {
    required public init() {}
    
    public var sharingInvitationUUID:String!

    // This must be present when redeeming an invitation: a) using an owning account, and b) that owning account type needs a cloud storage folder (e.g., Google Drive).
    public var cloudFolderName:String?
    
    // The new users email address. Make every effort to populate this field-- we have occaisional need to contact the users of the system; without this we cannot do that. See https://github.com/SyncServerII/ServerMain/issues/16
    public var emailAddress: String!
    
    public func valid() -> Bool {
        if let emailAddress = emailAddress {
            if emailAddress.count > AddUserRequest.emailAddessMaxLength {
                return false
            }
        }
        return sharingInvitationUUID != nil
    }
    
    public static func decode(_ dictionary: [String: Any]) throws -> RequestMessage {
        return try MessageDecoder.decode(RedeemSharingInvitationRequest.self, from: dictionary)
    }
}

public class RedeemSharingInvitationResponse : ResponseMessage {
    required public init() {}
    
    // Was a new user created as part of the process of redeeming the sharing invitation?
    public var userCreated: Bool!
    private static let userCreatedKey = "userCreated"
    
    // Present only as means to help clients uniquely identify users. This is *never* passed back to the server. This id is unique across all users and is not specific to any sign-in type (e.g., Google).
    // This is present in both the case of adding a new user and redeeming the invitation by an existing user.
    public var userId:UserId!
    private static let userIdKey = "userId"

    public var sharingGroupUUID: String!
    
    public var responseType: ResponseType {
        return .json
    }
    
    // Unfortunate customization due to https://bugs.swift.org/browse/SR-5249
    private static func customConversions(dictionary: [String: Any]) -> [String: Any] {
        var result = dictionary
        MessageDecoder.convert(key: userIdKey, dictionary: &result) {UserId($0)}
        MessageDecoder.convert(key: userCreatedKey, dictionary: &result) {Bool($0)}
        return result
    }
    
    public static func decode(_ dictionary: [String: Any]) throws -> RedeemSharingInvitationResponse {
        return try MessageDecoder.decode(RedeemSharingInvitationResponse.self, from: customConversions(dictionary: dictionary))
    }
}
