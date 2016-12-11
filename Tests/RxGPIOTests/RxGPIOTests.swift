import XCTest
@testable import RxGPIO

class RxGPIOTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(RxGPIO().text, "Hello, World!")
    }


    static var allTests : [(String, (RxGPIOTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
