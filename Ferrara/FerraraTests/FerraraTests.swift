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
        
        XCTAssert(diff.inserted == IndexSet(integersIn: 1...2))
        XCTAssert(diff.deleted.count == 0)
        XCTAssert(diff.movements.count == 0)
        XCTAssert(diff.matches == Set([DiffMatch(0)]))
    }
    
    func testDeletion() {
        let a = [0, 1, 2]
        let b = [0]
        
        let diff = Diff(from: a, to: b)
        
        XCTAssert(diff.inserted.count == 0)
        XCTAssert(diff.deleted == IndexSet(integersIn: 1...2))
        XCTAssert(diff.movements.count == 0)
        XCTAssert(diff.matches == Set([DiffMatch(0)]))
    }
}
