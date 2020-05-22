public class ServerConstants {
    // Generic HTTP request header authentication keys; the values for these keys are duplicated from Kitura (they didn't give named constants).
    public static let XTokenTypeKey = "X-token-type"
    
    public static let HTTPOAuth2AccessTokenKey = "access_token"
    
    // Necessary for some authorization systems, e.g., Dropbox.
    public static let HTTPAccountIdKey = "X-account-id"
    
    // HTTP: request header key
    // Since the Device-UUID is a somewhat secure identifier, I'm passing it in the HTTP header. Plus, it makes the device UUID available early in request processing.
    public static let httpRequestDeviceUUID = "SyncServer-Device-UUID"
    
    // Used for some Account types (e.g., Facebook)
    public static let httpResponseOAuth2AccessTokenKey = "syncserver-access-token"
    
    // The value of this key is a "X.Y.Z" version string.
    public static let httpResponseCurrentServerVersion = "syncserver-version"
    
    // Used when downloading a file to return parameters (as a HTTP header response header).
    public static let httpResponseMessageParams = "syncserver-message-params"
}

