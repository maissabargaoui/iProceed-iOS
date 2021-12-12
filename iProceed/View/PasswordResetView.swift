//
//  PasswordResetView.swift
//  iProceed
//
//  Created by Mac-Mini_2021 on 27/11/2021.
//

import Foundation
import UIKit

class PasswordResetView: UIViewController {
    
    // variables
    var email: String?
    let spinner = SpinnerViewController()
    
    // iboutlets
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordConfirmationTF: UITextField!
    
    // protocols
    
    // life cycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! SignInView
        destination.email = self.email
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // methods
    func startSpinner() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    func stopSpinner() {
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
    
    // actions
    @IBAction func finalise(_ sender: Any) {
        
        if (passwordTF.text!.isEmpty) {
            self.present(Alert.makeAlert(titre: "Warning", message: "You have to type a new password"), animated: true)
            return
        }
        
        if (passwordConfirmationTF.text!.isEmpty) {
            self.present(Alert.makeAlert(titre: "Warning", message: "You have to type the new password confirmation"), animated: true)
            return
        }
        
        if (passwordTF.text != passwordConfirmationTF.text) {
            self.present(Alert.makeAlert(titre: "Warning", message: "Password and confirmation don't match"), animated: true)
            return
        }
        
        startSpinner()
        
        UserViewModel().editPassword(email: email!, newPassword: passwordTF.text!, completed: { success in
            self.stopSpinner()
            if success {
                let action = UIAlertAction(title: "Back to SignIn", style: .default) { UIAlertAction in
                    self.performSegue(withIdentifier: "backToSignInSegue", sender: nil)
                }
                self.present(Alert.makeSingleActionAlert(titre: "Success", message: "Your password has been set", action: action), animated: true)
            }else{
                self.present(Alert.makeAlert(titre: "Error", message: "Could not change password"), animated: true)
            }
        })
    }
}
