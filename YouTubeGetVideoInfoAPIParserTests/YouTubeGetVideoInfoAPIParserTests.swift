//
//  YouTubeGetVideoInfoAPIParserTests.swift
//  YouTubeGetVideoInfoAPIParserTests
//
//  Created by sonson on 2016/03/31.
//  Copyright © 2016年 sonson. All rights reserved.
//

import XCTest
@testable import YouTubeGetVideoInfoAPIParser

extension XCTestCase {
    func file(name: String) -> String? {
        if let path = NSBundle(forClass: self.classForCoder).pathForResource(name, ofType:nil) {
            if let data = NSData(contentsOfFile: path) {
                return String(data: data, encoding: NSUTF8StringEncoding)
            }
        }
        XCTFail()
        return nil
    }
}

class YouTubeGetVideoInfoAPIParserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        ["xOvSwdi5dr4.txt", "alXF1gTNGWE.txt", "Hi9ySoy0JeQ.txt"].forEach({
            // Put setup code here. This method is called before the invocation of each test method in the class.
            print("----------------------------------")
            if let a = file($0) {
                let i = YouTubeStreamingFromString(a)
                print(i)
            }
        })
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
