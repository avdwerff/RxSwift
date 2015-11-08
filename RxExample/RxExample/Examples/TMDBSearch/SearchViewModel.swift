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


class SearchViewModel {
    
    private let disposableBag = DisposeBag()
    private let $ = Dependencies.sharedDependencies
    
    let api = TMDBAPI()
    let searchString:Variable<String> = Variable("")

    init() {
     
        searchString
            .throttle(0.3, MainScheduler.sharedInstance)
            .distinctUntilChanged()
            .map { [unowned self](searchString) -> AnyObject in
                return self.api.search(searchString)
            }.debug().subscribeNext { (result) -> Void in
                print(result)
            }.addDisposableTo(disposableBag)
        
    }
    
    func performSearch(query: String) -> Observable<String> {
        return api.search(query).map {_ in 
            return "top"
        }
    }
    
}