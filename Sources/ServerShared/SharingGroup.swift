//
//  SharingGroup.swift
//  SyncServer-Shared
//
//  Created by Christopher G Prince on 8/1/18.
//

import Foundation

public class SharingGroup : Codable {
    public init() {}
    
    public var sharingGroupUUID: String?
    
    // The sharing group name is just meta data and is not required to be distinct from other sharing group names. Not making it required either-- some app use cases might not need it.
    public var sharingGroupName: String?
    
    // Has this sharing group been deleted?
    public var deleted: Bool?
    
    // When returned from an endpoint, gives the calling users permission for the sharing group.
    public var permission:Permission?
    
    // The users who are members of the sharing group.
    public var sharingGroupUsers:[SharingGroupUser]!

    // When returned from an endpoint, for a sharing user, gives the calling users "owning" or "parent" users cloud storage type, or null if an owning user.
    public var cloudStorageType: String?
    
    // A summary of the sharing group contents, per file group contained in the sharing group. If there are no Inform records for any file groups in the sharing group, this is nil.
    public var contentsSummary:[FileGroupSummary]?
    
    // Across all file dates (both creationDate and updateDate), this gives the most recent date across all files in the sharing group. Doesn't consider deleted file groups. Only populated if also populating `contentsSummary`.
    public var mostRecentDate: Date?
}

public class FileGroupSummary: Codable {
    public init() {}
    
    public var fileGroupUUID: String!

    // Has the file group been deleted?
    public var deleted: Bool!
    
    // Indicates who should be informed of the specific change involved in this fileVersion for this file.
    public struct Inform: Codable {
        public let fileVersion: FileVersionInt
        public let fileUUID: String
        
        public enum WhoToInform: String, Codable {
            // Inform self (the user requesting this `FileGroupSummary`) about the change.
            case `self`
            
            // Don't inform self about the change
            case others
        }
        
        public let inform: WhoToInform
        
        public init(fileVersion: FileVersionInt, fileUUID: String, inform: WhoToInform) {
            self.fileVersion = fileVersion
            self.fileUUID = fileUUID
            self.inform = inform
        }
    }
    
    // Who should be overtly informed about these changes?
    public var inform: [Inform]?
    
    // MARK: The remaining fields are deprecated.
    // Of the file dates (both creationDate and updateDate), this gives the most recent date across all files in the file group. Not given if the file group has been deleted.
    public var mostRecentDate: Date?
    // Of all the files in the file group, gives the maximum file version.
    public var fileVersion: FileVersionInt!
}

public class SharingGroupUser : Codable {
    public init() {}

    public var name: String!
    
    // Present so that a client call omit themselves from a list of sharing group users presented in the UI.
    public var userId:UserId!
    
    // Has the user been removed from the sharing group?
    public var deleted: Bool!
}
