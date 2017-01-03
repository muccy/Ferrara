//
//  FerraraTests.swift
//  FerraraTests
//
//  Created by Marco on 03/01/17.
//  Copyright © 2017 MeLive. All rights reserved.
//

import XCTest
@testable import Ferrara

class FerraraTests: XCTestCase {
    func testInit() {
        let source = ["A"]
        let destination = ["B"]
        let diff = Diff(from: source, to: destination)
        
        XCTAssert(diff.source == source)
        XCTAssert(diff.destination == destination)
    }
}
