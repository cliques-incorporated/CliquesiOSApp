//
//  NewPostViewController.swift
//  Cliques
//
//  Created by Ethan Kusters on 5/12/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var PhotoView: UIImageView!
    @IBOutlet weak var CaptionTextView: UITextView!
    private let imageRequestController = ImageRequestController()
    private var captionTextViewDelegate: PlaceholderTextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captionTextViewDelegate = PlaceholderTextView(textView: CaptionTextView, placeholderText: "Write a caption...")
        CaptionTextView.delegate = captionTextViewDelegate
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
    }

    @IBAction func PhotoTapped(_ sender: Any) {
        imageRequestController.requestImage(viewController: self, imageSelected: imageSelected)
    }
    
    private func imageSelected(image: UIImage?) {
        guard let image = image else { return }
        PhotoView.image = image
    }
    
    
    @IBAction func CancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func SwipedDownOnCaption(_ sender: Any) {
        view.endEditing(true)
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
