//
//  EditProfileView.swift
//  iProceed
//
//  Created by Mac-Mini_2021 on 28/11/2021.
//

import Foundation
import UIKit

class EditProfileView: UIViewController, SecondModalTransitionListener {
    
    // variables
    var user : User?
    
    // iboutlets
    @IBOutlet weak var secondaryConfirmButton: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var pricePerCourseLabel: UILabel!
    @IBOutlet weak var pricePerCourseTF: UITextField!
    @IBOutlet weak var professorTypeLabel: UILabel!
    @IBOutlet weak var professorTypeTF: UITextField!
    
    // protocols
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        SecondModalTransitionMediator.instance.setListener(listener: self)
        
        pricePerCourseLabel.isHidden = true
        pricePerCourseTF.isHidden = true
        professorTypeTF.isHidden = true
        professorTypeLabel.isHidden = true
        secondaryConfirmButton.isHidden = true
        
        initialize()
    }
    
    func popoverDismissed() {
        reloadView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ModalTransitionMediator.instance.sendPopoverDismissed(modelChanged: true)
    }
    
    // methods
    func initialize() {
        
        emailTF.textColor = .white
        emailTF.backgroundColor = .gray
        emailTF.isEnabled = false
        
        if user?.role == "Instructor" {
            pricePerCourseLabel.isHidden = false
            pricePerCourseTF.isHidden = false
            professorTypeTF.isHidden = false
            professorTypeLabel.isHidden = false
            pricePerCourseTF.text = String(user!.prixParCour!)
            professorTypeTF.text = user?.typeInstructeur
            
        } else {
            confirmButton.isHidden = true
            secondaryConfirmButton.isHidden = false
        }
    }
    
    func reloadView() {
        UserViewModel().getUserFromToken() { success, user in
            if success {
                self.user = user
                self.initialize()
            }
        }
    }
    
    // actions
    @IBAction func confirmChanges(_ sender: Any) {
        
        if /*emailTF.text!.isEmpty ||*/ nameTF.text!.isEmpty  || phoneTF.text!.isEmpty {
            self.present(Alert.makeAlert(titre: "Warning", message: "You must fill all the fields"), animated: true)
            return
        }
        
        //user?.email = emailTF.text
        user?.name = nameTF.text
        user?.phone = phoneTF.text
        
        if user?.role == "Instructor" {
            user?.typeInstructeur = professorTypeTF.text
        } else {
            user?.typeInstructeur = ""
        }
        
        UserViewModel().editProfile(user: user!) { success in
            if success {
                let action = UIAlertAction(title: "Proceed", style: .default) { UIAlertAction in
                    self.navigationController?.popViewController(animated: true)
                }
                self.present(Alert.makeSingleActionAlert(titre: "Success", message: "Profile edited successfully", action: action), animated: true)
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not edit your profile"), animated: true)
            }
        }
    }
    
}
