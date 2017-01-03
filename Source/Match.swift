import Foundation

public enum Match {
    case none(sourceIndex: Int)
    case change(sourceIndex: Int, destinationIndex: Int)
    case equal(sourceIndex: Int, destinationIndex: Int)
}

public protocol Matchable {
    func match(with object: Any) -> Match
}
