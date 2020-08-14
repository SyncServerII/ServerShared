//
//  SendPushNotifications.swift
//  
//
//  Created by Christopher G Prince on 8/14/20.
//

import Foundation
#if SERVER
import LoggerAPI
#endif

// Send a push notification to all members of a sharing group (except for the sender).

public class SendPushNotificationsRequest : RequestMessage {
    required public init() {}

    // MARK: Properties for use in request message.
    
    public var sharingGroupUUID:String!

    public func valid() -> Bool {
        return sharingGroupUUID != nil
    }
    
    private static func customConversions(dictionary: [String: Any]) -> [String: Any] {
        let result = dictionary
        return result
    }

    public static func decode(_ dictionary: [String: Any]) throws -> RequestMessage {
        return try MessageDecoder.decode(GetUploadsResultsRequest.self, from: customConversions(dictionary: dictionary))
    }
}

public class SendPushNotificationsResponse : ResponseMessage {
    required public init() {}

    public var responseType: ResponseType {
        return .json
    }
    
    public static func decode(_ dictionary: [String: Any]) throws -> GetUploadsResultsResponse {
        return try MessageDecoder.decode(GetUploadsResultsResponse.self, from: dictionary)
    }
}
