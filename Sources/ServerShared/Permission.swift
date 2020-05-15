
import Foundation

public enum Permission : String, Codable {
    case read // aka download
    case write // aka upload; includes read
    case admin // read, write, and invite

    public static func maxStringLength() -> Int {
        return max(Permission.read.rawValue.count, Permission.write.rawValue.count, Permission.admin.rawValue.count)
    }
    
    public func hasMinimumPermission(_ min:Permission) -> Bool {
        switch self {
        case .read:
            // Users with read permission can do only read operations.
            return min == .read
            
        case .write:
            // Users with write permission can do .read and .write operations.
            return min == .read || min == .write
            
        case .admin:
            // admin permissions can do anything.
            return true
        }
    }
    
    public func userFriendlyText() -> String {
        switch self {
        case .read:
            return "Read-only"
        case .write:
            return "Read & Change"
        case .admin:
            return "Read, Change, & Invite"
        }
    }
}
