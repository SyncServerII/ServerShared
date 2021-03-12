//
//  Filenaming.swift
//  Server
//
//  Created by Christopher Prince on 1/20/17.
//
//

import Foundation

public enum MimeType: String, Codable, CaseIterable {
    case text = "text/plain"
    case jpeg = "image/jpeg"
    case png = "image/png"
    
    // A file with a .url extension with the format https://fileinfo.com/extension/url
    // A more standard url mime type is https://tools.ietf.org/html/rfc2483#section-5 but I want to use a file format that can easily be launched in Windows and Mac OS.
    case url = "application/x-url"
    
    case mov = "video/quicktime"
    
    case gif = "image/gif"
    
    // This is really an error state. Use it with care.
    case unknown = "unknown"
    
    public var fileNameExtension: String {
        switch self {
        case .text:
            return "txt"
        case .jpeg:
            return "jpg"
        case .png:
            return "png"
        case .url:
            return "url"
        case .mov:
            return "mov"
        case .gif:
            return "gif"
            
        case .unknown:
            return Self.unknownExtension
        }
    }
    
    static let unknownExtension = "dat"
}

extension MimeType {
    public static func fileNameExtension(_ mimeType:String) -> String {
        guard let mimeTypeEnum = MimeType(rawValue: mimeType) else {
            return Self.unknownExtension
        }
        
        return mimeTypeEnum.fileNameExtension
    }
}

public enum Filename {
    /* We are not going to use just the file UUID to name the file in the cloud service. This is because we are not going to hold a lock across multiple file uploads, and we need to make sure that we don't have a conflict when two or more devices attempt to concurrently upload the same file. The file name structure we're going to use is given by this method.
    */
    public static func inCloud(
        deviceUUID:String,
        fileUUID: String,
        mimeType:String,
        fileVersion: FileVersionInt) -> String {
        
        let ext = MimeType.fileNameExtension(mimeType)
        return "\(fileUUID).\(deviceUUID).\(fileVersion).\(ext)"
    }
}
