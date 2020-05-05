public enum UserType : String {
    // user doesn't own cloud storage (e.g., Facebook user)
    // aka. social user or social account
    case sharing
    
    // user owns cloud storage (e.g., Google user)
    case owning

    // Maximum length of a UserType as a string.
    public static var maxStringLength: Int {
        return 20
    }
}
