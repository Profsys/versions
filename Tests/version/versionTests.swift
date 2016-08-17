import XCTest
@testable import version

class versionTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(version().text, "Hello, World!")
    }


    static var allTests : [(String, (versionTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
