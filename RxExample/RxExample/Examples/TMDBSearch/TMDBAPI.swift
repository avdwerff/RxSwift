//
//  TMDBApi.swift
//  RxExample
//
//  Created by Alexander van der Werff on 05/11/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


private let apiKey = "f3efc3316ed9e0bb4b4605eaf0750e42"

private let baseUrlString = "http://api.themoviedb.org/3"


enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case HEAD = "HEAD"
}

func urlRequestForPath(url: String, parameters: Dictionary<String,AnyObject>?, method: HTTPMethod) -> NSURLRequest {
    return NSURLRequest()
}

class TMDBAPI {
    
    func config() {
        
    }

    func search(query: String) -> Observable<AnyObject> {
        
        var parameters = [String:AnyObject]()
        parameters["api_key"] = apiKey
        parameters["query"] = query
        
        let request = urlRequestForPath("\(baseUrlString)/search/multi", parameters:parameters, method: .GET)
        
        let session = NSURLSession.sharedSession()
        
        return session.rx_JSON(request)
            .map {$0}
            .catchError { error in
                return just([])
        }
    }
    
}
