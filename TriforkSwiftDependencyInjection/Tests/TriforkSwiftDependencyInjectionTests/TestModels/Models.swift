import Foundation
@testable import TriforkSwiftDependencyInjection

protocol Bread { }

struct Croissant : Bread { }
struct PainAuChocolat : Bread { }

public struct Tester {
    @Inject var bread: Bread
    @Inject("🥐") var breadKey: Bread
}
