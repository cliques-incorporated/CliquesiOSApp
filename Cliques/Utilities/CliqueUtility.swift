//
//  CliqueUtility.swift
//  Cliques
//
//  Created by Ethan Kusters on 6/7/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import Foundation
import UIKit

class CliqueUtility {
    private static let PublicColor = UIColor.init(red: 28/255.0, green: 185/255.0, blue: 152/255.0, alpha: 1.0)
    private static let FriendsColor = UIColor.init(red: 211/255.0, green: 213/255.0, blue: 50/255.0, alpha: 1.0)
    private static let CloseFriendsColor = UIColor.init(red: 120/255.0, green: 128/255.0, blue: 255/255.0, alpha: 1.0)
    private static let FamilyColor = UIColor.init(red: 191/255.0, green: 90/255.0, blue: 97/255.0, alpha: 1.0)
    
    public static func getFamilyColor() -> UIColor {
        return FamilyColor
    }
    public static func getPublicColor() -> UIColor {
        return PublicColor
    }
    public static func getCloseFriendsColor() -> UIColor {
        return CloseFriendsColor
    }
    public static func getFriendsColor() -> UIColor {
        return FriendsColor
    }
    
    public enum CliqueTitles: String {
        case Public = "Public"
        case Family = "Family"
        case CloseFriends = "Close Friends"
        case Friends = "Friends"
    }
    
    public static func GetCliqueColor(clique: CliqueTitles) -> UIColor {
        switch clique {
        case .Public:
            return PublicColor
        case .Friends:
            return FriendsColor
        case .CloseFriends:
            return CloseFriendsColor
        case .Family:
            return FamilyColor
        }
    }
    
    public static func GetDatabaseString(clique: CliqueTitles) -> String {
        switch clique {
        case .Public:
            return "publicClique"
        case .Friends:
            return "friendsClique"
        case .CloseFriends:
            return "closeFriendsClique"
        case .Family:
            return "familyClique"
        }
    }
    
    public static func GetCliqueForIndex(index: Int) -> CliqueTitles? {
        switch index {
        case 0:
            return .Public
        case 1:
            return .Friends
        case 2:
            return .CloseFriends
        case 3:
            return .Family
        default:
            return nil
        }
    }
    
}
