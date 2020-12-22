
import Foundation

public protocol NeedingRequestBodyData {
    var data:Data! {get set}
    var sizeOfDataInBytes:Int! {get set}
}
