//
//  DownloadFile.swift
//  Server
//
//  Created by Christopher Prince on 1/29/17.
//
//

import Foundation

public class DownloadFileRequest : RequestMessage {
    required public init() {}

    // MARK: Properties for use in request message.
    
    public var fileUUID:String!
    
    // This must indicate the current version of the file in the FileIndex.
    // Keeping this after the MasterVersion and other versioning has been removed because (a) internally, we continued to have file versions, and (b) I'm considering keeping some prior (garbage) versions of files to help enable downloads of entire file groups at once without race conditions.
    public var fileVersion:FileVersionInt!
    private static let fileVersionKey = "fileVersion"
    
    public var sharingGroupUUID:String!

    public func valid() -> Bool {
        guard fileUUID != nil && fileVersion != nil && sharingGroupUUID != nil, let _ = NSUUID(uuidString: self.fileUUID) else {
            return false
        }
        
        return true
    }
    
    private static func customConversions(dictionary: [String: Any]) -> [String: Any] {
        var result = dictionary
        
        // Unfortunate customization due to https://bugs.swift.org/browse/SR-5249
        MessageDecoder.convert(key: fileVersionKey, dictionary: &result) {FileVersionInt($0)}
        
        return result
    }

    public static func decode(_ dictionary: [String: Any]) throws -> RequestMessage {
        return try MessageDecoder.decode(DownloadFileRequest.self, from: customConversions(dictionary: dictionary))
    }
}

public class DownloadFileResponse : ResponseMessage {
    required public init() {}

    public var responseType: ResponseType {
        return .data(data: data)
    }
    
    public var appMetaData:String?
    
    // This can be used by a client to know how to compute the checksum if they upload another version of this file.
    public var cloudStorageType: String!

    // The check sum for the file currently stored in cloud storage. The specific meaning of this value depends on the specific cloud storage system. See `cloudStorageType`. This can be used by clients to assess if there was an error in transmitting the file contents across the network. i.e., does this checksum match what is computed by the client after the file is downloaded?
    public var checkSum:String!
    
    // Did the contents of the file change while it was "at rest" in cloud storage? e.g., a user changed their file directly? Also, this will be true if you are downloading a stale file version. i.e., if the file version in the index is N and you are downloading version M, N > M.
    public var contentsChanged:Bool!

    // The file was gone and could not be downloaded. The string gives the GoneReason if non-nil, and the data, contentsChanged, and checkSum fields are not given.
    public var gone: String?
    
    // MARK: Property NOT used in the response message.
    public var data:Data?
    
    // Eliminate `data` from Codable coding
    // See also https://stackoverflow.com/questions/44655562/how-to-exclude-properties-from-swift-4s-codable
    private enum CodingKeys: String, CodingKey {
        case appMetaData
        case cloudStorageType
        case checkSum
        case contentsChanged
        case gone
    }
    
    private static func customConversions(dictionary: [String: Any]) -> [String: Any] {
        var result = dictionary
        
        // Unfortunate customization due to https://bugs.swift.org/browse/SR-5249
        MessageDecoder.convertBool(key: DownloadFileResponse.CodingKeys.contentsChanged.rawValue, dictionary: &result)
        
        return result
    }

    public static func decode(_ dictionary: [String: Any]) throws -> DownloadFileResponse {
        return try MessageDecoder.decode(DownloadFileResponse.self, from: customConversions(dictionary: dictionary))
    }
}
