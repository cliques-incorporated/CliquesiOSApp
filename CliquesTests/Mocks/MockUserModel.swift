//
//  MockUserModel.swift
//  CliquesTests
//
//  Created by Ethan Kusters on 6/13/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import Foundation

class MockUserModel: UserModelProtocol {    
    var mockPhoneNumber = ""
    func getPhoneNumber() -> String {
        return mockPhoneNumber
    }
    
    var mockCloseFriendsClique = [String]()
    func getCloseFriendsClique() -> [String] {
        return mockCloseFriendsClique
    }
    
    var mockFriendsClique = [String]()
    func getFriendsClique() -> [String] {
        return mockFriendsClique
    }
    
    var mockFamilyClique = [String]()
    func getFamilyClique() -> [String] {
        return mockFamilyClique
    }
    
    var mockPublicClique = [String]()
    func getPublicClique() -> [String] {
        return mockPublicClique
    }
    
    
}
