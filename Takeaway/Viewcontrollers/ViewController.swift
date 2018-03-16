//
//  ViewController.swift
//  Takeaway
//
//  Created by Emre Akman on 13/03/2018.
//  Copyright © 2018 Emre. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar : UISearchBar?
    
    let restaurantModel  = RestaurantModel.shared
    let disposeBag       = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantModel.openChoiceForOpeningState
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.showOpeningsOptions()
            })
            .disposed(by: self.disposeBag)
    }
}

extension ViewController{
    func showOpeningsOptions(){
        
        let actionSheet = UIAlertController(title: "Opening State", message: "Choose an openings state.", preferredStyle: .actionSheet)

        actionSheet.addAction( UIAlertAction(title: OpeningState.open.value, style: .default) { (action) in
            self.restaurantModel.currentOpeningState.accept(SortingOption.openingState(.open))
        })
        
        actionSheet.addAction( UIAlertAction(title: OpeningState.closed.value, style: .default) { (action) in
            self.restaurantModel.currentOpeningState.accept(SortingOption.openingState(.closed))
        })
        
        actionSheet.addAction( UIAlertAction(title: "Cancel", style: .cancel, handler : nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension ViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        restaurantModel.searchSubject.accept(searchBar.text!)
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        restaurantModel.resetRestaurantList.accept(true)
        restaurantModel.searchSubject.accept("")
        searchBar.text = ""
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            restaurantModel.resetRestaurantList.accept(true)
        }
        else{
            restaurantModel.searchSubject.accept(searchBar.text!)
        }
    }
}
