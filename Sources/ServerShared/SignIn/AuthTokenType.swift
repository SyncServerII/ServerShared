public enum AuthTokenType : String {
    case GoogleToken
    case FacebookToken
    case DropboxToken
    
    public func toCloudStorageType() -> CloudStorageType? {
        switch self {
        case .DropboxToken:
            return .Dropbox
        case .GoogleToken:
            return .Google
        case .FacebookToken:
            return nil
        }
    }
}
