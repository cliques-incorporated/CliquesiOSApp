//
//  FirebaseLoginControllerProtocol.swift
//  Cliques
//
//  Created by Ethan Kusters on 6/13/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol FirebaseLoginControllerProtocol {
    func verifyPhoneNumber(phoneNumber: String, verificationRequestSuccess:@escaping (Error?)->())
    func signInWithVerificationCode(verificationCode: String, signInSuccess:@escaping(Error?, AuthDataResult?)->())
    static func signOut()
    func getUniqueIDIfLoggedIn() -> String?
}
