//
//  TMDbSearchResultViewController.swift
//  RxExample
//
//  Created by Alexander van der Werff on 05/11/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TMDbSearchResultsViewController: UIViewController, UISearchResultsUpdating {

    private let disposableBag = DisposeBag()
    private let api:TMDBAPI = TMDBAPI()
    private let searchString:Variable<String> = Variable("")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchString
            .throttle(0.3, MainScheduler.sharedInstance)
            .distinctUntilChanged()
            .map { [unowned self](searchString) -> AnyObject in
                return self.api.search(searchString)
            }.subscribeNext { (result) -> Void in
                print(result
                )
            }.addDisposableTo(disposableBag)
        
    }
    

    // MARK: UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchString.value = searchController.searchBar.text ?? ""
    }

}
