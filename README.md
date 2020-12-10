# TriforkSwiftDependencyInjection 💉

## Motivation

TriforkSwiftDependencyInjection is a super lightweight property wrapper based depedency injection framework. It supports simple type specific resolving, but also key-based. 

## Installation

Supports Swift Package Manager.

## Usage

The following models will be used to show the examples in the following sections:

```swift
protocol Bread { }
protocol Chocolate { }

struct Croissant : Bread { }
struct PainAuChocolat : Bread, Chocolate { }

protocol Worker { }
class MySingleton : Worker {
    static let shared = MySingleton()
    private init() { }
}

protocol Planet { }
class Earth : Planet {
}
```

### Registering

Factory functions can be registered via the Resolver by using a protocol type or a key.


```swift
Resolver.shared.register(Bread.self, { PainAuChocolat() }) //Result: Will inject new `PainAuChocolat` instances for `Bread` properties.
Resolver.shared.register(Bread.self, key: "🥐", { Croissant() }) //Result: Will inject new `Croissant` instances for `Bread` properties tagged with `"🥐"` key.

// Singletons can be injected in different ways depending on your implementation:
Resolver.shared.register(Worker.self, { MySingleton.shared }) //Result: Will inject the singleton instance of `MySingleton` for `Worker` properties, by invoking the function
Resolver.shared.registerAsSingleton(Worker.self, MySingleton.shared) //Result: Will inject the singleton instance of `MySingleton` for `Worker` properties 
Resolver.shared.registerAsSingleton(Planet.self, Earth()) //Result: Will inject the provided instance of `Earth` as singleton for `Planet` properties
```

**NOTE:** Keys are only unique for the specific type they are registered for. This means that the `"🥐"` key is still available for the `Chocolate` protocol, eventhough it was used `Bread`.

### Resolving

By using the `Inject` property wrapper you will be able to resolve the instances based on the registering.

```swift
class Bakery {
    @Inject var bread: Bread // Will be injected with PainAuChocolat()
    @Inject("🥐") var bread2: Bread // Will be injected with Croissant()
}
```

### Questions?

#### What happens if I register the same protocol multiple times?

It will fail with a `fatalError` telling you, that you are registering the same key multiple times. However, if you *really* want to do this, it can be done by setting the `allowOverride` property:

```swift
Resolver.shared.allowOverride = true
```

#### What happens if I try to resolve a type or key that isn't registers

It will fail with a `fatalError` telling you that the instance isn't registered.
