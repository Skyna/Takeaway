//
//  SortingTests.swift
//  SortingTests
//
//  Created by Emre Akman on 16/03/2018.
//  Copyright © 2018 Emre. All rights reserved.
//

import XCTest

class SortingTests: XCTestCase {
    
    var restaurants : [Restaurant] = []
    
    override func setUp() {
        super.setUp()
        
        restaurants = DataHandler.getRestaurants()
    }
    
    func testSortOpen() {
        RestaurantModel.shared.currentOpeningState.accept(SortingOption.openingState(.open))
        let sorted = RestaurantModel.shared.sort(self.restaurants).map{$0.status}
        
        let expected = [
            "open", "open", "open", "open", "open", "open", "open", "open",
            "order ahead", "order ahead", "order ahead", "order ahead", "order ahead", "order ahead", "order ahead",
            "closed", "closed", "closed", "closed"
        ]
        XCTAssertEqual(expected, sorted)
    }
    
    func testSortClosed() {
        RestaurantModel.shared.currentOpeningState.accept(SortingOption.openingState(.closed))
        let sorted = RestaurantModel.shared.sort(self.restaurants).map{$0.status}
        
        let expected = [
            "closed", "closed", "closed", "closed",
            "order ahead", "order ahead", "order ahead", "order ahead", "order ahead", "order ahead", "order ahead",
            "open", "open", "open", "open", "open", "open", "open", "open"
        ]
        XCTAssertEqual(expected, sorted)
    }
    
    func testSortBestMatch() {
        RestaurantModel.shared.currentOpeningState.accept(SortingOption.openingState(.all))
        RestaurantModel.shared.currentSortOption.accept(SortingOption.bestMatch)
        let sorted = RestaurantModel.shared.sort(self.restaurants).map{$0.sortingValues.bestMatch}

        XCTAssertTrue(sorted.isSorted())
    }
    
    func testSortNewest() {
        RestaurantModel.shared.currentOpeningState.accept(SortingOption.openingState(.all))
        RestaurantModel.shared.currentSortOption.accept(SortingOption.newest)
        let sorted = RestaurantModel.shared.sort(self.restaurants).map{$0.sortingValues.newest}
        
        XCTAssertTrue(sorted.isSorted())
    }
    
    func testSortRatingAverage() {
        RestaurantModel.shared.currentOpeningState.accept(SortingOption.openingState(.all))
        RestaurantModel.shared.currentSortOption.accept(SortingOption.ratingAverage)
        let sorted = RestaurantModel.shared.sort(self.restaurants).map{$0.sortingValues.ratingAverage}
        
        XCTAssertTrue(sorted.isSorted())
    }
    
    func testSortDistance() {
        RestaurantModel.shared.currentOpeningState.accept(SortingOption.openingState(.all))
        RestaurantModel.shared.currentSortOption.accept(SortingOption.distance)
        let sorted = RestaurantModel.shared.sort(self.restaurants).map{$0.sortingValues.distance}
        
        XCTAssertTrue(sorted.isSorted())
    }
    
    func testSortPopularity() {
        RestaurantModel.shared.currentOpeningState.accept(SortingOption.openingState(.all))
        RestaurantModel.shared.currentSortOption.accept(SortingOption.popularity)
        let sorted = RestaurantModel.shared.sort(self.restaurants).map{$0.sortingValues.popularity}
        
        XCTAssertTrue(sorted.isSorted())
    }
    
    func testSortAverageProductPrice() {
        RestaurantModel.shared.currentOpeningState.accept(SortingOption.openingState(.all))
        RestaurantModel.shared.currentSortOption.accept(SortingOption.averageProductPrice)
        let sorted = RestaurantModel.shared.sort(self.restaurants).map{$0.sortingValues.averageProductPrice}
        
        XCTAssertTrue(sorted.isSorted())
    }
    
    func testSortDeliveryCost() {
        RestaurantModel.shared.currentOpeningState.accept(SortingOption.openingState(.all))
        RestaurantModel.shared.currentSortOption.accept(SortingOption.deliveryCosts)
        let sorted = RestaurantModel.shared.sort(self.restaurants).map{$0.sortingValues.deliveryCosts}
        
        XCTAssertTrue(sorted.isSorted())
    }
    
    func testSortMinCost() {
        RestaurantModel.shared.currentOpeningState.accept(SortingOption.openingState(.all))
        RestaurantModel.shared.currentSortOption.accept(SortingOption.minCost)
        let sorted = RestaurantModel.shared.sort(self.restaurants).map{$0.sortingValues.minCost}

        XCTAssertTrue(sorted.isSorted())
    }
}
