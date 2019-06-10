//
//  FeedFactoryTests.swift
//  Cliques
//
//  Created by Jasmine on 6/8/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import Foundation
import XCTest
@testable import Cliques

class FeedFactoryTests: XCTestCase {
    
    override func setUp() {
    }
    
    override func tearDown() {
    }
    
    func testGetCorrectFeedModel() {
        func stump(success: Bool) {
            guard success else {
                return
            }
        }
        let feedFactory = FeedFactory(feedUpdatedHandler: stump(success:))
        XCTAssertNotNil(feedFactory.makeFeedModel(clique: .Public))
        XCTAssertNotNil(feedFactory.makeFeedModel(clique: .Friends))
        XCTAssertNotNil(feedFactory.makeFeedModel(clique: .CloseFriends))
        XCTAssertNotNil(feedFactory.makeFeedModel(clique: .Family))
       
    }
    
   
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
 
    
}
