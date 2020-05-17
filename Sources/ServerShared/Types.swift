public typealias UserId = Int64
public typealias FileVersionInt = Int32

public enum HTTPStatus : Int {
    case ok = 200
    case unauthorized = 401
    case forbidden = 403
    case gone = 410
    case serviceUnavailable = 503
}
