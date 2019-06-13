//
//  CircularProfileImageView.swift
//  Cliques
//
//  Created by Ethan Kusters on 5/15/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import UIKit

class CircularProfileImageView: UIImageView {
    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}
