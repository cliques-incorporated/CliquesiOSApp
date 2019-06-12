//
//  ConnectionViewController.swift
//  Cliques
//
//  Created by Ethan Kusters on 6/11/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import UIKit
import FirebaseUI

class ConnectionViewController: UIViewController {
    @IBOutlet weak var ProfileImage: CircularProfileImageView!
    @IBOutlet weak var ProfileNameLabel: UILabel!
    @IBOutlet weak var ProfileBioLabel: UILabel!
    @IBOutlet weak var PublicCliqueToggle: ToggleButtonView!
    @IBOutlet weak var FriendsCliqueToggle: ToggleButtonView!
    @IBOutlet weak var FamilyCliqueToggle: ToggleButtonView!
    @IBOutlet weak var CloseFriendsCliqueToggle: ToggleButtonView!
    private var userModel: UserModelSingleton!
    private var currentConnection: Connection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userModel = UserModelSingleton.GetInstance()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let connection = currentConnection {
            ProfileImage.sd_setImage(with: connection.profileImage)
            ProfileNameLabel.text = (connection.profile.first ?? "") + " " + (connection.profile.last ?? "")
            ProfileBioLabel.text = connection.profile.bio ?? ""
            
            if let clique = connection.clique {
                switch clique {
                case .CloseFriends:
                    CloseFriendsCliqueToggle.setToggleState(state: true)
                case .Public:
                    PublicCliqueToggle.setToggleState(state: true)
                case .Family:
                    FamilyCliqueToggle.setToggleState(state: true)
                case .Friends:
                    FriendsCliqueToggle.setToggleState(state: true)
                }
            }
        }
        
        super.viewWillAppear(animated)
    }
    
    
    
    public func setCurrentConnection(connection: Connection) {
        currentConnection = connection
    }
    
    @IBAction func PublicCliqueToggled(_ sender: Any) {
        FriendsCliqueToggle.setToggleState(state: false)
        FamilyCliqueToggle.setToggleState(state: false)
        CloseFriendsCliqueToggle.setToggleState(state: false)
    }
    
    @IBAction func FriendsCliqueToggled(_ sender: Any) {
        PublicCliqueToggle.setToggleState(state: false)
        FamilyCliqueToggle.setToggleState(state: false)
        CloseFriendsCliqueToggle.setToggleState(state: false)
    }
    
    @IBAction func FamilyCliqueToggled(_ sender: Any) {
        FriendsCliqueToggle.setToggleState(state: false)
        PublicCliqueToggle.setToggleState(state: false)
        CloseFriendsCliqueToggle.setToggleState(state: false)
    }
    
    @IBAction func CloseFriendsCliqueToggled(_ sender: Any) {
        FriendsCliqueToggle.setToggleState(state: false)
        FamilyCliqueToggle.setToggleState(state: false)
        PublicCliqueToggle.setToggleState(state: false)
    }
    
    
    @IBAction func DonePressed(_ sender: Any) {
        
        guard var connection = currentConnection else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        var changeMade = false
        if let clique = connection.clique {
            switch clique {
            case .CloseFriends:
                changeMade = !CloseFriendsCliqueToggle.toggleState
            case .Public:
                changeMade = !PublicCliqueToggle.toggleState
            case .Family:
                changeMade = !FamilyCliqueToggle.toggleState
            case .Friends:
                changeMade = !FriendsCliqueToggle.toggleState
            }
        } else {
            changeMade = CloseFriendsCliqueToggle.toggleState || PublicCliqueToggle.toggleState || FamilyCliqueToggle.toggleState || FriendsCliqueToggle.toggleState
        }
        
        if changeMade {
            connection.clique = nil
            if CloseFriendsCliqueToggle.toggleState {
                connection.clique = .CloseFriends
            } else if PublicCliqueToggle.toggleState {
                connection.clique = .Public
            } else if FamilyCliqueToggle.toggleState {
                connection.clique = .Family
            } else if FriendsCliqueToggle.toggleState {
                connection.clique = .Friends
            }
            
            userModel.editConnection(connection: connection)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
