//
//  ConnectionsTableViewController.swift
//  Cliques
//
//  Created by Brian Phan on 6/1/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import UIKit
import FirebaseUI

class ConnectionsViewController: UITableViewController, UISearchResultsUpdating{
    @IBOutlet var UserConnectionTableView: UITableView!
    var searchController = UISearchController()
    private var userModel: UserModelSingleton!
    private var filteredConnections = [Connection]()
    private var selectedConnection: Connection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userModel = UserModelSingleton.GetInstance()
        
        searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            tableView.tableHeaderView = controller.searchBar
            
            return controller
            
        })()
        
        
        userModel.updateConnections(completion: connectionsUpdated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userModel.updateConnections(completion: connectionsUpdated)
        super.viewWillAppear(animated)
    }
    
    private func connectionsUpdated(success: Bool) {
        guard success else { return }
        UserConnectionTableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return filteredConnections.count
        } else {
            return userModel.getConnections().count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserConnectionCell", for: indexPath) as? ConnectionTableViewCell else {
            fatalError("The dequeued cell is not an instance of UserConnectionCell.")
        }

        var currentConnection: Connection
        if(searchController.isActive){
            currentConnection = filteredConnections[indexPath.row]
        } else {
            currentConnection = userModel.getConnections()[indexPath.row]
        }
        
        cell.name.text = (currentConnection.profile.first ?? "") + " " + (currentConnection.profile.last ?? "")
        cell.profileImage.sd_setImage(with: currentConnection.profileImage)
        
        if let clique = currentConnection.clique {
            cell.name.textColor = CliqueUtility.GetCliqueColor(clique: clique)
        } else {
            cell.name.textColor = .black
        }
        
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredConnections = userModel.getPossibleConnections()
        
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredConnections = userModel.getPossibleConnections().filter{($0.profile.first ?? "").contains(searchText)}
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(searchController.isActive){
            selectedConnection = filteredConnections[indexPath.row]
        } else {
            selectedConnection = userModel.getConnections()[indexPath.row]
        }
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "GoToConnection", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let connectionViewController = segue.destination.children.first as? ConnectionViewController, let connection = selectedConnection {
            connectionViewController.setCurrentConnection(connection: connection)
        }
    }
}
