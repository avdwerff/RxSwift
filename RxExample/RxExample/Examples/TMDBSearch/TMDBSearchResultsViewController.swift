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


class TMDBItemCell: UICollectionViewCell {
    
    @IBOutlet weak var label:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}

class TMDBSearchResultsViewController: UIViewController, UISearchResultsUpdating {

    private let disposeBag = DisposeBag()
    
    typealias TMDBItemSection = SectionModel<String, TMDBItem>
    private let dataSource = RxCollectionViewSectionedReloadDataSource<TMDBItemSection>()
    private var sections = Variable([TMDBItemSection]())
    
    @IBOutlet weak var itemView:UICollectionView!
    
    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource.cellFactory = { (cv, ip, i) in
            let cell = cv.dequeueReusableCellWithReuseIdentifier("TMDBItemCell", forIndexPath: ip) as! TMDBItemCell
            
            
            return cell
        }

        self.sections
            .bindTo(itemView.rx_itemsWithDataSource(dataSource))
            .addDisposableTo(disposeBag)
        

        viewModel.searchResultItems.subscribeNext { [unowned self] (results) -> Void in
            self.sections.value = [
                TMDBItemSection(model: "Items", items: results)
            ]
        }.addDisposableTo(disposeBag)
        
    }
    

    // MARK: UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        viewModel.searchString.value = searchController.searchBar.text ?? ""
    }

}
