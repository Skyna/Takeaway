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

class SortOptionCollectionViewController: UICollectionViewController {
    
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
    
    let restaurantModel            = RestaurantModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //The UICollectionView's datasource is set by default, but since RxDataSources implements it's own datasource for the UICollectionView. Set it to nil or xCode will crash.
        self.collectionView?.dataSource = nil
        self.sortingOptions.bind(to: self.collectionView!.rx.items(cellIdentifier: "Cell", cellType: SortingCollectionViewCell.self)){ row, model, cell in
            cell.backgroundColor = model == self.restaurantModel.currentSortOption.value ? UIColor(named:"SelectedOrange") : UIColor(named:"Orange")
            cell.lblName?.text = model.isOpeningState ? self.restaurantModel.currentOpeningState.value.name : model.name
        }.disposed(by: self.disposeBag)

        
        self.collectionView?.rx.itemSelected
            .throttle(0.1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] index in
                guard let strongSelf = self else { return }

                let option = strongSelf.sortingOptions.value[index.row]
                
                //Keep reference for chosen opening state
                if option.isOpeningState {
                    strongSelf.restaurantModel.openChoiceForOpeningState.accept(true)
                }
                
                //Keep reference for sort by values
                if !option.isOpeningState {
                    if strongSelf.restaurantModel.currentSortOption.value == option {
                        strongSelf.restaurantModel.currentSortIsReverse.accept(!strongSelf.restaurantModel.currentSortIsReverse.value)
                    }
                    else{
                         strongSelf.restaurantModel.currentSortIsReverse.accept(false)
                    }
                    
                    strongSelf.restaurantModel.currentSortOption.accept(option)
                }
                strongSelf.collectionView?.reloadData()
            }).disposed(by: self.disposeBag)
        
        self.restaurantModel.currentOpeningState
            .asObservable()
            .subscribe(onNext: {[weak self] (option) in
                guard let strongSelf = self else { return }
                strongSelf.collectionView?.reloadData()
            })
            .disposed(by: self.disposeBag)
    }
}

extension SortOptionCollectionViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.size.height
        return CGSize(width: height, height: height)
    }
}

internal class SortingCollectionViewCell : UICollectionViewCell {
    @IBOutlet var lblName : UILabel?
}
