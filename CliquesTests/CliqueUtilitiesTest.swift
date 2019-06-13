//
//  CliqueUtilitiesTest.swift
//  CliquesTests
//
//  Created by Jasmine on 6/8/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import XCTest

class CliqueUtilitiesTest: XCTestCase {
    func testColorGetters() {
          XCTAssertEqual(CliqueUtility.getFamilyColor(), UIColor.init(red: 191/255.0, green: 90/255.0, blue: 97/255.0, alpha: 1.0))
         XCTAssertEqual(CliqueUtility.getCloseFriendsColor(),UIColor.init(red: 120/255.0, green: 128/255.0, blue: 255/255.0, alpha: 1.0))
         XCTAssertEqual(CliqueUtility.getFriendsColor(), UIColor.init(red: 211/255.0, green: 213/255.0, blue: 50/255.0, alpha: 1.0))
          XCTAssertEqual(CliqueUtility.getPublicColor(), UIColor.init(red: 28/255.0, green: 185/255.0, blue: 152/255.0, alpha: 1.0))
    }
    
    func testCliqueTitlesColor(){
        XCTAssertEqual(CliqueUtility.GetCliqueColor(clique: CliqueUtility.CliqueTitles(rawValue: "Family")!), CliqueUtility.getFamilyColor())
        XCTAssertEqual(CliqueUtility.GetCliqueColor(clique: CliqueUtility.CliqueTitles(rawValue: "Close Friends")!), CliqueUtility.getCloseFriendsColor())
        XCTAssertEqual(CliqueUtility.GetCliqueColor(clique: CliqueUtility.CliqueTitles(rawValue: "Friends")!), CliqueUtility.getFriendsColor())
        XCTAssertEqual(CliqueUtility.GetCliqueColor(clique: CliqueUtility.CliqueTitles(rawValue: "Public")!), CliqueUtility.getPublicColor())
    }
    
    func testDatabaseStrings(){
        XCTAssertEqual(CliqueUtility.GetDatabaseString(clique: CliqueUtility.CliqueTitles(rawValue: "Family")!),"familyClique" )
        XCTAssertEqual(CliqueUtility.GetDatabaseString(clique: CliqueUtility.CliqueTitles(rawValue: "Close Friends")!),"closeFriendsClique" )
        XCTAssertEqual(CliqueUtility.GetDatabaseString(clique: CliqueUtility.CliqueTitles(rawValue: "Friends")!),"friendsClique" )
        XCTAssertEqual(CliqueUtility.GetDatabaseString(clique: CliqueUtility.CliqueTitles(rawValue: "Public")!),"publicClique" )
        
    }
    
}
