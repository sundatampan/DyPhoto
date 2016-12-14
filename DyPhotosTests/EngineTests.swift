//
//  EngineTests.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 12/13/16.
//  Copyright © 2016 DyCode. All rights reserved.
//

import XCTest
@testable import DyPhotos

class EngineTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMyFeed() {
        
        let expextation = self.expectationWithDescription("Test myFeed")
        
        Engine.shared.myFeed(nil) { (result, error) in
            
            if result != nil {
                XCTAssertTrue(result is [Photo])
            }
            else if error != nil {
                
            }
            else {
                XCTFail()
            }
            
            expextation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(10) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func testMapPhotos() {
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("ValidJson", withExtension: "json")!
        let data = NSData(contentsOfURL: url)
        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String: AnyObject]
        
        let photos = Engine.shared.mapPhotos(from: json)
        
        XCTAssertTrue(photos.count > 0)
    }
    
}
