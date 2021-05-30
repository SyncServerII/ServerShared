//
//  UploadFile.swift
//  Server
//
//  Created by Christopher Prince on 1/15/17.
//
//

import Foundation

// Upload files and for v0 files tacitly creates new file groups. A new file group is created when you: (a) upload a v0 file and (b) give a new fileGroupUUID. A new fileGroupUUID is one not used for any prior v0 upload.

public class UploadFileRequest : RequestMessage, NeedingRequestBodyData {    
    required public init() {}

    // MARK: Properties for use in request message.
    
    // Assigned by client.
    public var fileUUID:String!
    
    // If given, must be with version 0 of a file. Cannot be non-nil after version 0.
    public var fileGroupUUID:String?
    
    // The type of object represented by a group of files.
    // If a fileGroupUUID is given (i.e., for a v0 upload), this must also be given. Cannot be given after version 0.
    public var objectType: String?
    
    // Must be present with v0 of file. Cannot be present after. Files must maintain their mimeType throughout their life.
    public var mimeType:String?
    
    // Can only be used in the v0 upload for a file.
    public var appMetaData: AppMetaData?

    public var sharingGroupUUID: String!
    
    // The check sum for the file on the client *prior* to the upload. The specific meaning of this value depends on the specific cloud storage system. See `cloudStorageType`. And for sharing accounts, this is computed dependent on the specific cloud storage system of the inviting account (or the transitive evaluation of that-- if a sharing account invited the sharing account).
    // Required with v0 file uploads. Don't need to send this for vN, N > 0, uploads.
    public var checkSum:String?
    
    // For index of count marking. Replaces DoneUploads endpoint.
    public var uploadIndex: Int32!
    private static let uploadIndexKey = "uploadIndex"
    public var uploadCount: Int32!
    private static let uploadCountKey = "uploadCount"
    
    // Can be non-nil for v0 files only. Leave nil if files are static and changes cannot be applied.
    public var changeResolverName: String?
    
    public var fileLabel: String?
    
    // An identifier for this N of M batch of uploads.
    public var batchUUID: String!
    // When should this batch of uploads be removed because it's stale. Added to the current date on the server.
    private static let batchExpiryIntervalKey = "batchExpiryInterval"
    public var batchExpiryInterval: TimeInterval!

    // What users should be informed about this file change? If this is nil, no users should be informed. If it is non-nil, the value will always be `true`. A user id is not given (e.g., `allButUserId`) because the userId for self can always be identified by the server-- it's the user making the upload request.
    private static let informAllButSelfKey = "informAllButSelf"
    public var informAllButSelf:Bool?

    // MARK: Properties NOT used by the client in the request message. The request body is copied into these by the server.
    
    public var data:Data!
    public var sizeOfDataInBytes:Int!

    // Eliminate data and sizeOfDataIn bytes from Codable coding
    // See also https://stackoverflow.com/questions/44655562/how-to-exclude-properties-from-swift-4s-codable
    private enum CodingKeys: String, CodingKey {
        case fileUUID
        case fileGroupUUID
        case mimeType
        case appMetaData
        case sharingGroupUUID
        case checkSum
        case uploadIndex
        case uploadCount
        case changeResolverName
        case objectType
        case fileLabel
        case batchUUID
        case batchExpiryInterval
        case informAllButSelf
    }
    
    public func valid() -> Bool {
        guard fileUUID != nil && sharingGroupUUID != nil, uploadIndex != nil, uploadCount != nil, batchUUID != nil,
            let _ = NSUUID(uuidString: self.fileUUID),
            let _ = NSUUID(uuidString: self.sharingGroupUUID),
            let _ = NSUUID(uuidString: self.batchUUID) else {
            return false
        }
        
        guard batchExpiryInterval != nil else {
            return false
        }
        
        if let fileGroupUUID = fileGroupUUID {
            guard let _ = NSUUID(uuidString: fileGroupUUID) else {
                return false
            }
            
            guard let objectType = objectType else {
                return false
            }
            
            guard objectType.count > 0,
                objectType.count <= FileGroup.maxLengthObjectTypeName else {
                return false
            }
        }
        
        return true
    }

    private static func customConversions(dictionary: [String: Any]) -> [String: Any] {
        var result = dictionary
        
        MessageDecoder.unescapeValues(dictionary: &result)
        AppMetaData.fromStringToDictionaryValue(dictionary: &result)
        
        // Unfortunate customization due to https://bugs.swift.org/browse/SR-5249        
        MessageDecoder.convert(key: uploadCountKey, dictionary: &result) {Int32($0)}
        MessageDecoder.convert(key: uploadIndexKey, dictionary: &result) {Int32($0)}
        
        MessageDecoder.convert(key: batchExpiryIntervalKey, dictionary: &result) {TimeInterval($0)}
        
        MessageDecoder.convert(key: informAllButSelfKey, dictionary: &result) {Bool($0)}

        return result
    }

    public static func decode(_ dictionary: [String: Any]) throws -> RequestMessage {
        return try MessageDecoder.decode(UploadFileRequest.self, from: customConversions(dictionary: dictionary))
    }
    
    public func urlParameters() -> String? {
        guard var jsonDict = toDictionary else {
            return nil
        }

        // It's easier to decode JSON than a string encoded Dictionary.
        if let appMetaData = appMetaData {
            let encoder = JSONEncoder()
            let data: Data
            do {
                data = try encoder.encode(appMetaData)
            }
            catch {
                return nil
            }

            guard let appMetaDataJSONString = String(data: data, encoding: .utf8) else {
                return nil
            }

            jsonDict[UploadFileRequest.CodingKeys.appMetaData.rawValue] = appMetaDataJSONString            
        }

        return urlParameters(dictionary: jsonDict)
    }
}

public class UploadFileResponse : ResponseMessage {
    required public init() {}

    public var responseType: ResponseType {
        return .header
    }
    
    // On a successful upload, the following fields will be present in the response.
    
    // 12/27/17; These two were added to the response. See https://github.com/crspybits/SharedImages/issues/44
    // This is the actual date/time of creation of the file on the server.
    // Returned non-nil only with the v0 upload. With vN uploads, returned nil.
    public var creationDate: Date?
 
    // This is the actual date/time of update of the file on the server.
    public var updateDate: Date?
    
    public enum UploadsFinished: String, Codable, Equatable {
        case uploadsNotFinished
        case duplicateFileUpload
        case v0UploadsFinished
        case vNUploadsTransferPending
    }
    
    // Corresponds to the uploadCount and uploadIndex fields in the request and the implict DoneUploads.
    public var allUploadsFinished: UploadsFinished!
    private static let allUploadsFinishedKey = "allUploadsFinished"
    
    // When allUploadsFinished is vNUploadsTransferPending, this field will have a value that can be used in GetUploadResults.
    public var deferredUploadId: Int64?
    private static let deferredUploadIdKey = "deferredUploadId"

    private static func customConversions(dictionary: [String: Any]) -> [String: Any] {
        var result = dictionary

        // Unfortunate customization due to https://bugs.swift.org/browse/SR-5249
        MessageDecoder.convert(key: deferredUploadIdKey, dictionary: &result) {Int64($0)}
        return result
    }
    
    public static func decode(_ dictionary: [String: Any]) throws -> UploadFileResponse {
        return try MessageDecoder.decode(UploadFileResponse.self, from: dictionary)
    }
}
