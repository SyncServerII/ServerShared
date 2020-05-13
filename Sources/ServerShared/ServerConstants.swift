public class ServerConstants {
    // Generic HTTP request header authentication keys; the values for these keys are duplicated from Kitura (they didn't give named constants).
    public static let XTokenTypeKey = "X-token-type"
    
    public static let HTTPOAuth2AccessTokenKey = "access_token"
    
    // Necessary for some authorization systems, e.g., Dropbox.
    public static let HTTPAccountIdKey = "X-account-id"
}

