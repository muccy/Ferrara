import Foundation

/// How two objects match
///
/// - none: No match
/// - change: Partial match (same object has changed)
/// - equal: Complete match
public enum Match: String, CustomDebugStringConvertible {
    case none = "❌"
    case change = "🔄"
    case equal = "✅"
    
    public var debugDescription: String {
        return self.rawValue
    }
}

/// The way two objects are compared to spot no match, partial match or complete match
public protocol Matchable {
    func match(with object: Self) -> Match
}

public extension Matchable where Self: Equatable {
    func match(with object: Self) -> Match {
        return self == object ? .equal : .none
    }
}

/// Wrapper for any matchable object
public struct AnyMatchable: Matchable {
    // https://gist.github.com/JadenGeller/f0d05a4699ddd477a2c1
    private let value: Any
    private let match: (Any) -> Match
    
    public init<M: Matchable>(_ value: M) {
        self.value = value
        self.match = { anotherValue in
            if let anotherValue = anotherValue as? M {
                return value.match(with: anotherValue)
            }
            else {
                return .none
            }
        }
    }
    
    public func match(with object: AnyMatchable) -> Match {
        return self.match(object.value)
    }
}
