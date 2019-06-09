//
//  FeedItemViewTableViewCell.swift
//  Cliques
//
//  Created by Ethan Kusters on 6/8/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import UIKit

class FeedItemTableViewCell: UITableViewCell {
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
