import Foundation

/// An object which can be identified
public protocol Identifiable {
    associatedtype Identifier: Equatable
    
    /// Object identifier
    var identifier: Identifier { get }
}

extension Matchable where Self: Identifiable & Equatable {
    func match(with object: Self) -> Match {
        if (self == object) {
            return .equal
        }
        else if (identifier == object.identifier) {
            return .change
        }
        else {
            return .none
        }
    }
}
