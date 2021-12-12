//
//  ForgotPasswordView.swift
//  iProceed
//
//  Created by Mac-Mini_2021 on 27/11/2021.
//

import Foundation
import UIKit

class ForgotPasswordView: UIViewController {
    
    // variables
    struct PasswordForgottenData {
        var email: String?
        var code: String?
    }
    var data : PasswordForgottenData?
    let spinner = SpinnerViewController()
    
    // iboutlets
    @IBOutlet weak var emailTF: UITextField!
    
    // protocols
    
    // life cycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ResetCodeView
        destination.data = data
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
    @IBAction func sendAction(_ sender: Any) {
        
        if (emailTF.text!.isEmpty){
            self.present(Alert.makeAlert(titre: "Avertissement", message: "Please type your email"), animated: true)
            return
        }
        
        startSpinner()
        
        data = PasswordForgottenData(
            email: emailTF.text,
            code: String(Int.random(in: 1000..<9999))
        )
        
        UserViewModel().forgotPassword(email: (data?.email)!, resetCode: (data?.code)!
        ) { success in
            self.stopSpinner()
            if (success) {
                let action = UIAlertAction(title: "Proceed", style: .default) { promptAction in
                    self.performSegue(withIdentifier: "resetCodeSegue", sender: self.data?.code)
                }
                self.present(Alert.makeSingleActionAlert(titre: "Notice", message: "The password reset email has been sent to " + self.emailTF.text! + ", please open the link to reset your password.", action: action), animated: true)
            } else {
                self.present(Alert.makeAlert(titre: "Warning", message: "We could not find an account linked to this email"), animated: true)
            }
        }
    }
    
}
