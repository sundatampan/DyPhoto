//
//  NSDateExtensionsTests.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 12/13/16.
//  Copyright © 2016 DyCode. All rights reserved.
//

import XCTest
@testable import DyPhotos

class NSDateExtensionsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTimeAgoString() {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd HH:mm:ss"
        
        let date = dateFormatter.dateFromString("20160101 00:00:01")!
        
        let date1H = dateFormatter.dateFromString("20160101 01:00:01")!
        let date3H = dateFormatter.dateFromString("20160101 04:00:00")!
        
        let date1M = dateFormatter.dateFromString("20160101 00:01:01")!
        let date3M = dateFormatter.dateFromString("20160101 00:04:00")!
        
        let date1S = dateFormatter.dateFromString("20160101 00:00:02")!
        let date3S = dateFormatter.dateFromString("20160101 00:00:04")!
        
        XCTAssertEqual(date1H.timeAgoString(date), "1h")
        XCTAssertEqual(date.timeAgoString(date3H), "3h")
        
        XCTAssertEqual(date.timeAgoString(date1M), "1m")
        XCTAssertEqual(date.timeAgoString(date3M), "3m")
        
        XCTAssertEqual(date.timeAgoString(date1S), "1s")
        XCTAssertEqual(date.timeAgoString(date3S), "3s")
        
        
        
        let dateD = dateFormatter.dateFromString("20160103 01:00:01")! // 2d
        let dateW = dateFormatter.dateFromString("20160115 00:01:01")! // 2w
        let dateY = dateFormatter.dateFromString("20180101 00:00:02")! // 2y
        
        XCTAssertEqual(date1H.timeAgoString(date), "1h")
        XCTAssertEqual(date.timeAgoString(date3H), "3h")
        
        XCTAssertEqual(date.timeAgoString(date1M), "1m")
        XCTAssertEqual(date.timeAgoString(date3M), "3m")
        
        XCTAssertEqual(date.timeAgoString(date1S), "1s")
        XCTAssertEqual(date.timeAgoString(date3S), "3s")
        
        XCTAssertEqual(date.timeAgoString(dateD), "2d")
        XCTAssertEqual(date.timeAgoString(dateW), "2w")
        XCTAssertEqual(date.timeAgoString(dateY), "2y")
        
    }
    
}
