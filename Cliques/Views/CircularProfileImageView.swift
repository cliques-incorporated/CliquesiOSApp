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
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
