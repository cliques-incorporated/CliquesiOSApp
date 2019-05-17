//
//  PlaceholderTextView.swift
//  Cliques
//
//  Created by Ethan Kusters on 5/13/19. Modifed from https://github.com/cmoulton/UITextFieldPlaceholderDemo/blob/master/UITextFieldPlaceholderDemo/ViewController.swift
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import UIKit

class PlaceholderTextView: NSObject, UITextViewDelegate {
    private let textView: UITextView
    private let placeholderText: String
    init(textView: UITextView, placeholderText: String) {
        self.textView = textView
        self.placeholderText = placeholderText
        super.init()
        applyPlaceholderStyle(textView: textView)
        moveCursorToStart(textView: textView)
    }
    
    func applyPlaceholderStyle(textView: UITextView) {
        // make it look (initially) like a placeholder
        textView.textColor = UIColor.lightGray
        textView.text = placeholderText
        textView.layer.cornerRadius = 5.0
    }
    
    func applyNonPlaceholderStyle(textView: UITextView) {
        // make it look like normal text instead of a placeholder
        textView.textColor = UIColor.darkText
        textView.alpha = 1.0
    }
    
    func moveCursorToStart(textView: UITextView) {
        DispatchQueue.main.async {
            textView.selectedRange = NSMakeRange(0, 0);
        }
    }
    
    // MARK: UITextViewDelegate
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if (textView.text == placeholderText) {
            // move cursor to start
            moveCursorToStart(textView: textView)
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // remove the placeholder text when they start typing
        // first, see if the field is empty
        // if it's not empty, then the text should be black and not italic
        // BUT, we also need to remove the placeholder text if that's the only text
        // if it is empty, then the text should be the placeholder
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        if newLength > 0 { // have text, so don't show the placeholder
            // check if the only text is the placeholder and remove it if needed
            // unless they've hit the delete button with the placeholder displayed
            if (textView.text == placeholderText) {
                if (text.utf16.count == 0) { // they hit the back button
                    return false // ignore it
                }
                
                applyNonPlaceholderStyle(textView: textView)
                textView.text = ""
            }
            
            return true
        }
        else { // no text, so show the placeholder
            applyPlaceholderStyle(textView: textView)
            moveCursorToStart(textView: textView)
            return false
        }
    }
}
