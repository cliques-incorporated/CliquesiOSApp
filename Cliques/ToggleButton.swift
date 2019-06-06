//
//  ToggleButton.swift
//  Cliques
//
//  Created by Ethan Kusters on 5/13/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import UIKit

class ToggleButton: UIButton {
    private var onColor = UIColor.black
    private var offColor = UIColor.lightGray
    public var toggleState = false
    
    private let borderWidth: CGFloat = 2.0
    private let cornerRadius: CGFloat = 5.0
    private let border = CALayer()
    
    
    override func awakeFromNib() {
        border.borderColor = offColor.cgColor
        border.borderWidth = borderWidth
        border.cornerRadius = cornerRadius
        border.frame = CGRect.init(x: -1 * (borderWidth * 3), y: -1 * (borderWidth), width: self.frame.size.width + (6 * borderWidth), height: self.frame.size.height + (2 * borderWidth))
        
        self.layer.addSublayer(border)
        self.layer.masksToBounds = false
        
        onColor = self.currentTitleColor
        self.setTitleColor(offColor, for: self.state)
        self.layer.borderColor = offColor.cgColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(toggleState) {
            self.setTitleColor(offColor, for: self.state)
            self.border.borderColor = offColor.cgColor
        } else {
            self.setTitleColor(onColor, for: self.state)
            self.border.borderColor = onColor.cgColor
        }
        
        toggleState.toggle()
        super.touchesBegan(touches, with: event)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
