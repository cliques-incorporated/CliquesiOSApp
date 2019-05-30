//
//  AddConnectionSearchViewController.swift
//  Cliques
//
//  Created by Ethan Kusters on 5/17/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import UIKit

class AddConnectionSearchViewController: UIViewController, UISearchResultsUpdating {

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.definesPresentationContext = true
        // Do any additional setup after loading the view.
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        view.isHidden = false
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
