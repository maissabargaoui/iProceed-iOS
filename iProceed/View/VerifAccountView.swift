//
//  LaunchScreenView.swift
//  iProceed
//
//  Created by Mac-Mini_2021 on 28/11/2021.
//

import Foundation
import UIKit
import FBSDKLoginKit

class VerifAccountView: UIViewController {
    
    // variables
    var user : User?
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let spinner = SpinnerViewController()
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let loginManager = LoginManager()
        loginManager.logOut()
        
        checkUser()
    }
    
    func checkUser(){
        
        let token = UserDefaults.standard.string(forKey: "userToken")
        
        if token != nil {
            UserViewModel().getUserFromToken() { success, user in
                if success {
                    if (user!.role == "Student") {
                        self.performSegue(withIdentifier: "loginAsStudentSegue", sender: nil)
                    } else if (user!.role == "Instructor") {
                        self.performSegue(withIdentifier: "logInAsInstructorSegue", sender: nil)
                    }
                } else {
                    self.performSegue(withIdentifier: "notLoggedInSegue", sender: nil)
                }
            }
        } else {
            self.performSegue(withIdentifier: "notLoggedInSegue", sender: nil)
        }
    }
}
