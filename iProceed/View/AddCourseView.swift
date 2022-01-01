//
//  AddCourseView.swift
//  iProceed
//
//  Created by Mac-Mini_2021 on 25/11/2021.
//

import UIKit

class AddCourseView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // var
    var currentPhoto : UIImage?
    
    // iboutlet
    @IBOutlet weak var titreTextView: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addPicButton: UIButton!
    @IBOutlet weak var picImageView: UIImageView!
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // actions
    @IBAction func save(_ sender: Any) {
        
        if (currentPhoto == nil){
            self.present(Alert.makeAlert(titre: "Avertissement", message: "Choisir une image"), animated: true)
            return
        }
        
        CourseViewModel().addCourse(title: titreTextView.text!, description: descriptionTextView.text, date: Date(), uiImage: currentPhoto!) { success in
            if success {
                let action = UIAlertAction(title: "Proceed", style: .default) { UIAlertAction in
                    self.navigationController?.popViewController(animated: true)
                }
                self.present(Alert.makeSingleActionAlert(titre: "Success", message: "Course added successfully", action: action), animated: true)
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not add course"), animated: true)
            }
        }
    }
    
    @IBAction func addPicture(_ sender: Any) {
        showActionSheet()
    }
    
    func camera()
    {
        let myPickerControllerCamera = UIImagePickerController()
        myPickerControllerCamera.delegate = self
        myPickerControllerCamera.sourceType = UIImagePickerController.SourceType.camera
        myPickerControllerCamera.allowsEditing = true
        self.present(myPickerControllerCamera, animated: true, completion: nil)
        
    }
    
    
    func gallery()
    {
        
        let myPickerControllerGallery = UIImagePickerController()
        myPickerControllerGallery.delegate = self
        myPickerControllerGallery.sourceType = UIImagePickerController.SourceType.photoLibrary
        myPickerControllerGallery.allowsEditing = true
        self.present(myPickerControllerGallery, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            
            return
        }
        
        currentPhoto = selectedImage
        picImageView.image = selectedImage
        addPicButton.setTitle("Change photo", for: .normal)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func showActionSheet(){
        
        let actionSheetController: UIAlertController = UIAlertController(title: NSLocalizedString("Upload Image", comment: ""), message: nil, preferredStyle: .actionSheet)
        actionSheetController.view.tintColor = UIColor.black
        let cancelActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let saveActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Take Photo", comment: ""), style: .default)
        { action -> Void in
            self.camera()
        }
        actionSheetController.addAction(saveActionButton)
        
        let deleteActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Choose From Gallery", comment: ""), style: .default)
        { action -> Void in
            self.gallery()
        }
        
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
}
