//
//  UploadFile.swift
//  Server
//
//  Created by Christopher Prince on 1/15/17.
//
//

import Foundation

public protocol RequestingFileUpload {
    var data:Data! {get set}
    var sizeOfDataInBytes:Int! {get set}
}

public class UploadFileRequest : RequestMessage, RequestingFileUpload {    
    required public init() {}

    // MARK: Properties for use in request message.
    
    // Assigned by client.
    public var fileUUID:String!
    
    // If given, must be with version 0 of a file. Cannot be non-nil after version 0.
    public var fileGroupUUID:String?
    
    // Must be present with v0 of file. Cannot be present after. Files must maintain their mimeType throughout their life.
    public var mimeType:String?
    
    // Can only be used in the v0 upload for a file.
    public var appMetaData: AppMetaData?

    public var sharingGroupUUID: String!
    
    // The check sum for the file on the client *prior* to the upload. The specific meaning of this value depends on the specific cloud storage system. See `cloudStorageType`.
    // Required with v0 file uploads. Don't need to send this for vN, N > 0, uploads.
    public var checkSum:String?
    
    // For index of count marking. Replaces DoneUploads endpoint.
    public var uploadIndex: Int32!
    private static let uploadIndexKey = "uploadIndex"
    public var uploadCount: Int32!
    private static let uploadCountKey = "uploadCount"
    
    // Can be non-nil for v0 files only. Leave nil if files are static and changes cannot be applied.
    public var changeResolverName: String?

    // MARK: Properties NOT used in the request message.
    
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
    }
    
    public func valid() -> Bool {
        guard fileUUID != nil && sharingGroupUUID != nil, uploadIndex != nil, uploadCount != nil,
            let _ = NSUUID(uuidString: self.fileUUID),
            let _ = NSUUID(uuidString: self.sharingGroupUUID) else {
            return false
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
