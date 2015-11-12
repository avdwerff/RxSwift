//
//  TMDBApi.swift
//  RxExample
//
//  Created by Alexander van der Werff on 05/11/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif


private let apiKey = "f3efc3316ed9e0bb4b4605eaf0750e42"

private let baseUrlString = "https://api.themoviedb.org/3"


enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case HEAD = "HEAD"
}

func stringFromParameters(parameters: Dictionary<String, AnyObject>) -> String {
    return parameters.map { (key, value) -> String in
        let val = "\(value)"
        return "\(key)=\(val)"
        }.joinWithSeparator("&")
}

func URLEscape(pathSegment: String) -> String {
    return pathSegment.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
}


func urlRequestForPath(url: String, parameters: Dictionary<String,AnyObject>?, method: HTTPMethod) -> NSURLRequest {
    
    var URL = NSURL(string: url)

    if parameters != nil {
        switch(method) {
        case .GET:
            URL = NSURL(string: "?\(URLEscape(stringFromParameters(parameters!)))", relativeToURL: URL)!
        default: break
        }
    }
    
    let req = NSMutableURLRequest(URL: URL!)
    req.setValue("application/json", forHTTPHeaderField: "Accept")
    req.HTTPMethod = method.rawValue
    return req
}

class TMDBAPI {
    
    let $ = Dependencies.sharedDependencies
    
    func requestTMDB(path:String, var parameters:[String:String]) -> Observable<AnyObject!> {

        parameters["api_key"] = apiKey
        
        let request = urlRequestForPath("\(baseUrlString)/\(path)", parameters:parameters, method: .GET)
        
        let session = NSURLSession.sharedSession()
        
        return session.rx_JSON(request)
            .observeOn($.backgroundWorkScheduler)
            .catchError { error in
                print("ERROR:: \(error)")
                return just([:])
        }
    }
    
    func config() -> Observable<AnyObject!> {
        
        var parameters = [String:AnyObject]()
        parameters["api_key"] = apiKey
        
        let request = urlRequestForPath("\(baseUrlString)/configuration", parameters:parameters, method: .GET)
        
        let session = NSURLSession.sharedSession()
        
        return session.rx_JSON(request)
            .observeOn($.backgroundWorkScheduler)
            .catchError { error in
                print("ERROR:: \(error)")
                return just([:])
        }
        
    }

    func search(query: String) -> Observable<AnyObject!> {
        
        var parameters = [String:AnyObject]()
        parameters["api_key"] = apiKey
        parameters["query"] = query
        
        let request = urlRequestForPath("\(baseUrlString)/search/multi", parameters:parameters, method: .GET)
        
        let session = NSURLSession.sharedSession()
        
        return session.rx_JSON(request)
            .observeOn($.backgroundWorkScheduler)
            .catchError { error in
                print("ERROR:: \(error)")
                return just([:])
        }
    }
    
}
