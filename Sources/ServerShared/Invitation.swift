
import Foundation

public struct Invitation {
    public let code:String
    public let permission:Permission
    public let allowsSocialSharing: Bool
    
    public init(code: String, permission: Permission, allowsSocialSharing: Bool) {
        self.code = code
        self.permission = permission
        self.allowsSocialSharing = allowsSocialSharing
    }
}
