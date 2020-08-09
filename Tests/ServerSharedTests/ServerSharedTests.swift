import XCTest
@testable import ServerShared

final class ServerSharedTests: XCTestCase {
    func testUploadFile() {
        let appMetaData = AppMetaData(contents: "{ \"foo\": \"bar\" }")
        
        let request = UploadFileRequest()
        request.appMetaData = appMetaData
        
        guard let _ = request.urlParameters() else {
            XCTFail()
            return
        }
    }
}
