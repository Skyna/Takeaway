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

    let disposeBag              = DisposeBag()
    var restaurants             : BehaviorRelay<[Restaurant]> = DataHandler.getRestaurants()
    let sortingModel            = SortingModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //The UITableView's datasource is set by default, but since RxDataSources implements it's own datasource for the UITableView. Set it to nil or xCode will crash.
        self.tableView.dataSource = nil
        self.restaurants.bind(to: self.tableView.rx.items(cellIdentifier: "Cell")) { index, model, cell in
            cell.textLabel?.text = model.name
            cell.detailTextLabel?.text = model.status
        }
        .disposed(by: self.disposeBag)
        
        self.tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] index in
                self?.tableView.deselectRow(at: index, animated: true)
            }).disposed(by: self.disposeBag)
    }
    
    func sortRestaurants(option : SortingOption){
        print("Sort ", option)
        
        //Keep reference for chosen opening state
        if option.isOpeningState {
            sortingModel.currentOpeningState.accept(option)
        }
        
        let sortedRestaurant = self.restaurants.value
            .sorted(by: (option == sortingModel.currentSortOption.value && !sortingModel.currentSortIsReverse.value) ? option.sortReverse : option.sort)//Sort by value
            .sorted(by: sortingModel.currentOpeningState.value.sort) //Sort by opening state
        
        self.restaurants.accept(sortedRestaurant)
        
        //Keep reference for sort by values
        if !option.isOpeningState {
            sortingModel.currentSortIsReverse.accept(!sortingModel.currentSortIsReverse.value)
            sortingModel.currentSortOption.accept(option)
        }
        self.tableView.reloadData()
    }
}
