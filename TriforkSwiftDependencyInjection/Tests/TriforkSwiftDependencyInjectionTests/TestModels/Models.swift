import Foundation
@testable import TriforkSwiftDependencyInjection

protocol Chocolate { }

protocol Bread { }

struct Croissant : Bread { }
struct PainAuChocolat : Bread, Chocolate { }

public struct Tester {
    @Inject var bread: Bread
    @Inject("🥐") var breadKey: Bread
    @Inject("🥐") var chocolate: Chocolate
}
