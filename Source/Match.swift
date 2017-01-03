
import Foundation

public enum Match {
    public typealias Index = IndexSet.Element
    
    case none(source: Index)
    case change(source: Index, destination: Index)
    case equal(source: Index, destination: Index)
}

extension Match {
    public var source: Index {
        switch self {
        case .change(let source, _), .equal(let source, _):
            return source
        case .none(let source):
            return source
        }
    }
    
    public var destination: Index? {
        switch self {
        case .change(_, let destination), .equal(_, let destination):
            return destination
        case .none:
            return nil
        }
    }
}

extension Match: Hashable {
    public static func ==(lhs: Match, rhs: Match) -> Bool {
        return lhs.debugDescription == lhs.debugDescription
    }
    
    public var hashValue: Int {
        return debugDescription.hashValue
    }
}

extension Match: CustomDebugStringConvertible {
    public var debugDescription: String {
        var string: String
        
        switch self {
        case .none(let sourceIndex):
            string = "❌ (\(sourceIndex))"
        case .change(let sourceIndex, let destinationIndex):
            string = "🔄 (\(sourceIndex) -> \(destinationIndex))"
        case .equal(let sourceIndex, let destinationIndex):
            string = "✅ (\(sourceIndex) -> \(destinationIndex))"
        }
        
        return string
    }
}

public protocol Matchable {
    func match(with object: Any) -> Match
}
