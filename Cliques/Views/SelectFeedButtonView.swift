//
//  SelectFeedButtonView.swift
//  Cliques
//
//  Created by Ethan Kusters on 6/7/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import UIKit

class SelectFeedButtonView: UIButton {
    @IBOutlet weak var ViewController: UIViewController!
    private let selectCliqueMenu = UIAlertController(title: nil, message: "Current Clique:", preferredStyle: .actionSheet)
    private var currentClique = CliqueUtility.CliqueTitles.Friends
    
    public var FeedSelectionChanged: ((_ selectedClique: CliqueUtility.CliqueTitles) -> ())?
    
    override func awakeFromNib() {

        selectCliqueMenu.addAction(UIAlertAction(title: "Public", style: .default, handler: selectPublicClique))
        selectCliqueMenu.addAction(UIAlertAction(title: "Friends", style: .default, handler: selectFriendsClique))
        selectCliqueMenu.addAction(UIAlertAction(title: "Family", style: .default, handler: selectFamilyClique))
        selectCliqueMenu.addAction(UIAlertAction(title: "Close Friends", style: .default, handler: selectCloseFriendsClique))
        selectCliqueMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ViewController.present(selectCliqueMenu, animated: true, completion: nil)
        super.touchesBegan(touches, with: event)
    }
    
    public func getSelectedClique() -> CliqueUtility.CliqueTitles {
        return currentClique
    }
    
    private func selectPublicClique(action: UIAlertAction) {
        currentClique = .Public
        updateSelectedClique()
    }
    
    private func selectFriendsClique(action: UIAlertAction) {
        currentClique = .Friends
        updateSelectedClique()
    }
    
    private func selectCloseFriendsClique(action: UIAlertAction) {
        currentClique = .CloseFriends
        updateSelectedClique()
    }
    
    private func selectFamilyClique(action: UIAlertAction) {
        currentClique = .Family
        updateSelectedClique()
    }
    
    private func updateSelectedClique() {
        FeedSelectionChanged?(currentClique)
        setTitle("  " + currentClique.rawValue + " ⌄", for: state)
        setTitleColor(CliqueUtility.GetCliqueColor(clique: currentClique), for: state)
    }

}
