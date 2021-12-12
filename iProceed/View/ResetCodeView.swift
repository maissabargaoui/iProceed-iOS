//
//  ResetCodeView.swift
//  iProceed
//
//  Created by Mac-Mini_2021 on 27/11/2021.
//

import Foundation
import UIKit

class ResetCodeView: UIViewController {
    
    // variables
    var data : ForgotPasswordView.PasswordForgottenData?
    
    // iboutlets
    @IBOutlet weak var codeTextField: UITextField!
    
    // life cycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PasswordResetView
        destination.email = data?.email
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // methods
    
    // actions
    @IBAction func reset(_ sender: Any) {
        
        if (codeTextField.text!.isEmpty){
            self.present(Alert.makeAlert(titre: "Warning", message: "Please type the code"), animated: true)
            return
        }
        
        if (codeTextField.text == data?.code ) {
            performSegue(withIdentifier: "resetPasswordSegue", sender: data?.code)
        } else {
            self.present(Alert.makeAlert(titre: "Error", message: "Code incorrect"), animated: true)
        }
    }
    
}
