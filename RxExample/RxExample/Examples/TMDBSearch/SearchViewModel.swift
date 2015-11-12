    //
//  SearchViewModel.swift
//  RxExample
//
//  Created by Alexander van der Werff on 07/11/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

    
enum MediaType:String {
    case TV = "tv", Movie = "movie", Person = "person", Unknown = ""
    var imageKey: String? {
        get {
            switch self {
            case .Person: return "profile_path"
            case .Unknown: return nil
            case _: return "poster_path"
            }
        }
    }
}
    
struct TMDBItem {
    let name:String
    let imageUrlString:String?
}


class SearchViewModel {
    
    private let disposableBag = DisposeBag()
    private let $ = Dependencies.sharedDependencies
    private let api = TMDBAPI()
    private let configuration:Observable<[String:String]>
    let searchString:Variable<String> = Variable("")
    var searchResultItems:Observable<[TMDBItem]>!

    init() {
     
        searchResultItems = never()

        configuration = api.requestTMDB("configuration", parameters:[:]).map { config in
            var conf:[String:String] = [:]
            guard
                let imageObject = config["images"] ,
                let baseUrl = imageObject!["secure_base_url"] as? String,
                let posterSizes = imageObject!["poster_sizes"] as? Array<String>,
                let profileSizes = imageObject!["profile_sizes"] as? Array<String>
                else {

                print("no config for images")
                    
                return conf
            }
            conf["baseUrl"] = baseUrl
            conf["posterSize"] = posterSizes[posterSizes.count / 2]
            conf["profileSize"] = profileSizes[profileSizes.count / 2]
            
            return conf
        }
        
        let search = searchString
            .throttle(0.3, MainScheduler.sharedInstance)
            .skip(1)
            .distinctUntilChanged()
            .map { [unowned self](searchString) in
                return self.api.search(searchString)
            }
            .switchLatest()
        
        searchResultItems = combineLatest(configuration, search) { (config, searchResult) -> [TMDBItem] in
            guard
                let items = searchResult["results"] as? Array<AnyObject> else {
                return []
            }
            return items.map({ (item) -> TMDBItem in
                let name = item["name"] as? String ?? "n.a."
                
                if
                    let mediaType = MediaType(rawValue: (item["media_type"] as? String)!),
                    let type = mediaType.imageKey,
                    let imagePath = item[type] as? String
                    {
                        return TMDBItem(name: name, imageUrlString: "\(config["baseUrl"]!)\(config["posterSize"]!)\(imagePath)")
                }
                return TMDBItem(name: name, imageUrlString: nil)
            })
        }
        .catchErrorJustReturn([])
        .observeOn($.mainScheduler)

        
    }

    
}