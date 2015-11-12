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
    
    @IBOutlet var imageView: UIImageView!
    
    var disposeBag: DisposeBag!
    
    var downloadableImage: Observable<DownloadableImage>?{
        didSet{
            let disposeBag = DisposeBag()
            
            self.downloadableImage?
                .asDriver(onErrorJustReturn: DownloadableImage.OfflinePlaceholder)
                .drive(imageView.rxex_downloadableImageAnimated(kCATransitionFade))
                .addDisposableTo(disposeBag)
            
            self.disposeBag = disposeBag
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        disposeBag = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}

class TMDBSearchResultsViewController: UIViewController, UISearchResultsUpdating {

    private let disposeBag = DisposeBag()
    
    typealias TMDBItemSection = SectionModel<String, TMDBItem>
    private let dataSource = RxCollectionViewSectionedReloadDataSource<TMDBItemSection>()
    private var sections = Variable([TMDBItemSection]())
    private let imageService = DefaultImageService.sharedImageService
    
    @IBOutlet weak var itemView:UICollectionView!
    
    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource.cellFactory = { (cv, ip, i) in
            let cell = cv.dequeueReusableCellWithReuseIdentifier("TMDBItemCell", forIndexPath: ip) as! TMDBItemCell
            cell.label.text = i.name
            if let imageUrl = i.imageUrlString, let url = NSURL(string: imageUrl) {
                cell.downloadableImage = self.imageService.imageFromURL(url)
            }
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
