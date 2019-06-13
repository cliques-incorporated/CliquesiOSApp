//
//  UserModelProtocol.swift
//  Cliques
//
//  Created by Ethan Kusters on 6/13/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import Foundation

protocol UserModelProtocol {
    func getPhoneNumber() -> String
    func getCloseFriendsClique() -> [String]
    func getFriendsClique() -> [String]
    func getFamilyClique() -> [String]
    func getPublicClique() -> [String]
}
