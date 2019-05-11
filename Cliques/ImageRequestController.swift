//
//  ImageRequestController.swift
//  Cliques
//
//  Created by Ethan Kusters on 5/11/19.
//  Copyright © 2019 Ethan Kusters. All rights reserved.
//

import UIKit
import Photos

class ImageRequestController: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let imageRequestOptionMenu = UIAlertController(title: nil, message: "Select Photo", preferredStyle: .actionSheet)
    private var presentingViewController: UIViewController?
    private let imagePicker = UIImagePickerController()
    private var imageSelected: ((UIImage?)->())?
    
    override init() {
        super.init()
        imageRequestOptionMenu.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: takePhoto))
        imageRequestOptionMenu.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: choosePhoto))
        imageRequestOptionMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    func requestImage(viewController: UIViewController, imageSelected: @escaping (UIImage?)->()) {
        presentingViewController = viewController
        self.imageSelected = imageSelected
        presentingViewController?.present(imageRequestOptionMenu, animated: true, completion: nil)
    }
    
    private func takePhoto(action: UIAlertAction) {
        self.imagePicker.sourceType = .camera
        self.presentingViewController?.present(self.imagePicker, animated: true, completion: nil)
    }
    
    private func choosePhoto(action: UIAlertAction) {
        self.imagePicker.sourceType = .photoLibrary
        self.presentingViewController?.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        imageSelected?(info[.editedImage] as? UIImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        imageSelected?(nil)
    }
}
