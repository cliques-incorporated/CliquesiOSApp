//
//  LoginViewController.swift
//  Cliques
//
//  Created by Ethan Kusters on 5/7/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var SendLoginCodeButton: UIButton!
    @IBOutlet weak var PhoneNumberField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    
    
    @IBAction func SendMyLoginCodePressed(_ sender: Any) {
        SendLoginCodeButton.setTitle("Hello", for: .normal);
    }
    
}
