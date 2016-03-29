//
//  YunhoTests.swift
//  YunhoTests
//
//  Created by Melon on 16/3/20.
//  Copyright © 2016年 Melon. All rights reserved.
//

import XCTest
@testable import Yunho

class YunhoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGET() {
        let expectation = self.expectationWithDescription("request should finish")
        
        Yunho.request(.GET, url: "https://httpbin.org/get", params: ["param": "param"], success: { (response) -> () in
            XCTAssertTrue(response.code == 200, "code is not 200")
            XCTAssertEqual(response.url.absoluteString, "https://httpbin.org/get?param=param", "url incorrect")
            XCTAssertTrue(response.string.containsString("{\n  \"args\": {\n    \"param\": \"param\"\n  }, \n  \"headers\": {\n    \"Accept\": \"*/*\", \n    \"Accept-Encoding\": \"gzip, deflate\", \n    \"Accept-Language\": \"en-us\", \n    \"Host\": \"httpbin.org\", \n    \"User-Agent\": \"xctest (unknown version) CFNetwork/758.3.15 Darwin/15.3.0\"\n  }"), "repsonse text incorrect")
            expectation.fulfill()
        }) { (error) -> () in
            XCTAssertNil(error)
        }
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testPOST() {
        let expectation = self.expectationWithDescription("request should finish")

        Yunho.request(.POST, url: "https://httpbin.org/post1", params: ["param": "param"], success: { (response) -> () in
            debugPrint(response)
            XCTAssertTrue(response.code == 200, "code is not 200")
            XCTAssertEqual(response.url.absoluteString, "https://httpbin.org/post", "url incorrect")
            XCTAssertTrue(response.string.containsString("{\n  \"args\": {}, \n  \"data\": \"\", \n  \"files\": {}, \n  \"form\": {\n    \"param\": \"param\"\n  }, \n  \"headers\": {\n    \"Accept\": \"*/*\", \n    \"Accept-Encoding\": \"gzip, deflate\", \n    \"Accept-Language\": \"en-us\", \n    \"Content-Length\": \"11\", \n    \"Content-Type\": \"application/x-www-form-urlencoded\", \n    \"Host\": \"httpbin.org\", \n    \"User-Agent\": \"xctest (unknown version) CFNetwork/758.3.15 Darwin/15.3.0\"\n  }, \n  \"json\": null"), "repsonse text incorrect")
            expectation.fulfill()
        }) { (error) -> () in
            XCTAssertNil(error)
        }
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
//    func testRequest() {
//        let expectation = self.expectationWithDescription("request should finish")
//       
//        Yunho.request(.POST, url: "https://httpbin.org/post", params: ["h": "h"], success: { (response) -> () in
//            expectation.fulfill()
//        }) { (error) -> () in
//        }
//        
//        self.waitForExpectationsWithTimeout(5.0, handler: nil)
//    }
    
//    func testDownload() {
//        //Yunho.download()
//        let expectation = self.expectationWithDescription("request should finish")
//        Yunho.download(.POST, url: "http://www.baidu.com", params: ["hhhhhhhhhh": "hhhhhhhhhh"], success: { (response) -> () in
//            expectation.fulfill()
//            }) { (error) -> () in
//        }
//        self.waitForExpectationsWithTimeout(5.0, handler: nil)
//    }
    
    
    
//    func testUpload() {
//        let expectation = self.expectationWithDescription("request should finish")
//        let headimg = UIImage(contentsOfFile: "/Users/melon/Downloads/images-2.png")
//        //(named: "给我评分@2x")
//        let imgName = "headimg"
//        let imgData = UIImageJPEGRepresentation(headimg!, 0.5)
//        let params:[String: AnyObject] = ["atk": "890c75aa49365bba77c4f10f78639350"]
//        let uploadData = [imgData!]
//        Yunho.upload(
//            "http://zyr.dkdoctor.huayandan.net/apiv1_user/edithead",
//            uploadData: uploadData,
//            params: params,
//            success: { (response) -> () in
//                expectation.fulfill()
//            }, error: { (error) -> () in
//        })
//        self.waitForExpectationsWithTimeout(5.0, handler: nil)
// 
//    }
    
}
