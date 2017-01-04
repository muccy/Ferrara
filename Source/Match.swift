
import Foundation

public enum Match: String {
    case none = "❌"
    case change = "🔄"
    case equal = "✅"
}

extension Match: CustomDebugStringConvertible {
    public var debugDescription: String {
        return self.rawValue
    }
}

public protocol Matchable {
    func match(with object: Any) -> Match
}
