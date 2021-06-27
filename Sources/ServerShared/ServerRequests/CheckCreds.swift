//
//  CheckCreds.swift
//  Server
//
//  Created by Christopher Prince on 11/26/16.
//
//

import Foundation

// Check to see if both primary and secondary authentication succeed. i.e., check to see if a user exists.

public class CheckCredsRequest : RequestMessage {
    required public init() {}
    
    // The purpose of the email address here is migration: To get email addresses for users into the database. Since a check creds is used by any active existing user, this should ensure we get email addresses.
    // TODO: Once we have email addresses for all existing users we could deprecate this field.
    public var emailAddress: String!

    public func valid() -> Bool {
        if let emailAddress = emailAddress {
            if emailAddress.count > AddUserRequest.emailAddessMaxLength {
                return false
            }
        }
        return true
    }
    
    public static func decode(_ dictionary: [String: Any]) throws -> RequestMessage {
        return try MessageDecoder.decode(CheckCredsRequest.self, from: dictionary)
    }
}

public class CheckCredsResponse : ResponseMessage {
    public struct UserInfo: Codable {
        // Present only as means to help clients uniquely identify users. This is *never* passed back to the server. This id is unique across all users and is not specific to any sign-in type (e.g., Google).
        public let userId:UserId
        
        // Some credentials need this client side. E.g., Apple Sign In.
        public let fullUserName: String?
        
        public init(userId:UserId, fullUserName: String?) {
            self.userId = userId
            self.fullUserName = fullUserName
        }
    }
    
    required public init() {}

    private static let userInfoKey = "userInfo"
    public var userInfo: UserInfo!

    public var responseType: ResponseType {
        return .json
    }

    public static func decode(_ dictionary: [String: Any]) throws -> CheckCredsResponse {
        return try MessageDecoder.decode(CheckCredsResponse.self, from: dictionary)
    }
}
