//
//  Yunho.swift
//  Yunho
//
//  Created by Melon on 16/3/20.
//  Copyright © 2016年 Melon. All rights reserved.
//

import Foundation

class Yunho {
    
//    static let methodMap = [
//        Method.GET: "GET",
//        Method.POST: "POST"
//    ]
    
    enum Method: String {
        case GET = "GET"
        case POST = "POST"
    }
    
    enum Error {
        case InternalError(error: ErrorType)
        case NotOK(status: Int, response: Response)
    }

    struct Response {
        let code: Int
        let headers: [String: String]
        let data: NSData
        let string: String
        let json: AnyObject?
        let url: NSURL
        init (url: NSURL, code: Int, headers: [String: String], data: NSData = NSData(), string: String = "", json: AnyObject? = nil) {
            self.code = code
            self.headers = headers
            self.data = data
            self.string = string
            self.json = json
            self.url = url
        }
    }
    
    class func request (
        method: Method,
        url: String,
        headers: [String: String] = [String: String](),
        params: [String: AnyObject] = [String: AnyObject](),
        success: (Response) -> (),
        error: (Error) -> ()
        ) {
            let configure = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: configure)
            let request = NSMutableURLRequest()
            request.HTTPMethod = method.rawValue //methodMap[method]!
            headers.forEach { (key, value) -> () in
                request.setValue(value, forHTTPHeaderField: key)
            }
            // TODO: more params type
            let query = params.map { return "\($0)=\($1)" }.joinWithSeparator("&")
            switch (method) {
            case .GET:
                request.URL = NSURL(string: url + (query.characters.count == 0 ? "" : "?\(query)"))
            case .POST:
                request.URL = NSURL(string: url)
                request.HTTPBody = query.dataUsingEncoding(NSUTF8StringEncoding)
            }
        
            let task = session.dataTaskWithRequest(request) { (nsData, nsResponse, nsError) -> Void in
                // NSError
                if let nsError = nsError {
                    error(Error.InternalError(error: nsError))
                }
                
                let nsHTTPResponse = nsResponse as! NSHTTPURLResponse
                let headers = getHeaders(nsHTTPResponse)
                
                // NotOK Error
                // TODO: 2xx not 200
                if nsHTTPResponse.statusCode != 200 {
                    let response = Response(
                        url: nsResponse!.URL!,
                        code: nsHTTPResponse.statusCode,
                        headers: headers,
                        data: nsData!
                    )
                    error(Error.NotOK(status: nsHTTPResponse.statusCode, response: response))
                }
                
                // 2xx: OK
                let bodyString = String(data: nsData!, encoding: NSUTF8StringEncoding)!
                var bodyJson: AnyObject? = nil
                do {
                    bodyJson = try NSJSONSerialization.JSONObjectWithData(nsData!, options: [])
                } catch {
                    debugPrint(error)
                }
                let response = Response(url: nsResponse!.URL!, code: 200, headers: headers, data: nsData!, string: bodyString, json: bodyJson)
                success(response)
            }
            task.resume()
    }
    
    private class func getHeaders(nsHTTPResponse: NSHTTPURLResponse) -> [String: String] {
        var headers = [String: String]()
        nsHTTPResponse.allHeaderFields.forEach({ (key, value) in
            let stringKey = key as! String
            let stringValue = value as! String
            headers[stringKey] = stringValue
        })
        return headers
    }
    
//    class func download (
//        method: Method,
//        url: String,
//        headers: [String: String] = [String: String](),
//        params: [String: AnyObject] = [String: AnyObject](),
//        success:(Response) -> (),
//        error:(Error) -> ()) {
//            debugPrint("download")
//            let configure = NSURLSessionConfiguration.defaultSessionConfiguration()
//            let session = NSURLSession(configuration: configure, delegate: nil, delegateQueue: nil)
//            let request = NSMutableURLRequest()
//            request.HTTPMethod = method.rawValue//methodMap[method]!
//            
//            let query = params.map { (key, value) -> String in
//                return "\(key)=\(value)"
//            }.joinWithSeparator("&")
//            
//            switch(method) {
//            case .GET:
//                request.URL = NSURL(string: url + (params.count == 0 ? "" : "?\(query)"))
//            case .POST:
//                request.URL = NSURL(string: url)
//                request.HTTPBody = query.dataUsingEncoding(NSUTF8StringEncoding)
//            }
//            
//            let task = session.downloadTaskWithRequest(request) { (nsURL, nsResponse, nsError) -> Void in
//                if let nsError = nsError {
//                    error(Error.InternalError(error: nsError))
//                }
//                let nsHTTPResponse = nsResponse as! NSHTTPURLResponse
//                if nsHTTPResponse.statusCode != 200 {
//                    let response = Response(url: nsResponse!.URL!, code: nsHTTPResponse.statusCode, headers: headers)
//                    error(Error.NotOK(status: nsHTTPResponse.statusCode, response: response))
//                }
//                let response = Response(url: nsResponse!.URL!, code: nsHTTPResponse.statusCode, headers: [String : String]())
//                success(response)
//                
//                let bodyString = nsURL?.path 
//                debugPrint(bodyString)
//                debugPrint(nsResponse)
//                debugPrint(nsError)
//            }
//            task.resume()
//           
//    }
//    
//    class func upload (
//        url: String,
//        uploadData: [NSData],
//        headers: [String: String] = [String: String](),
//        params: [String: AnyObject] = [String: AnyObject](),
//        success:(Response) -> (),
//        error:(Error) -> ()) {
//            let configure = NSURLSessionConfiguration.defaultSessionConfiguration()
//            let session = NSURLSession(configuration: configure)
//            let request = NSMutableURLRequest()
//            request.HTTPMethod = "POST"
//            headers.forEach { (key, value) -> () in
//                request.setValue(value, forHTTPHeaderField: key)
//            }
//            // TODO: more params type
//            let query = params.map { return "\($0)=\($1)" }.joinWithSeparator("&")
//            request.URL = NSURL(string: url + (query.characters.count == 0 ? "" : "?\(query)"))
//            debugPrint(request)
//            for data in uploadData {
//                request.HTTPBody = data
//                let task = session.uploadTaskWithRequest(request, fromData: data) {
//                    (nsData, nsResponse, nsError) -> Void in
//                    if let nsError = nsError {
//                        error(Error.InternalError(error: nsError))
//                    }
//                    let nsHTTPResponse = nsResponse as! NSHTTPURLResponse
//                    if nsHTTPResponse.statusCode != 200 {
//                        let response = Response(url: nsResponse!.URL!, code: nsHTTPResponse.statusCode, headers: [String : String](), data: nsData!)
//                        error(Error.NotOK(status: nsHTTPResponse.statusCode, response: response))
//                    }
//                    
//                    let response = Response(url: nsResponse!.URL!, code: nsHTTPResponse.statusCode, headers: [String : String](), data: nsData!)
//                    success(response)
//                    
//                    let bodyString = String(data: nsData!, encoding: NSUTF8StringEncoding)
//                    debugPrint("uploadData",bodyString)
//                    debugPrint("nsResponse",nsResponse)
//                    debugPrint("nsError",nsError)
//                    
//                }
//                task.resume()
//            }
////            let task = session.uploadTaskWithRequest(request, fromData: uploadData) {
////                (nsData, nsResponse, nsError) -> Void in
////                if let nsError = nsError {
////                    error(Error.InternalError(error: nsError))
////                }
////                let nsHTTPResponse = nsResponse as! NSHTTPURLResponse
////                if nsHTTPResponse.statusCode != 200 {
////                    let response = Response(headers: [String : String](), data: nsData!)
////                    error(Error.NotOK(status: nsHTTPResponse.statusCode, response: response))
////                }
////                
////                let response = Response(headers: [String : String](), data: nsData!)
////                success(response)
////                
////                let bodyString = String(data: nsData!, encoding: NSUTF8StringEncoding)
////                debugPrint(bodyString)
////                debugPrint(nsResponse)
////                debugPrint(nsError)
////                
////            }
////            task.resume()
//           debugPrint("upload")
//            
//            
//    }
}