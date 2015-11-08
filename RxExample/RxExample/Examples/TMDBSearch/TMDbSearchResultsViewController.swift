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
    
    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//https://api.themoviedb.org/3/search/multi?query=aa&api_key=f3efc3316ed9e0bb4b4605eaf0750e42
        
    }
    

    // MARK: UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        viewModel.searchString.value = searchController.searchBar.text ?? ""
    }

}
