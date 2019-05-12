//
//  OverviewTabBarController.swift
//  Cliques
//
//  Created by Ethan Kusters on 5/11/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import UIKit

class OverviewTabBarController: UITabBarController {
    @IBOutlet var MenuBarLongPressedRecognizer: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.viewControllers?.forEach { let _ = $0.view }
    }
    
    @IBAction func TabBarLongPressed(_ sender: Any) {
        guard let profileViewController = self.selectedViewController as? ProfileViewController else { return }
        profileViewController.displayEditProfileMenu(gestureRecognizer: MenuBarLongPressedRecognizer)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
