//
//  RestaurantsTableViewController.swift
//  Takeaway
//
//  Created by Emre Akman on 13/03/2018.
//  Copyright © 2018 Emre. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class RestaurantsTableViewController: UITableViewController {
    
    enum Section : Int{
        case favorite = 0
        case all
    }

    let disposeBag              = DisposeBag()
    let restaurantModel         = RestaurantModel.shared
    var dataSource              : RxTableViewSectionedReloadDataSource<RestaurantSection>?
    var sections                = BehaviorRelay<[RestaurantSection]>(value:[])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //The UITableView's datasource is set by default, but since RxDataSources implements it's own datasource for the UITableView. Set it to nil or xCode will crash.
        self.tableView.dataSource = nil
        self.tableView.rowHeight = 44
        self.dataSource = RxTableViewSectionedReloadDataSource<RestaurantSection>(
            configureCell: { ds, tv, ip, model in
                let cell = tv.dequeueReusableCell(withIdentifier: "Cell") as! RestaurantCell
                cell.lblName?.text = model.name
                cell.lblOpeningState?.text = model.status
                self.restaurantModel.currentSortOption
                    .asObservable()
                    .map{model.sortValue($0)}
                    .bind(to: cell.lblSortValue!.rx.text)
                    .disposed(by: self.disposeBag)
            
                cell.imgFavorite?.image = ip.section == Section.favorite.rawValue ?
                                                        UIImage(named: "favorite-yes") : UIImage(named: "favorite-no")
 
                return cell
        }, titleForHeaderInSection: { (ds, section) -> String? in
            return ds[section].headerValue()
        })
        
        self.sections
            .asObservable()
            .bind(to: tableView.rx.items(dataSource: self.dataSource!))
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] index in
                guard let strongSelf = self else { return }
                strongSelf.tableView.deselectRow(at: index, animated: true)
                
                let restaurant = strongSelf.sections.value[index.section].items[index.row]
                if Storage.fileExists(restaurant.name) {
                    Storage.remove(restaurant.name)
                }
                else{
                    Storage.store(restaurant, fileName: restaurant.name)
                }
                
                strongSelf.sortRestaurants()
                
            }).disposed(by: self.disposeBag)
        
        Observable.combineLatest(restaurantModel.currentOpeningState.asObservable(),
                                 restaurantModel.currentSortOption.asObservable(),
                                 restaurantModel.currentSortIsReverse.asObservable())
            .subscribe(onNext: { [weak self] (currentOpeningState, currentSortOption, reverse) in
                guard let strongSelf = self else { return }
                strongSelf.sortRestaurants()
            })
            .disposed(by: self.disposeBag)
        
        
        restaurantModel.searchSubject.asObservable()
            .throttle(0.1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (text) in
                guard let strongSelf = self else { return }
                strongSelf.sortRestaurants()
            })
            .disposed(by: self.disposeBag)
        
        restaurantModel.resetRestaurantList.asObservable()
            .subscribe(onNext: { [weak self] (text) in
                guard let strongSelf = self else { return }
                strongSelf.sortRestaurants()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func sortRestaurants(){
        
        var favorites       = RestaurantModel.shared.sort(DataHandler.getFavoriteRestaurants())
        var nonFavorites    = RestaurantModel.shared.sort(DataHandler.getNonFavoriteRestaurants())
        let searchText      = self.restaurantModel.searchSubject.value
        
        if !searchText.isEmpty {
            favorites = favorites.filter{$0.name.lowercased().contains(searchText.lowercased())}
            nonFavorites = nonFavorites.filter{$0.name.lowercased().contains(searchText.lowercased())}
        }
        
        self.sections.accept([RestaurantSection(header: "Favorite", items: favorites),
                               RestaurantSection(header: "Restaurants", items: nonFavorites)])
    }
}

internal struct RestaurantSection {
    var header : String
    var items : [Restaurant]
    
    func headerValue() -> String{
        return "\(header) (\(items.count))"
    }
}

extension RestaurantSection : SectionModelType {
    init(original: RestaurantSection, items: [Restaurant]) {
        self = original
        self.items = items
    }
}

internal class RestaurantCell : UITableViewCell{
    @IBOutlet weak var lblName          : UILabel?
    @IBOutlet weak var lblOpeningState  : UILabel?
    @IBOutlet weak var lblSortValue     : UILabel?
    @IBOutlet weak var imgFavorite      : UIImageView?
    
}
