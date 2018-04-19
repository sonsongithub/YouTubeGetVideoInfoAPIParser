//
//  YouTubeGetVideoInfoAPIParserTests.swift
//  YouTubeGetVideoInfoAPIParserTests
//
//  Created by sonson on 2016/03/31.
//  Copyright © 2016年 sonson. All rights reserved.
//

import XCTest
import Foundation

@testable import YouTubeGetVideoInfoAPIParser

private func < <T: Comparable>(lhs: T, rhs: T) -> Bool {
    return lhs < rhs
}

private func > <T: Comparable>(lhs: T, rhs: T) -> Bool {
    return lhs > rhs
}

extension XCTestCase {
    func textFromFile(_ name: String) -> String? {
        if let path = Bundle(for: self.classForCoder).path(forResource: name, ofType: nil) {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                return String(data: data, encoding: String.Encoding.utf8)
            }
        }
        XCTFail()
        return nil
    }
    
    func jsonFromFile(_ name: String) -> Any? {
        if let path = Bundle(for: self.classForCoder).path(forResource: name, ofType: nil) {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                do {
                    return try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
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
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        let youtubeContentID = "C6TOajaKlzk" // 6AVCqPvoSFU
        
        let documentOpenExpectation = self.expectation(description: "")
        if let infoURL = URL(string: "https://www.youtube.com/get_video_info?video_id=\(youtubeContentID)") {
            let request = NSMutableURLRequest(url: infoURL)
            let session = URLSession(configuration: configuration)
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, _, error) -> Void in
                if let error = error {
                    print(error)
                } else if let data = data, let result = String(data: data, encoding: .utf8) {
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
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testErrorResponse() {
        if let text = textFromFile("error.txt") {
            do {
                _ = try FormatStreamMapFromString(text)
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
            if let text = textFromFile($0.0), let json = jsonFromFile($0.1) as? [String: AnyObject] {
                if let mapjson = json["url_encoded_fmt_stream_map"] as? [[String: String]] {
                    do {
                        let streaming = try YouTubeStreamingFromString(text)
                        if let title = json["title"] as? String {
                            XCTAssert(streaming.title == title)
                        } else { XCTFail() }
                        if let temp = json["length_seconds"] as? String, let lengthSeconds = Int(temp) {
                            XCTAssert(streaming.lengthSeconds == lengthSeconds)
                        } else { XCTFail() }
                    } catch {
                        print(error)
                        XCTFail()
                    }
                    do {
                        let array = try FormatStreamMapFromString(text)
                        
                        let sorted = array.sorted(by: { $0.itag > $1.itag })
                        XCTAssert(sorted.count == mapjson.count)
                        for i in 0 ..< sorted.count {
                            if let type = mapjson[i]["type"] {
                                XCTAssert(sorted[i].type.replacingOccurrences(of: "+", with: " ") == type)
                            } else { XCTFail() }
                            if let url = mapjson[i]["url"] {
                                XCTAssert(sorted[i].url.absoluteString == url)
                            } else { XCTFail() }
                            if let itag_string = mapjson[i]["itag"], let itag = Int(itag_string) {
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
