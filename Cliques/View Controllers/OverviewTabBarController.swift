//
//  OverviewTabBarController.swift
//  Cliques
//
//  Created by Ethan Kusters on 5/11/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import UIKit

class OverviewTabBarController: UITabBarController {
    private var userModel: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Force all tabs to preload
        self.viewControllers?.forEach {
            let _ = $0.view
            let _ = $0.children.forEach {
                let _ = $0.view
            }
        }
    }
    
    public func getUserModel() -> UserModel {
        guard let userModel = userModel else {
            self.userModel = UserModel()
            return self.userModel!
        }
        
        return userModel
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
