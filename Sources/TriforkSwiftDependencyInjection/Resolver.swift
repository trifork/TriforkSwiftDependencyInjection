import Foundation

/// Resolves the dependencies based on type or key.
public class Resolver {
    
    /// Shared singleton instancce
    public static let shared = Resolver()
    
    /// Allows you to register a new factory on the a key, which already had registered a factory 🤠
    public var allowOverride: Bool = false
    
    private var factories: [String: () -> Any] = [:]
    private var singletons: [String: Any] = [:]
    
    private init() { }
    
    /// Clean up 🧹
    deinit { reset() }
    
    /// Register factory function for protocol type or key
    /// The key is optional and can be useful to register multiple instances of the same type. The key can be used in the `Inject` property wrapper.
    /// Note that keys are only unique for the same type. The same key can be used for different protocol types.
    public func register<T>(_ proto: T.Type, key: String? = nil, _ factory: @escaping () -> T) {
        let k = typeKey(proto, key: key)
        assertOverride(key: k)
        factories[k] = factory
    }

    /// Register singleton instance
    public func registerAsSingleton<T>(_ proto: T.Type, _ singletonInstance: T) {
        let k = typeKey(proto, key: nil)
        assertOverride(key: k)
        singletons[k] = singletonInstance
    }
    
    /// Resolves the instance from the `Inject` property wrapper.
    internal func resolve<T>(key: String? = nil) -> T {
        let k = typeKey(T.self, key: key)
        let singleton: T? = singletons[k] as? T
        let component: T? = factories[k]?() as? T
        guard let c = singleton ?? component else {
            fatalError("'\(k)' could not be resolved. Did you forget to call the register-function?")
        }
        return c
    }
    
    /// Resets all factories and sets allowOverride to false.
    internal func reset() {
        singletons.removeAll()
        factories.removeAll()
        allowOverride = false
    }

    private func assertOverride(key: String) {
        if (factories[key] != nil || singletons[key] != nil) && !allowOverride {
            fatalError("You are overriding the factory for '\(key)'. The resolver already contains a factory for that key. Enable `allowOverride` property to allow this behaviour.")
        }
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
