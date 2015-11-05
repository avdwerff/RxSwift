//
//  ViewController.swift
//  RxExample-tvOS
//
//  Created by Alexander van der Werff on 05/11/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIButton {
    
    public var rx_action: ControlEvent<Void> {
        return rx_controlEvents(.PrimaryActionTriggered)
    }
    
}


class SearchTheMovieDBController: UIViewController {

    private let disposableBag = DisposeBag()
    
    @IBOutlet weak var startSearchTMDBButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startSearchTMDBButton.rx_action.subscribeNext { [unowned self](_) -> Void in
            self.search()
        }.addDisposableTo(disposableBag)
        
    }
    
    
    func search() {
        
        guard let resultsController = storyboard?.instantiateViewControllerWithIdentifier("TMDbSearchResultsViewController") as? TMDbSearchResultsViewController else { fatalError("Unable to instantiate a SearchResultsViewController.") }
        
        let searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = resultsController
        searchController.hidesNavigationBarDuringPresentation = false
        
        let searchPlaceholderText = NSLocalizedString("Enter search query", comment: "")
        searchController.searchBar.placeholder = searchPlaceholderText
        presentViewController(searchController, animated: true, completion: nil)
    }

}

