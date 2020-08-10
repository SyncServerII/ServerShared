//
//  FileInfo.swift
//  Server
//
//  Created by Christopher Prince on 2/18/17.
//
//

import Foundation

public class FileInfo : Codable, CustomStringConvertible, Hashable, Equatable {
    // For testing
    public init() {
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(fileUUID)
    }

    public var fileUUID: String!
    public var deviceUUID: String?
    public var fileGroupUUID: String?
    public var sharingGroupUUID:String!

    // The creation & update dates are not used on upload-- they are established from dates on the server so they are not dependent on possibly mis-behaving clients.
    public var creationDate: Date?
 
    // Based on updating the contents only (not purely app meta data updates). I.e., calls to UploadFile.
    public var updateDate: Date?
    
    public var mimeType: String?
    
    public var deleted:Bool! = false
    
    public var fileVersion: FileVersionInt!

    public var v0UploadFileVersion: Bool!
    
    // OWNER
    public var owningUserId: UserId!
    
    public var cloudStorageType: String!
    
    // Only testing fileUUID
    public static func ==(lhs: FileInfo, rhs: FileInfo) -> Bool {
        return lhs.fileUUID == rhs.fileUUID
    }

    public static func completelyEqual(lhs: FileInfo, rhs: FileInfo) -> Bool {
        return lhs.fileUUID == rhs.fileUUID &&
            lhs.deviceUUID == rhs.deviceUUID &&
            lhs.fileGroupUUID == rhs.fileGroupUUID &&
            lhs.sharingGroupUUID == rhs.sharingGroupUUID &&
            lhs.creationDate == rhs.creationDate &&
            lhs.updateDate == rhs.updateDate &&
            lhs.mimeType == rhs.mimeType &&
            lhs.deleted == rhs.deleted &&
            lhs.fileVersion == rhs.fileVersion &&
            lhs.owningUserId == rhs.owningUserId &&
            lhs.cloudStorageType == rhs.cloudStorageType
    }
    
    public var description: String {
        return "fileUUID: \(String(describing: fileUUID)); deviceUUID: \(String(describing: deviceUUID)); creationDate: \(String(describing: creationDate)); updateDate: \(String(describing: updateDate)); mimeTypeKey: \(String(describing: mimeType)); deleted: \(String(describing: deleted)); fileVersion: \(String(describing: fileVersion))"
    }
}

