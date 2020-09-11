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
    
    func testGetUploadsResults() {
        let request = GetUploadsResultsRequest()
        request.deferredUploadId = 1
        XCTAssert(request.valid())
        
        guard let params = request.urlParameters() else {
            XCTFail()
            return
        }
        
        XCTAssert("deferredUploadId=1" == params)
        
        let status = DeferredUploadStatus.completed
        let response = GetUploadsResultsResponse()
        response.status = status
        guard let dict = response.toDictionary else {
            XCTFail()
            return
        }
        
        guard let resultStatus = dict[GetUploadsResultsResponse.statusKey] as? String else {
            XCTFail()
            return
        }

        XCTAssert(resultStatus == status.rawValue)
    }
    
    func testSynchronizedThrows() throws {
        enum TestError: Error {
            case test
        }
        
        let block = Synchronized()

        do {
            try block.sync {
                throw TestError.test
            }
        } catch {
            return
        }
        XCTFail()
    }

    func testSynchronizedNoThrows() {
        let block = Synchronized()
        
        block.sync {
            print("Other Stuff")
        }
    }
}
