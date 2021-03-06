//
//  Types.swift
//  Server
//
//  Created by Christopher Prince on 1/25/17.
//
//

import Foundation

public typealias FileVersionInt = Int32
public typealias UserId = Int64
public typealias SharingInvitationId = Int64

public enum ServerHTTPMethod : String {
    case get
    case post
    case delete
    case patch
}

public enum HTTPStatus : Int {
    case ok = 200
    case unauthorized = 401
    case forbidden = 403
    case conflict = 409
    case gone = 410
    case serviceUnavailable = 503
}

public enum AuthenticationLevel {
    case none
    case primary // e.g., Google or Facebook credentials required
    case secondary // must also have a record of user in our database tables
}

public enum Permission : String, Codable, CaseIterable {
    case read // aka download
    case write // aka upload; includes read
    case admin // read, write, and invite

    public static func maxStringLength() -> Int {
        return max(Permission.read.rawValue.count, Permission.write.rawValue.count, Permission.admin.rawValue.count)
    }
    
    public func hasMinimumPermission(_ min:Permission) -> Bool {
        switch self {
        case .read:
            // Users with read permission can do only read operations.
            return min == .read
            
        case .write:
            // Users with write permission can do .read and .write operations.
            return min == .read || min == .write
            
        case .admin:
            // admin permissions can do anything.
            return true
        }
    }
    
    private func displaytext() -> String {
        switch self {
        case .read:
            return "Read-only"
        case .write:
            return "Read & Change"
        case .admin:
            return "Read, Change, & Invite"
        }
    }
    
    @available(*, deprecated, message: "Use `displayableText`")
    public func userFriendlyText() -> String {
        return displaytext()
    }
    
    public var displayableText: String {
        return displaytext()
    }
    
    public static func from(_ displayableText: String) -> Permission? {
        for permission in Permission.allCases {
            if permission.displayableText == displayableText {
                return permission
            }
        }
        
        return nil
    }
}

public enum UserType : String {
    case sharing // user doesn't own cloud storage (e.g., Facebook user); aka. social user or social account
    case owning // user owns cloud storage (e.g., Google user)

    public static func maxStringLength() -> Int {
        return max(UserType.sharing.rawValue.count, UserType.owning.rawValue.count)
    }
}

public enum GoneReason: String {
    public static let goneReasonKey = "goneReason"
    
    case userRemoved
    case fileRemovedOrRenamed
    case authTokenExpiredOrRevoked
}

public struct ConflictReason: Codable {
    public static let conflictReasonKey = "conflictReason"
    
    // There is a conflict with a UUID and here's the replacement if non-nil
    public let replacingUUID: String?
    // Also pass back the file version along with the UUID.
    public let serverFileVersion: FileVersionInt?
    
    public init(replacingUUID: String?, serverFileVersion: FileVersionInt?) {
        self.replacingUUID = replacingUUID
        self.serverFileVersion = serverFileVersion
    }
}

public enum DeferredUploadStatus: String, Codable {
    case pendingChange
    case pendingDeletion
    
    // Either a deletion or a file upload was successfully completed, or an upload change removed because of conflicting deletion.
    case completed
    
    case error
    
    public var isPending: Bool {
        return self == .pendingChange || self == .pendingDeletion
    }
    
    public static var maxCharacterLength: Int {
        return 20
    }
}
