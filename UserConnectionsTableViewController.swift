//
//  ConnectionsTableViewController.swift
//  Cliques
//
//  Created by Brian Phan on 6/1/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseUI

class UserConnectionsTableViewController: UITableViewController, UISearchResultsUpdating{
    
    @IBOutlet var UserConnectionTableView: UITableView!
    var searchController = UISearchController()
    var userIDArray = [String]()
    var usersArray = [String:Any]()
    var userNameArray = [String]()
    var filteredusersArray = [String]()
    var connectionsArray = [String]()
    var usersCount = [String]()
    var familyClique = [String]()
    var closeFriendClique = [String]()
    var friendsClique = [String]()
    var publicClique = [String]()
    var totalClique = [String]()
    var firstName = ""
    var lastName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
        
        searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            tableView.tableHeaderView = controller.searchBar
            
            return controller
            
        })()
        self.tableView.reloadData()
        
        
        guard let currentUser = Auth.auth().currentUser else{
            return
        }
        let onlyUserRef = db.collection("users")
        let phoneNumber = currentUser.phoneNumber
        let userRef = db.collection("users").document(phoneNumber!)
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let userRefData = document.data()
                self.publicClique = userRefData?["publicClique"] as? Array ?? [""]
                self.publicClique = self.publicClique.filter({ $0 != ""})
                self.familyClique = userRefData?["familyClique"] as? Array ?? [""]
                self.familyClique = self.familyClique.filter({ $0 != ""})
                self.closeFriendClique = userRefData?["closeFriendsClique"] as? Array ?? [""]
                self.closeFriendClique = self.closeFriendClique.filter({ $0 != ""})
                self.friendsClique = userRefData?["friendsClique"] as? Array ?? [""]
                self.friendsClique = self.friendsClique.filter({ $0 != ""})
                self.totalClique = self.publicClique + self.familyClique + self.closeFriendClique +
                    self.friendsClique
                self.totalClique = self.totalClique.filter({ $0 != ""})
                self.tableView.reloadData()
            } else {
                print("Document does not exist")
            }
        }
       
        onlyUserRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    self.userIDArray.append(document.documentID)
                    let docData = document.data()
                    self.firstName = docData["first"] as! String
                    self.lastName = docData["last"] as! String
                    let fullName = self.firstName + " " + self.lastName
                    self.userNameArray.append(fullName)
                }
            
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        /*if searchController.isActive && searchController.searchBar.text != ""{return filteredusersArray.count
         }*/
        //print("break")
        //print(self.usersCount.count)
        if(searchController.isActive){
            return self.filteredusersArray.count
        }
        return self.totalClique.count
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath)
        //let user = usersCount[indexPath.row] as! String
        //let user = usersArray?["connections"] as! String
        if(searchController.isActive){
            cell.textLabel?.text = self.filteredusersArray[indexPath.row]
            return cell
        }
        else{
            cell.textLabel?.text = self.totalClique[indexPath.row]
            print(self.totalClique)
            if(indexPath.row < self.publicClique.count){
                print(self.publicClique.count)
            cell.detailTextLabel?.text = "Public"
            }
            else if(indexPath.row < self.familyClique.count){
                print(self.familyClique.count)
                cell.detailTextLabel?.text = "Family"
            }
            else if(indexPath.row < self.closeFriendClique.count){
                cell.detailTextLabel?.text = "Close Friend"
            }
            else if(indexPath.row < self.friendsClique.count){
                cell.detailTextLabel?.text = "Friend"
            }
            return cell
        }
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filteredusersArray.removeAll(keepingCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (userNameArray as NSArray).filtered(using: searchPredicate)
        self.filteredusersArray = array as! [String]
        
        self.tableView.reloadData()
    }
}
