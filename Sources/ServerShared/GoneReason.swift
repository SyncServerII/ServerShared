public enum GoneReason: String {
    public static let goneReasonKey = "goneReason"
    
    case userRemoved
    case fileRemovedOrRenamed
    case authTokenExpiredOrRevoked
}
