import XCTest
@testable import TriforkSwiftDependencyInjection

final class TriforkSwiftDependencyInjectionTests: XCTestCase {
    
    override func tearDown() {
        super.tearDown()
        Resolver.shared.reset()
    }
    
    /// Tests register of factory for protocol type.
    func testRegisterType() {
        Resolver.shared.register(Bread.self, { PainAuChocolat() })
        let tester = Tester()
        XCTAssertTrue(tester.bread is PainAuChocolat)
    }
    
    /// Tests registering on key and verifies that the Bread type is still available without key afterwards
    func testRegisterKey() {
        Resolver.shared.register(Bread.self, key: "🥐", { Croissant() })
        Resolver.shared.register(Bread.self, { PainAuChocolat() })
        let tester = Tester()
        
        XCTAssertTrue(tester.breadKey is Croissant)
        XCTAssertTrue(tester.bread is PainAuChocolat)
    }
    
    func testAllowOverride() {
        Resolver.shared.allowOverride = true
        
        Resolver.shared.register(Bread.self, { Croissant() })
        let tester1 = Tester()
        XCTAssertTrue(tester1.bread is Croissant)
        
        Resolver.shared.register(Bread.self, { Croissant() })
        let tester2 = Tester()
        XCTAssertTrue(tester2.bread is Croissant)
        
        Resolver.shared.register(Bread.self, { PainAuChocolat() })
        let tester3 = Tester()
        XCTAssertTrue(tester3.bread is PainAuChocolat)
        
        Resolver.shared.register(Bread.self, { Croissant() })
        let tester4 = Tester()
        XCTAssertTrue(tester4.bread is Croissant)
    }

    static var allTests = [
        ("testRegisterType", testRegisterType),
        ("testRegisterKey", testRegisterKey),
    ]
}
