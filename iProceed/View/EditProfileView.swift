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
    @IBOutlet weak var locationTopLabel: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var changeMyLocation: UIButton!
    @IBOutlet weak var clearMyLocationButton: UIButton!
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
        
        locationTopLabel.isHidden = true
        pricePerCourseLabel.isHidden = true
        pricePerCourseTF.isHidden = true
        professorTypeTF.isHidden = true
        professorTypeLabel.isHidden = true
        secondaryConfirmButton.isHidden = true
        
        initialize(onlyLocation: false)
    }
    
    func popoverDismissed() {
        reloadView(onlyLocation: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ModalTransitionMediator.instance.sendPopoverDismissed(modelChanged: true)
    }
    
    // methods
    func initialize(onlyLocation: Bool) {
        if (!onlyLocation){
            emailTF.text = user?.email
            nameTF.text = user?.name
            phoneTF.text = user?.phone
        }
        
        emailTF.textColor = .white
        emailTF.backgroundColor = .gray
        emailTF.isEnabled = false
        
        if user?.role == "Instructor" {
            locationLabel.isHidden = false
            pricePerCourseLabel.isHidden = false
            pricePerCourseTF.isHidden = false
            professorTypeTF.isHidden = false
            professorTypeLabel.isHidden = false
            pricePerCourseTF.text = String(user!.prixParCour!)
            professorTypeTF.text = user?.typeInstructeur
            
            if user?.longitude == "" || user?.latitude == "" {
                locationLabel.isHidden = true
                addLocationButton.isHidden = false
                changeMyLocation.isHidden = true
                clearMyLocationButton.isHidden = true
            } else {
                locationLabel.isHidden = false
                addLocationButton.isHidden = true
                changeMyLocation.isHidden = false
                clearMyLocationButton.isHidden = false
                
                locationLabel.text = (user?.latitude)! + ", " + (user?.longitude)!
            }
        } else {
            locationLabel.isHidden = true
            locationTopLabel.isHidden = true
            addLocationButton.isHidden = true
            changeMyLocation.isHidden = true
            clearMyLocationButton.isHidden = true
            addLocationButton.isHidden = true
            confirmButton.isHidden = true
            secondaryConfirmButton.isHidden = false
        }
    }
    
    func reloadView(onlyLocation: Bool) {
        UserViewModel().getUserFromToken() { success, user in
            if success {
                self.user = user
                self.initialize(onlyLocation: true)
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
    
    @IBAction func clearMyLocation(_ sender: Any) {
        UserViewModel().setLocation(email: (user?.email)!, latitude: 0, longitude: 0, clear: true) { success in
            if success {
                self.present(Alert.makeActionAlert(titre: "Warning", message: "Would you really like to clear location data ?", action: UIAlertAction(title: "Yes", style: .destructive, handler: { uiAction in
                    self.reloadView(onlyLocation: true)
                })),animated: true)
            }
        }
    }
}
