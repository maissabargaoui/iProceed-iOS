//
//  RoleView.swift
//  iProceed
//
//  Created by Mac-Mini_2021 on 25/11/2021.
//

import UIKit

class RoleView: UIViewController {
    
    // variables
    var user: User?
    
    // iboutlets
    @IBOutlet weak var chooseRoleLabel: UILabel!
    
    // protocols
    
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseRoleLabel.text = "Welcome " + user!.name! + ", Please choose your role"
    }
    
    // methods
    func signUpAsRole(role: String){
        
        user?.role = role
        
        UserViewModel().signUp(user: user!,  completed: { (success) in
            if success {
                let action = UIAlertAction(title: "Proceed", style: .default) { UIAlertAction in
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
                self.present(Alert.makeSingleActionAlert(titre: "Notice", message: "Inscription as " + role + " successful, a confirmation email has been sent to " + self.user!.email! + ", please open it and click on the link.", action: action),animated: true)
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Registration failed, email elready registered"), animated: true)
            }
        })
    }
    
    // actions
    @IBAction func roleInstructor(_ sender: Any) {
        signUpAsRole(role: "Instructor")
    }
    
    @IBAction func roleStudent(_ sender: Any) {
        signUpAsRole(role: "Student")
    }
    
}
