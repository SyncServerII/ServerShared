public enum AuthTokenType : String {
    case GoogleToken
    case FacebookToken
    case DropboxToken
    case SolidToken
    
    public func toCloudStorageType() -> CloudStorageType? {
        switch self {
        case .DropboxToken:
            return .Dropbox
        case .GoogleToken:
            return .Google
        case .SolidToken:
            return .Solid
        case .FacebookToken:
            return nil
        }
    }
}
