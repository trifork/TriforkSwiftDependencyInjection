import Foundation

/// Resolves the dependencies based on type or key.
public class Resolver {
    
    /// Shared singleton instancce
    public static let shared = Resolver()
    
    /// Allows you to register a new factory on the a key, which already had registered a factory 🤠
    public var allowOverride: Bool = false
    
    private var factories: [String: () -> Any] = [:]
    
    private init() { }
    
    /// Clean up 🧹
    deinit { reset() }
    
    /// Register instance for protocol type or key
    /// The key is optional and can be useful to register multiple instances of the same type. The key can be used in the `Inject` property wrapper.
    /// Note that keys are only unique for the same type. The same key can be used for different protocol types.
    public func register<T>(_ proto: T.Type, key: String? = nil, _ factory: @escaping () -> T) {
        let k = typeKey(proto, key: key)
        if factories[k] != nil && !allowOverride {
            fatalError("You are overriding the factory for '\(k)'. The resolver already contains a factory for that key. Enable `allowOverride` property to allow this behaviour.")
        }
        factories[k] = factory
    }
    
    /// Resolves the instance from the `Inject` property wrapper.
    internal func resolve<T>(key: String? = nil) -> T {
        let k = typeKey(T.self, key: key)
        let component: T? = factories[k]?() as? T
        guard let c = component else {
            fatalError("'\(k)' could not be resolved. Did you forget to call the register-function?")
        }
        return c
    }
    
    /// Resets all factories and sets allowOverride to false.
    internal func reset() {
        factories.removeAll()
        allowOverride = false
    }
    
    private func typeKey<T>(_ type: T.Type, key: String? = nil) -> String {
        let typeKey = String(describing: type)
        if let key = key {
            return "\(key)_\(typeKey)"
        } else {
            return typeKey
        }
    }
}
