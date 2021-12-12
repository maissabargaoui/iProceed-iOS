//
//  RegisterView.swift
//  iProceed
//
//  Created by Mac-Mini_2021 on 25/11/2021.
//

import UIKit

class RegisterView: UIViewController {
    
    // variables
    let spinner = SpinnerViewController()
    
    // iboutlets
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordConfirmationTF: UITextField!
    
    // protocols
    
    // life cycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! RoleView
        destination.user = sender as? User
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
    @IBAction func register(_ sender: Any) {
        
        if (usernameTF.text!.isEmpty || emailTF.text!.isEmpty || addressTF.text!.isEmpty || phoneTF.text!.isEmpty || passwordTF.text!.isEmpty || passwordConfirmationTF.text!.isEmpty){
            self.present(Alert.makeAlert(titre: "Warning", message: "You must to fill all the fields"), animated: true)
            return
        }
        
        if (emailTF.text?.contains("@") == false){
            self.present(Alert.makeAlert(titre: "Warning", message: "Please type your email correctly"), animated: true)
        }
        
        if (passwordTF.text!.count < 8 ){
            self.present(Alert.makeAlert(titre: "Warning", message: "Password should be have at least 8 characters"), animated: true)
            return
        }
        
        if (!NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: passwordTF.text!)){
            self.present(Alert.makeAlert(titre: "Warning", message: "Password should have at least one capital letter"), animated: true)
            return
        }
        
        if (passwordTF.text != passwordConfirmationTF.text){
            self.present(Alert.makeAlert(titre: "Warning", message: "Password and confirmation don't match"), animated: true)
            return
        }
        
        let username = usernameTF.text
        let email = emailTF.text
        let address = addressTF.text
        let phone = phoneTF.text
        let password = passwordTF.text
        
        let user = User(_id: nil, name: username, email: email, address: address, password: password, phone: phone, role: nil, isVerified: false)
        
        self.performSegue(withIdentifier: "proceedInscriptionRole", sender: user)
    }
    
}
