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
    private let imageRequestUtility = ImageRequestUtility()
    private var captionTextViewDelegate: PlaceholderTextView?
    @IBOutlet weak var PublicCliqueToggle: ToggleButtonView!
    @IBOutlet weak var FriendsCliqueToggle: ToggleButtonView!
    @IBOutlet weak var FamilyCliqueToggle: ToggleButtonView!
    @IBOutlet weak var CloseFriendsCliqueToggle: ToggleButtonView!
    private var selectedImage = false
    
    private let imageAndCliqueRequired = UIAlertController(title: "We're missing something...", message: "Please select an image and at least one Clique.", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageAndCliqueRequired.addAction((UIAlertAction(title: "Got It", style: .cancel, handler: nil)))
        
        captionTextViewDelegate = PlaceholderTextView(textView: CaptionTextView, placeholderText: "Write a caption...")
        CaptionTextView.delegate = captionTextViewDelegate
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
        
        selectedImage = false
    }
    
    @IBAction func PhotoTapped(_ sender: Any) {
        imageRequestUtility.requestImage(viewController: self, imageSelected: imageSelected)
    }
    
    private func imageSelected(image: UIImage?) {
        guard let image = image else { return }
        PhotoView.image = image
        selectedImage = true
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
    
    @IBAction func PostButtonPressed(_ sender: Any) {
        guard selectedImage, let image = PhotoView.image, (PublicCliqueToggle.toggleState || FriendsCliqueToggle.toggleState || FamilyCliqueToggle.toggleState || CloseFriendsCliqueToggle.toggleState) else {
            DispatchQueue.main.async {
                self.present(self.imageAndCliqueRequired, animated: true, completion: nil)
            }
            
            return
        }
        
        let post = PostModel(image: image, caption: CaptionTextView.text, publicClique: PublicCliqueToggle.toggleState, friendsClique: FriendsCliqueToggle.toggleState,
                             closeFriendsClique: CloseFriendsCliqueToggle.toggleState, familyClique: FamilyCliqueToggle.toggleState)
        
        post.upload(completionHandler: uploadComplete)
    }
    
    private func uploadComplete(success: Bool) {
        dismiss(animated: true, completion: nil)
    }
}
