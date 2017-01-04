import XCTest
@testable import Ferrara

extension Int: Matchable {} // Use Equatable standard implementation of match(with:)

class FerraraTests: XCTestCase {
    private struct PrefixHolder: Matchable {
        let string: String
        
        init(_ string: String) {
            self.string = string
        }
        
        func match(with object: PrefixHolder) -> Match {
            if (string == object.string) {
                return .equal
            }
            else if (string.commonPrefix(with: object.string).characters.count > 0)
            {
                return .change
            }
            else {
                return .none
            }
        }
    }
    
    func testSameSourceAndDestination() {
        let a = [0, 1, 2]
        let b = [0, 1 ,2]
        
        let diff = Diff(from: a, to: b)
        
        XCTAssert(diff.inserted.count == 0)
        XCTAssert(diff.deleted.count == 0)
        XCTAssert(diff.movements.count == 0)
        XCTAssert(diff.matches == Set([DiffMatch(0), DiffMatch(1), DiffMatch(2)]))
    }
    
    func testInsertion() {
        let a = [0]
        let b = [0, 1, 2]
        
        let diff = Diff(from: a, to: b)
        
        XCTAssert(diff.inserted == IndexSet(1...2))
        XCTAssert(diff.deleted.count == 0)
        XCTAssert(diff.movements.count == 0)
        XCTAssert(diff.matches == Set([DiffMatch(0)]))
    }
    
    func testDeletion() {
        let a = [0, 1, 2]
        let b = [0]
        
        let diff = Diff(from: a, to: b)
        
        XCTAssert(diff.inserted.count == 0)
        XCTAssert(diff.deleted == IndexSet(1...2))
        XCTAssert(diff.movements.count == 0)
        XCTAssert(diff.matches == Set([DiffMatch(0)]))
    }
    
    func testChanges() {
        let a = [PrefixHolder("a"), PrefixHolder("b"), PrefixHolder("c")]
        let b = [PrefixHolder("a"), PrefixHolder("b2"), PrefixHolder("c2")]
        
        let diff = Diff(from: a, to: b)
        
        XCTAssert(diff.inserted.count == 0)
        XCTAssert(diff.deleted.count == 0)
        XCTAssert(diff.movements.count == 0)
        XCTAssert(diff.matches == Set([DiffMatch(0), DiffMatch(changed: true, from: 1, to: 1), DiffMatch(changed: true, from: 2, to: 2)]))
    }
    
    func testMovements() {
        let a = [0, 1, 2, 3, 4]
        let b = [2, 1, 3, 4, 0]
        
        let diff = Diff(from: a, to: b)
        
        XCTAssert(diff.inserted.count == 0)
        XCTAssert(diff.deleted.count == 0)
        XCTAssert(diff.movements == Set([DiffMatch(0, 4), DiffMatch(2, 0)]))
        XCTAssert(diff.matches == Set([DiffMatch(0, 4), DiffMatch(1, 1), DiffMatch(2, 0), DiffMatch(3, 2), DiffMatch(4, 3)]))
    }
    
    func testInverseMovements() {
        let a = [0, 1, 2]
        let b = [2, 1, 0]
        
        let diff = Diff(from: a, to: b)
        
        XCTAssert(diff.inserted.count == 0)
        XCTAssert(diff.deleted.count == 0)
        XCTAssert(diff.movements == Set([DiffMatch(0, 2), DiffMatch(2, 0)]))
        XCTAssert(diff.matches == Set([DiffMatch(0, 2), DiffMatch(1, 1), DiffMatch(2, 0)]))
    }
    
    func testInverseMovements2() {
        let a = [0, 1, 2]
        let b = [1, 0, 2]
        
        let diff = Diff(from: a, to: b)
        
        XCTAssert(diff.inserted.count == 0)
        XCTAssert(diff.deleted.count == 0)
        XCTAssert(diff.movements == Set([DiffMatch(0, 1)]))
        XCTAssert(diff.matches == Set([DiffMatch(0, 1), DiffMatch(1, 0), DiffMatch(2, 2)]))
    }
    
    func testInsertionDeletion() {
        let a = [0]
        let b = [1, 2]
        
        let diff = Diff(from: a, to: b)
        
        XCTAssert(diff.inserted == IndexSet(0...1))
        XCTAssert(diff.deleted == IndexSet(0...0))
        XCTAssert(diff.movements.count == 0)
        XCTAssert(diff.matches.count == 0)
    }
    
    func testInsertionChange() {
        let a = [PrefixHolder("a")]
        let b = [PrefixHolder("a1"), PrefixHolder("b")]
        
        let diff = Diff(from: a, to: b)
        
        XCTAssert(diff.inserted == IndexSet(1...1))
        XCTAssert(diff.deleted.count == 0)
        XCTAssert(diff.movements.count == 0)
        XCTAssert(diff.matches == Set([DiffMatch(changed: true, from: 0, to: 0)]))
    }
    
    func testInsertionMovement() {
        let a = [0, 1, 2]
        let b = [1, 0, 3, 2, 4]
        
        let diff = Diff(from: a, to: b)
        
        XCTAssert(diff.inserted == IndexSet([2, 4]))
        XCTAssert(diff.deleted.count == 0)
        XCTAssert(diff.movements == Set([DiffMatch(0, 1)]))
        XCTAssert(diff.matches == Set([DiffMatch(0, 1), DiffMatch(1, 0), DiffMatch(2, 3)]))
    }
    
    func testDeletionChange() {
        let a = [PrefixHolder("a"), PrefixHolder("b")]
        let b = [PrefixHolder("b1")]
        
        let diff = Diff(from: a, to: b)
        
        XCTAssert(diff.inserted.count == 0)
        XCTAssert(diff.deleted == IndexSet(0...0))
        XCTAssert(diff.movements.count == 0)
        XCTAssert(diff.matches == Set([DiffMatch(changed: true, from: 1, to: 0)]))
    }
    
    func testDeletionMovement() {
        let a = [0, 1, 2, 3]
        let b = [3, 2]
        
        let diff = Diff(from: a, to: b)
        
        XCTAssert(diff.inserted.count == 0)
        XCTAssert(diff.deleted == IndexSet(0...1))
        XCTAssert(diff.movements == Set([DiffMatch(2, 1)]))
        XCTAssert(diff.matches == Set([DiffMatch(2, 1), DiffMatch(3, 0)]))
    }
    
    func testChangeMovement() {
        let a = [PrefixHolder("a"), PrefixHolder("b"), PrefixHolder("c"), PrefixHolder("d")]
        let b = [PrefixHolder("a"), PrefixHolder("c1"), PrefixHolder("b1"), PrefixHolder("d1")]
        
        let diff = Diff(from: a, to: b)
        
        XCTAssert(diff.inserted.count == 0)
        XCTAssert(diff.deleted.count == 0)
        XCTAssert(diff.movements == Set([DiffMatch(changed: true, from: 1, to: 2)]))
        XCTAssert(diff.matches == Set([DiffMatch(0), DiffMatch(changed: true, from: 1, to: 2), DiffMatch(changed: true, from: 2, to: 1), DiffMatch(changed: true, from: 3, to: 3)]))
    }
}
