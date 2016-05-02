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
    func textFromFile(name: String) -> String? {
        if let path = NSBundle(forClass: self.classForCoder).pathForResource(name, ofType:nil) {
            if let data = NSData(contentsOfFile: path) {
                return String(data: data, encoding: NSUTF8StringEncoding)
            }
        }
        XCTFail()
        return nil
    }
    
    func jsonFromFile(name: String) -> AnyObject? {
        if let path = NSBundle(forClass: self.classForCoder).pathForResource(name, ofType:nil) {
            if let data = NSData(contentsOfFile: path) {
                do {
                    return try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions())
                } catch {
                    XCTFail((error as NSError).description)
                    return nil
                }
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
    
    func testDownload() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        let youtubeContentID = "xOvSwdi5dr4"
        let documentOpenExpectation = self.expectationWithDescription("")
        if let infoURL = NSURL(string:"https://www.youtube.com/get_video_info?video_id=\(youtubeContentID)") {
            let URLRequest = NSMutableURLRequest(URL: infoURL)
            let session = NSURLSession(configuration: configuration)
            let task = session.dataTaskWithRequest(URLRequest, completionHandler: { (data, response, error) -> Void in
                if let error = error {
                    print(error)
                } else if let data = data, result = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
                    do {
                        let maps = try FormatStreamMapFromString(result)
                        if let map = maps.first {
                            print(map.url)
                        }
                    } catch {
                        print(error)
                        XCTFail()
                    }
                    do {
                        let streaming = try YouTubeStreamingFromString(result)
                        print(streaming.title)
                    } catch {
                        print(error)
                        XCTFail()
                    }
                }
                documentOpenExpectation.fulfill()
            })
            task.resume()
        }
        self.waitForExpectationsWithTimeout(30, handler: nil)
    }
    
    func testErrorResponse() {
        if let text = textFromFile("error.txt") {
            do {
                let _ = try FormatStreamMapFromString(text)
                XCTFail()
            } catch {
                print(error)
            }
        }
    }
    
    func testExample() {
        [
            ("xOvSwdi5dr4.txt", "xOvSwdi5dr4.json"),
            ("alXF1gTNGWE.txt", "alXF1gTNGWE.json"),
            ("Hi9ySoy0JeQ.txt", "Hi9ySoy0JeQ.json")
        ].forEach({
            if let text = textFromFile($0.0), json = jsonFromFile($0.1) as? [String:AnyObject] {
                if let mapjson = json["url_encoded_fmt_stream_map"] as? [[String:String]] {
                    do {
                        let streaming = try YouTubeStreamingFromString(text)
                        if let title = json["title"] as? String {
                            XCTAssert(streaming.title == title)
                        } else { XCTFail() }
                        if let temp = json["length_seconds"] as? String, lengthSeconds = Int(temp) {
                            XCTAssert(streaming.lengthSeconds == lengthSeconds)
                        } else { XCTFail() }
                    } catch {
                        print(error)
                        XCTFail()
                    }
                    do {
                        let map = try FormatStreamMapFromString(text)
                        let sorted = map.sort({ Int($0.0.itag) > Int($0.1.itag) })
                        XCTAssert(sorted.count == mapjson.count)
                        for i in 0 ..< sorted.count {
                            if let type = mapjson[i]["type"] {
                                XCTAssert(sorted[i].type.stringByReplacingOccurrencesOfString("+", withString: " ") == type)
                            } else { XCTFail() }
                            if let url = mapjson[i]["url"] {
                                XCTAssert(sorted[i].url.absoluteString == url)
                            } else { XCTFail() }
                            if let itag = mapjson[i]["itag"] {
                                XCTAssert(sorted[i].itag == itag)
                            } else { XCTFail() }
                            if let fallback_host = mapjson[i]["fallback_host"] {
                                XCTAssert(sorted[i].fallbackHost == fallback_host)
                            } else { XCTFail() }
                            if let quality = mapjson[i]["quality"] {
                                XCTAssert(sorted[i].quality.string == quality)
                            } else { XCTFail() }
                        }
                    } catch {
                        print(error)
                        XCTFail()
                    }
                } else {
                    XCTFail()
                }
            } else {
                XCTFail()
            }
        })
    }
}
