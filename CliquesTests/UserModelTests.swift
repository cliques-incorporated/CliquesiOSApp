//
//  UserModelTests.swift
//  CliquesTests
//
//  Created by Jasmine on 6/13/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import Foundation
import XCTest
@testable import Cliques

class UserModelTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        UserModelSingleton.GetInstance().tearDown()
    }
    
    //Tests if the first names are the same
    func testUserModelFirstName() {
        let mockFirestore = MockFirestoreController()
        let mockUserModel = MockUserModel()
        let mockFirebaseStorageController = MockFirebaseStorageController()
        let mockFirebaseLoginController = MockFirebaseLoginController()
        mockFirestore.mockUserProfile.first = "Sarah"
        mockFirestore.mockUserProfile.last = "Owens"
        
        //Create a real User Model Singleton with fake firestore,
        //fake firebase storage controller, and fake firebase login controller
        let ums = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        
        let ums2 = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
    
        XCTAssertEqual(ums.getFirstName(), ums2.getFirstName())
        XCTAssertEqual("Sarah", ums2.getFirstName())
       
    }
    
    //Tests if the last names are the same
    func testUserModelLastName(){
        let mockFirestore = MockFirestoreController()
        let mockUserModel = MockUserModel()
        let mockFirebaseStorageController = MockFirebaseStorageController()
        let mockFirebaseLoginController = MockFirebaseLoginController()
        mockFirestore.mockUserProfile.last = "Owens"
        mockFirestore.mockUserProfile.first = "Sarah"
        //Create a real User Model Singleton with fake firestore,
        //fake firebase storage controller, and fake firebase login controller
        let ums = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        
        let ums2 = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)

        
        XCTAssertEqual(ums.getLastName(), ums2.getLastName())
        XCTAssertEqual("Owens", ums2.getLastName())
        
    }
    
    //Make sure the profile bios stay the same
    func testUserModelBio(){
        let mockFirestore = MockFirestoreController()
        let mockUserModel = MockUserModel()
        let mockFirebaseStorageController = MockFirebaseStorageController()
        let mockFirebaseLoginController = MockFirebaseLoginController()
        mockFirestore.mockUserProfile.bio = "Just a small town girl"
        mockFirestore.mockUserProfile.last = "Bradbury"
        mockFirestore.mockUserProfile.first = "Bertha Rose"
        //Create a real User Model Singleton with fake firestore,
        //fake firebase storage controller, and fake firebase login controller
        let ums = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        
        let ums2 = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        
        XCTAssertEqual(ums.getBio(), ums2.getBio())
        XCTAssertNotEqual(ums.getBio(), " livin in a lonely world ... ")
        XCTAssertEqual(ums.getBio(), "Just a small town girl")
    }
    
    //Make sure the profile phone numbers are the same
    func testUserModelPhoneNumber(){
        let mockFirestore = MockFirestoreController()
        let mockUserModel = MockUserModel()
        let mockFirebaseStorageController = MockFirebaseStorageController()
        let mockFirebaseLoginController = MockFirebaseLoginController()
        mockFirestore.mockUserProfile.first = "Bertha Rose"
        mockFirestore.mockUserProfile.last = "Bradbury"
        mockFirestore.mockUserProfile.uniqueID = "QQQQ"
        
        //Create a real User Model Singleton with fake firestore,
        //fake firebase storage controller, and fake firebase login controller
        let ums = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        
        let ums2 = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        
        XCTAssertEqual(ums.getPhoneNumber(), ums2.getPhoneNumber())
        XCTAssertNotEqual("QQQ_QQQ_QQQQ", ums2.getPhoneNumber())
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //Tests to make sure first name and last name are different
    func testUserModelFirstLastDiff() {
        let mockFirestore = MockFirestoreController()
        let mockUserModel = MockUserModel()
        let mockFirebaseStorageController = MockFirebaseStorageController()
        let mockFirebaseLoginController = MockFirebaseLoginController()
        mockFirestore.mockUserProfile.first = "Bertha Rose"
        mockFirestore.mockUserProfile.last = "Bradbury"
        
        //Create a real User Model Singleton with fake firestore,
        //fake firebase storage controller, and fake firebase login controller
        let ums = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        
        let ums2 = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        
        XCTAssertNotEqual(ums.getFirstName(), ums2.getLastName())
        XCTAssertEqual("Bertha Rose", ums.getFirstName())
        XCTAssertEqual("Bradbury", ums.getLastName())
        
    }
    
    func testFullName(){
        let mockFirestore = MockFirestoreController()
        let mockUserModel = MockUserModel()
        let mockFirebaseStorageController = MockFirebaseStorageController()
        let mockFirebaseLoginController = MockFirebaseLoginController()
    
        mockFirestore.mockUserProfile.first = "Bertha Rose"
        mockFirestore.mockUserProfile.last = "Bradbury"
        
        //Create a real User Model Singleton with fake firestore,
        //fake firebase storage controller, and fake firebase login controller
        let ums = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        
        let ums2 = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        
        XCTAssertNotEqual(ums.getName(), "Bradbury Bertha Rose")
        XCTAssertEqual(ums.getName(), "Bertha Rose Bradbury")
        XCTAssertEqual(ums.getName(),ums2.getName())
        
    }
    
    func testRequestLoginWithPhone(){
        let mockFirestore = MockFirestoreController()
        let mockUserModel = MockUserModel()
        let mockFirebaseStorageController = MockFirebaseStorageController()
        let mockFirebaseLoginController = MockFirebaseLoginController()
      
        //Create a real User Model Singleton with fake firestore,
        //fake firebase storage controller, and fake firebase login controller
        let ums = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)

    
    }
    
    func testFriendsClique() {
        let mockFirestore = MockFirestoreController()
        let mockUserModel = MockUserModel()
        let mockFirebaseStorageController = MockFirebaseStorageController()
        let mockFirebaseLoginController = MockFirebaseLoginController()
        mockFirestore.mockUserProfile.friendsClique = ["0", "1"]
        mockFirestore.mockUserProfile.familyClique = ["0"]
        mockFirestore.mockUserProfile.closeFriendsClique = ["0", "1", "2", "3"]
        mockFirestore.mockUserProfile.publicClique = ["10", "12", "4"]

        //Create a real User Model Singleton with fake firestore,
        //fake firebase storage controller, and fake firebase login controller
        let ums = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        let ums2 = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        XCTAssertEqual(ums.getFriendsClique(), ums2.getFriendsClique())
        XCTAssertEqual(ums.getFriendsClique(), ["0", "1"])
    
    }
    //tests the family clique
    func testFamilyClique() {
        let mockFirestore = MockFirestoreController()
        let mockUserModel = MockUserModel()
        let mockFirebaseStorageController = MockFirebaseStorageController()
        let mockFirebaseLoginController = MockFirebaseLoginController()
        mockFirestore.mockUserProfile.friendsClique = ["0", "1"]
        mockFirestore.mockUserProfile.familyClique = ["0"]
        mockFirestore.mockUserProfile.closeFriendsClique = ["0", "1", "2", "3"]
        mockFirestore.mockUserProfile.publicClique = ["10", "12", "4"]

        //Create a real User Model Singleton with fake firestore,
        //fake firebase storage controller, and fake firebase login controller
        let ums = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        let ums2 = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        XCTAssertEqual(ums.getFamilyClique(), ums2.getFamilyClique())
        XCTAssertEqual(["0"], ums2.getFamilyClique())
        
    }
    //tests the close friends clique
    func testCloseFriendsClique() {
        UserModelSingleton.GetInstance().tearDown()
        let mockFirestore = MockFirestoreController()
        let mockUserModel = MockUserModel()
        let mockFirebaseStorageController = MockFirebaseStorageController()
        let mockFirebaseLoginController = MockFirebaseLoginController()
        mockFirestore.mockUserProfile.friendsClique = ["0", "1"]
        mockFirestore.mockUserProfile.familyClique = ["0"]
        mockFirestore.mockUserProfile.closeFriendsClique = ["0", "1", "2", "3"]
        mockFirestore.mockUserProfile.publicClique = ["10", "12", "4"]
        
        //Create a real User Model Singleton with fake firestore,
        //fake firebase storage controller, and fake firebase login controller
        let ums = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        let ums2 = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        XCTAssertEqual(ums.getCloseFriendsClique(), ums2.getCloseFriendsClique())
        XCTAssertEqual(["0", "1", "2", "3"], ums2.getCloseFriendsClique())
        
    }
   
    
    //General test to see if the instances are the same
    func testGeneral() {
        let x = 0
        let y = 1
        XCTAssertNotEqual(x, y)
        XCTAssertEqual(UserModelSingleton.GetInstance().getLastName(), UserModelSingleton.GetInstance().getLastName())
    }
   
    //Tests the public clique
    func testPublicClique() {
        let mockFirestore = MockFirestoreController()
        let mockUserModel = MockUserModel()
        let mockFirebaseStorageController = MockFirebaseStorageController()
        let mockFirebaseLoginController = MockFirebaseLoginController()
        mockFirestore.mockUserProfile.friendsClique = ["0", "1"]
        mockFirestore.mockUserProfile.familyClique = ["0"]
        mockFirestore.mockUserProfile.closeFriendsClique = ["0", "1", "2", "3"]
        mockFirestore.mockUserProfile.publicClique = ["10", "12", "4"]

        //Create a real User Model Singleton with fake firestore,
        //fake firebase storage controller, and fake firebase login controller
        let ums = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        let ums2 = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        XCTAssertEqual(ums.getPublicClique(), ums2.getPublicClique())
        XCTAssertEqual( ["10", "12", "4"], ums2.getPublicClique())
    
    }
    
    //Test logging in with phone number(false)
    func testLoginWithPhoneFalse(){
        let mockFirestore = MockFirestoreController()
        let mockUserModel = MockUserModel()
        let mockFirebaseStorageController = MockFirebaseStorageController()
        let mockFirebaseLoginController = MockFirebaseLoginController()
        mockFirestore.mockUserProfile.friendsClique = ["0", "1"]
        mockFirestore.mockUserProfile.familyClique = ["0"]
        mockFirestore.mockUserProfile.closeFriendsClique = ["0", "1", "2", "3"]
        mockFirestore.mockUserProfile.publicClique = ["10", "12", "4"]
        //Create a real User Model Singleton with fake firestore,
        //fake firebase storage controller, and fake firebase login controller
        let ums = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        let ums2 = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
       
        mockFirebaseLoginController.verificationRequestErrorResp = NSError.init()
        
        ums.RequestLoginWithPhoneNumber(phoneNumber: ""){ success in
            XCTAssertFalse(success)
        }
    }
    
    
    //Tests login with phone number true
    func testLoginWithPhoneTrue(){
        let mockFirestore = MockFirestoreController()
        let mockUserModel = MockUserModel()
        let mockFirebaseStorageController = MockFirebaseStorageController()
        let mockFirebaseLoginController = MockFirebaseLoginController()
        mockFirestore.mockUserProfile.friendsClique = ["0", "1"]
        mockFirestore.mockUserProfile.familyClique = ["0"]
        mockFirestore.mockUserProfile.closeFriendsClique = ["0", "1", "2", "3"]
        mockFirestore.mockUserProfile.publicClique = ["10", "12", "4"]
        //Create a real User Model Singleton with fake firestore,
        //fake firebase storage controller, and fake firebase login controller
        let ums = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        let ums2 = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        
        ums.RequestLoginWithPhoneNumber(phoneNumber: ""){ success in
            XCTAssertTrue(success)
        }
    }
    
    
    //Tests login verification false
    func testLoginWithCodeFalse(){
        
        let mockFirestore = MockFirestoreController()
        let mockUserModel = MockUserModel()
        let mockFirebaseStorageController = MockFirebaseStorageController()
        let mockFirebaseLoginController = MockFirebaseLoginController()
        mockFirestore.mockUserProfile.friendsClique = ["0", "1"]
        mockFirestore.mockUserProfile.familyClique = ["0"]
        mockFirestore.mockUserProfile.closeFriendsClique = ["0", "1", "2", "3"]
        mockFirestore.mockUserProfile.publicClique = ["10", "12", "4"]
        //Create a real User Model Singleton with fake firestore,
        //fake firebase storage controller, and fake firebase login controller
        let ums = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        let ums2 = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        
        mockFirebaseLoginController.verificationRequestErrorResp = NSError.init()
        
        ums.LoginWithVerificationCode(verificationCode: "")
        { (success, profileExists) in
            XCTAssertFalse(success)
        }
    }
    
    //Tests login verification true
    func testLoginWithCodeTrue(){
        UserModelSingleton.GetInstance().tearDown()
        
        let mockFirestore = MockFirestoreController()
        let mockUserModel = MockUserModel()
        let mockFirebaseStorageController = MockFirebaseStorageController()
        let mockFirebaseLoginController = MockFirebaseLoginController()
        mockFirestore.mockUserProfile.friendsClique = ["0", "1"]
        mockFirestore.mockUserProfile.familyClique = ["0"]
        mockFirestore.mockUserProfile.closeFriendsClique = ["0", "1", "2", "3"]
        mockFirestore.mockUserProfile.publicClique = ["10", "12", "4"]
        //Create a real User Model Singleton with fake firestore,
        //fake firebase storage controller, and fake firebase login controller
        let ums = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        let ums2 = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        
        
        ums.LoginWithVerificationCode(verificationCode: "")
        { (success, profileExists) in
            XCTAssertFalse(success)
        }
    }
    
    func testEditConnections(){
        let mockFirestore = MockFirestoreController()
        let mockUserModel = MockUserModel()
        let mockFirebaseStorageController = MockFirebaseStorageController()
        let mockFirebaseLoginController = MockFirebaseLoginController()
        mockFirestore.mockUserProfile.friendsClique = ["0", "1"]
        mockFirestore.mockUserProfile.familyClique = ["0"]
        mockFirestore.mockUserProfile.closeFriendsClique = ["0", "1", "2", "3"]
        mockFirestore.mockUserProfile.publicClique = ["10", "12", "4"]
        //Create a real User Model Singleton with fake firestore,
        //fake firebase storage controller, and fake firebase login controller
        let ums = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        let ums2 = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        
        //ums.editConnection(connection: <#T##Connection#>)
    
    }
    //tests the tearDown Function
    func testTearDown() {
        let mockFirestore = MockFirestoreController()
        let mockUserModel = MockUserModel()
        let mockFirebaseStorageController = MockFirebaseStorageController()
        let mockFirebaseLoginController = MockFirebaseLoginController()
        
        let ums = UserModelSingleton.GetInstance(firestoreController: mockFirestore, firebaseStorageController: mockFirebaseStorageController, firebaseLoginController: mockFirebaseLoginController)
        ums.tearDown()
        //XCTAssertEqual(nil, ums.uniqueInstance)
    }
    
    
    
}
