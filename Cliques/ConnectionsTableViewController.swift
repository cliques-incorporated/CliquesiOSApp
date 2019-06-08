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

class ConnectionsTableViewController: UITableViewController, UISearchResultsUpdating{

    
    @IBOutlet var ConnectionsTableView: UITableView!
    var searchController = UISearchController()
    var userIDArray = [String]()
    var usersArray = [String:Any]()
    var filteredusersArray = [String]()
    var usersCount = [String]()
    var firestoreController: FirestoreController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
        
        /*searchController.searchResultsUpdater = self
           //doesn't dim while user is searching
        definesPresentationContext = true
        */
        searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            tableView.tableHeaderView = controller.searchBar

            return controller
            
        })()
        self.tableView.reloadData()
        //tableView.tableHeaderView = searchController.searchBar
        
        firestoreController = FirestoreController()
        
        guard let currentUser = Auth.auth().currentUser else{
            return
        }
        let onlyUserRef = db.collection("users")
        let phoneNumber = currentUser.phoneNumber
        let userRef = db.collection("users").document(phoneNumber!)
        
        userRef.setData(["connections": ["test"]], merge:true)
        userRef.updateData(["connections": FieldValue.arrayUnion(["Brian", "Nemo", "Frank", "Random", "Consumer", ])
            ])
        onlyUserRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
                //self.listArray = querySnapshot!.documents.flatMap({List(dictionary: $0.data())})
            }
        }
        let docRef = db.collection("users").document(phoneNumber!)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let docData = document.data()
                self.usersArray = docData!
                //print(docData)
                self.usersCount = docData!["connections"] as? Array ?? [""]
                //print(self.usersCount)
                self.tableView.reloadData()
                //print(usersArray)
                //insert the rows
                //print(usersCount.count)
                /*self.ConnectionsTableView.insertRows(at: [IndexPath(row: usersCount.count-1, section: 0)] , with: UITableView.RowAnimation.automatic)
                */
            } else {
                print("Document does not exist")
            }
        }
        

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return self.usersCount.count
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
            cell.textLabel?.text = self.usersCount[indexPath.row]
            return cell
        }
        // Configure the cell...
        //let user: NSDictionary?
        /*if searchController.isActive && searchController.searchBar.text != ""{
            user = filteredusersArray[indexPath.row]
        }
        else {
            user = self.usersArray[indexPath.row]
        }
        
        cell.textLabel?.text = user?["connections"]*/
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func updateSearchResults(for searchController: UISearchController){
        self.filteredusersArray.removeAll(keepingCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (usersCount as NSArray).filtered(using: searchPredicate)
        self.filteredusersArray = array as! [String]
        
        self.tableView.reloadData()
    }
    
    /*func filterContent(searchText: String){
        self.filteredusersArray = self.usersArray.filter{user in
            let username = user?["connections"] as! String
            return(username.lowercased().contains(searchText.lowercased()))
        }
        tableView.reloadData()
    }*/
    
}
