//
//  FerraraTests.swift
//  FerraraTests
//
//  Created by Marco on 03/01/17.
//  Copyright © 2017 MeLive. All rights reserved.
//

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
}
