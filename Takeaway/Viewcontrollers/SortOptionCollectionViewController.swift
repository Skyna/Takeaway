//
//  SortOptionCollectionViewController.swift
//  Takeaway
//
//  Created by Emre Akman on 13/03/2018.
//  Copyright © 2018 Emre. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

protocol SortOptionCollectionViewControllerDelegate {
    func didSelectSortOption(_ option : SortingOption)
}

class SortOptionCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let disposeBag = DisposeBag()
    var sortingOptions : BehaviorRelay<[SortingOption]> {
        return BehaviorRelay<[SortingOption]>(value:[.openingState(.all),
                                                     .bestMatch,
                                                     .newest,
                                                     .ratingAverage,
                                                     .distance,
                                                     .popularity,
                                                     .averageProductPrice,
                                                     .deliveryCosts,
                                                     .minCost])
        
    }
    
    var delegate : SortOptionCollectionViewControllerDelegate?
    let sortingModel            = SortingModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //The UICollectionView's datasource is set by default, but since RxDataSources implements it's own datasource for the UICollectionView. Set it to nil or xCode will crash.
        self.collectionView?.dataSource = nil
        self.sortingOptions.bind(to: self.collectionView!.rx.items(cellIdentifier: "Cell", cellType: SortingCollectionViewCell.self)){ row, model, cell in
            if model.isOpeningState {
                self.sortingModel.currentOpeningState
                                .asObservable()
                                .map{$0.name}
                                .bind(to: cell.lblName!.rx.text)
                                .disposed(by: self.disposeBag)
            }
            else {
                self.sortingModel.currentSortOption
                    .asObservable()
                    .map{$0 == model ? UIColor(named:"SelectedOrange") : UIColor(named:"Orange")}
                    .subscribe(onNext: {cell.backgroundColor = $0})
                    .disposed(by: self.disposeBag)
            }
            cell.lblName?.text = model.name
        }.disposed(by: self.disposeBag)

        
        self.collectionView?.rx.itemSelected
            .throttle(0.1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] index in
                guard let strongSelf = self,
                      let delegate = strongSelf.delegate else { return }

                let sortingOption = strongSelf.sortingOptions.value[index.row]

                delegate.didSelectSortOption(sortingOption)
            }).disposed(by: self.disposeBag)
    }
}

class SortingCollectionViewCell : UICollectionViewCell {
    @IBOutlet var lblName : UILabel?
}