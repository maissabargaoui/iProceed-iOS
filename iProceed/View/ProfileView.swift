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
    var user : User?
    
    // iboutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
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
        
        editProfileButton.isHidden = true
        logoutButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        checkUserAndInitialize()
    }
    
    // methods
    func popoverDismissed() {
        checkUserAndInitialize()
    }
    
    func checkUserAndInitialize() {
        if user != nil {
            initializeProfile(user: user!)
        } else {
            if (UserDefaults.standard.string(forKey: "userId") != nil) {
                if (UserDefaults.standard.string(forKey: "userId")! != "") {
                    
                    UserViewModel().getUserFromToken(completed: { [self] success, userFromRep in
                        if success {
                            
                            editProfileButton.isHidden = false
                            logoutButton.isHidden = false
                            
                            initializeProfile(user: userFromRep!)
                            
                        } else {
                            self.present(Alert.makeAlert(titre: "Error", message: "Could not verify token"), animated: true
                            )
                        }
                    })
                }
            }
        }
    }
    
    func initializeProfile(user: User) {
        print("initializing profile")
        
        qrCodeImage.image = generateQRCode(from: "iProceedCustomUrl://idUser=" + user._id!
        )
        
        if user.name != "" {
            nameLabel.text = user.name
        }
        
        if user.role != "" {
            roleLabel.text = user.role
        }
        
        if user.email != "" {
            emailLabel.text = user.email
        }
        
        if user.phone != "" {
            phoneLabel.text = user.phone
        }
        
        
    }
    
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
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
            UserViewModel().getUserFromToken(completed: { success, user in
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
