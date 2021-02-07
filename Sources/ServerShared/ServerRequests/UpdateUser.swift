//
//  UpdateUser.swift
//  Server
//
//  Created by Christopher Prince on 11/26/16.
//
//

import Foundation

// Update user properties. E.g., user name.

public class UpdateUserRequest : RequestMessage {
    required public init() {}

    public var userName:String!

    public func valid() -> Bool {
        return userName != nil
    }
    
    public static func decode(_ dictionary: [String: Any]) throws -> RequestMessage {
        return try MessageDecoder.decode(UpdateUserRequest.self, from: dictionary)
    }
}

public class UpdateUserResponse : ResponseMessage {
    required public init() {}

    public var responseType: ResponseType {
        return .json
    }

    public static func decode(_ dictionary: [String: Any]) throws -> UpdateUserResponse {
        return try MessageDecoder.decode(UpdateUserResponse.self, from: dictionary)
    }
}
