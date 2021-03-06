//
//  OverviewTabBarController.swift
//  Cliques
//
//  Created by Ethan Kusters on 5/11/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import UIKit

class OverviewTabBarController: UITabBarController {
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
}
