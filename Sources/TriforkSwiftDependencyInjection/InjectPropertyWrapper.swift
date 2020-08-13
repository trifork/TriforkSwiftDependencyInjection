import Foundation

/// Property wrapper which resolves instances based on the type of the property.
@propertyWrapper
public struct Inject<Value> {
    
    /// Used to pick a spceific registered instance for this key. If not set the `Resolver` will call the factory based on the type.
    public let key: String?
    
    /// Wrapped value resolve
    public var wrappedValue: Value {
        Resolver.shared.resolve(key: key)
    }
    
    /// Constructor
    public init(_ key: String? = nil) {
        self.key = key
    }
}

