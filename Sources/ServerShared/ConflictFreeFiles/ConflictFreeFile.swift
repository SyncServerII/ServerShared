
import Foundation

public protocol ConflictFreeFile {
    associatedtype RECORD
    
    init(with data: Data) throws
    
    static func convert(data: Data) throws -> RECORD
    mutating func add(newRecord: RECORD) throws
    
    func getData() throws -> Data
}
