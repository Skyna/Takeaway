//
//  ViewController.swift
//  Takeaway
//
//  Created by Emre Akman on 13/03/2018.
//  Copyright © 2018 Emre. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var restaurantsViewController   : RestaurantsTableViewController?
    var sortOptionViewController    : SortOptionCollectionViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "restaurants"{
            restaurantsViewController = segue.destination as? RestaurantsTableViewController
        }
        else if segue.identifier == "sorting"{
            sortOptionViewController = segue.destination as? SortOptionCollectionViewController
            sortOptionViewController?.delegate = self
        }
    }
}

extension ViewController : SortOptionCollectionViewControllerDelegate{
    func didSelectSortOption(_ option : SortingOption){
        if let restaurantsViewController = self.restaurantsViewController {
            if option.isOpeningState{
                showOpeningsOptions()
            }
            else{
                restaurantsViewController.sortRestaurants(option: option)
            }
        }
    }
}

//Util
extension ViewController{
    func showOpeningsOptions(){
        guard let restaurantsViewController = self.restaurantsViewController else { return }
        
        let actionSheet = UIAlertController(title: "Opening", message: "Choose an option.", preferredStyle: .actionSheet)

        actionSheet.addAction( UIAlertAction(title: OpeningState.open.value, style: .default) { (action) in
            restaurantsViewController.sortRestaurants(option: .openingState(.open))
        })
        
        actionSheet.addAction( UIAlertAction(title: OpeningState.orderAhead.value, style: .default) { (action) in
            restaurantsViewController.sortRestaurants(option: .openingState(.orderAhead))
        })
        
        actionSheet.addAction( UIAlertAction(title: OpeningState.closed.value, style: .default) { (action) in
            restaurantsViewController.sortRestaurants(option: .openingState(.closed))
        })
        
        actionSheet.addAction( UIAlertAction(title: "Cancel", style: .cancel, handler : nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}
