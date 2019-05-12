//
//  UserModel.swift
//  Cliques
//
//  Created by Ethan Kusters on 5/11/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import Foundation
struct UserModel : Codable {
    let first: String
    let last: String
    let bio: String
    let phoneNumber: String
    let profileImageURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case first = "first"
        case last = "last"
        case bio = "bio"
        case phoneNumber = "id"
        case profileImageURL = "profileImageURL"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        first = try values.decodeIfPresent(String.self, forKey: .first) ?? ""
        last = try values.decodeIfPresent(String.self, forKey: .last) ?? ""
        bio = try values.decodeIfPresent(String.self, forKey: .bio) ?? ""
        phoneNumber = try values.decodeIfPresent(String.self, forKey: .phoneNumber) ?? ""
        profileImageURL = URL.init(string: try values.decodeIfPresent(String.self, forKey: .profileImageURL) ?? "")
    }
    
    init(from dictionary: [String:Any]) {
        first = dictionary[CodingKeys.first.stringValue] as? String ?? ""
        last = dictionary[CodingKeys.last.stringValue] as? String ?? ""
        bio = dictionary[CodingKeys.bio.stringValue] as? String ?? ""
        phoneNumber = dictionary[CodingKeys.phoneNumber.stringValue] as? String ?? ""
        profileImageURL = URL.init(string: dictionary[CodingKeys.profileImageURL.stringValue] as? String ?? "")
    }
    
}
