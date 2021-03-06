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
    
    func testCreateSharingInvitationRequestWithExpiryDuration() {
        let expiry: TimeInterval = 1020

        let request = CreateSharingInvitationRequest()
        request.sharingGroupUUID = UUID().uuidString
        request.numberOfAcceptors = 1
        request.permission = .admin
        request.expiryDuration = expiry
        
        guard request.valid() else {
            XCTFail()
            return
        }
        
        guard let params = request.toDictionary else {
            XCTFail()
            return
        }
        
        guard let obtainedExpiry = params[CreateSharingInvitationRequest.CodingKeys.expiryDuration.rawValue] as? TimeInterval else {
            XCTFail()
            return
        }
        
        XCTAssert(obtainedExpiry == expiry)
    }
    
    func testCreateSharingInvitationRequestWithoutExpiryDuration() {
        let request = CreateSharingInvitationRequest()
        request.sharingGroupUUID = UUID().uuidString
        request.numberOfAcceptors = 1
        request.permission = .admin
        
        guard request.valid() else {
            XCTFail()
            return
        }
    }
    
    func testMoveFileGroupsRequest() throws {
        let request1 = MoveFileGroupsRequest()
        request1.fileGroupUUIDs = [UUID().uuidString]
        request1.sourceSharingGroupUUID = UUID().uuidString
        request1.destinationSharingGroupUUID = UUID().uuidString
        request1.usersThatMustBeInDestination = [1]
        
        request1.data =  try JSONEncoder().encode(request1)

        let request2 = try MoveFileGroupsRequest.decode(data: request1.data)
        
        XCTAssert(request2.fileGroupUUIDs == request1.fileGroupUUIDs)
        XCTAssert(request2.sourceSharingGroupUUID == request1.sourceSharingGroupUUID)
        XCTAssert(request2.destinationSharingGroupUUID == request1.destinationSharingGroupUUID)
        XCTAssert(request2.usersThatMustBeInDestination == [1])
    }
}
