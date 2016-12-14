//
//  StringExtensionsTests.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 12/13/16.
//  Copyright © 2016 DyCode. All rights reserved.
//

import XCTest
@testable import DyPhotos

class StringExtensionsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMD5() {
        
        let md5Hash = "Hello, World!".md5
        XCTAssertEqual(md5Hash, "65a8e27d8879283831b664bd8b7f0ad4")
    }
    
}
