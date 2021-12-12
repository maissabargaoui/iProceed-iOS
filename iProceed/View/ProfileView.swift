//
//  ProfileView.swift
//  iProceed
//
//  Created by Mac-Mini_2021 on 28/11/2021.
//

import Foundation
import UIKit
import FBSDKLoginKit

class ProfileView: UIViewController, ModalTransitionListener {

    // variables
    let token = UserDefaults.standard.string(forKey: "userToken")!
    var user : User?
    
    // iboutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    // life cycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfileSegue" {
            /*let controller = segue.destinationViewController as! ResultViewController
            controller.match = self.match*/
            
            let destination = segue.destination as! EditProfileView
            destination.user = user
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ModalTransitionMediator.instance.setListener(listener: self)
        initializeProfile()
    }

    // methods
    func popoverDismissed() {
        initializeProfile()
    }
    
    func initializeProfile() {
        print("initializing profile")
        UserViewModel().getUserFromToken(userToken: token, completed: { success, user in
            if success {
                if user?.name != "" {
                    self.nameLabel.text = user?.name
                }
                
                if user?.role != "" {
                    self.roleLabel.text = user?.role
                }
                
                if user?.email != "" {
                    self.emailLabel.text = user?.email
                }
                
                if user?.phone != "" {
                    self.phoneLabel.text = user?.phone
                }
                
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not verify token"), animated: true
                )
            }
        })
    }
    
    // actions
    @IBAction func logout(_ sender: Any) {
        print("logging out")
        
        let loginManager = LoginManager()
        loginManager.logOut()
        
        UserDefaults.standard.set(nil, forKey: "userToken")
        self.performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    
    @IBAction func editProfil(_ sender: Any) {
        
        if ((UserDefaults.standard.string(forKey: "userToken")) != nil){
            UserViewModel().getUserFromToken(userToken: token, completed: { success, user in
                self.user = user
                if success {
                    self.performSegue(withIdentifier: "editProfileSegue", sender: user)
                } else {
                    self.present(Alert.makeAlert(titre: "Error", message: "Could not verify token"), animated: true
                    )
                }
            })
        }
    }
}
