//
//  SignInView.swift
//  iProceed
//
//  Created by Mac-Mini_2021 on 25/11/2021.
//

import UIKit

import GoogleSignIn // GOOGLE
import FBSDKLoginKit // FACEBOOK
import AuthenticationServices // APPLE
import TwitterKit // TWITTER

class SignInView: UIViewController {
    
    // variables
    var email : String?
    let spinner = SpinnerViewController()
    let googleSignInConfig = GIDConfiguration.init(clientID: "783574463459-cuik8iialqigg9021omks6h4k7ssbf7k.apps.googleusercontent.com")
    
    let googleLoginButton = GIDSignInButton()
    let facebookLoginButton = FBLoginButton(frame: .zero, permissions: [.publicProfile,.email])
    let appleLoginButton = ASAuthorizationAppleIDButton()
    let twitterLoginButton = TWTRLogInButton(logInCompletion: { session, error in
        if (session != nil) {
            print("signed in as \(session!.userName)");
        } else {
            print("error: \(error!.localizedDescription)");
        }
    })
    
    // iboutlets
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var googleLoginProviderStackView: UIStackView! // Google login button
    @IBOutlet weak var facebookLoginProviderStackView: UIStackView! // Facebook login button
    @IBOutlet weak var appleLoginProviderStackView: UIStackView! // Apple login button
    @IBOutlet weak var twitterLoginProviderStackView: UIStackView! // Twitter login button
    @IBOutlet weak var roleSwitch: UISwitch!
    
    // protocols
    
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleLoginProviderStackView.addSubview(googleLoginButton)
        facebookLoginProviderStackView.addSubview(facebookLoginButton)
        appleLoginProviderStackView.addSubview(appleLoginButton)
        twitterLoginProviderStackView.addSubview(twitterLoginButton)
        
        googleLoginButton.addTarget(self, action: #selector(googleSignIn), for: .touchUpInside)
        facebookLoginButton.addTarget(self, action: #selector(facebookSignIn), for: .touchUpInside)
        appleLoginButton.addTarget(self, action: #selector(appleSignIn), for: .touchUpInside)
        twitterLoginButton.addTarget(self, action: #selector(twitterSignIn), for: .touchUpInside)
        
        facebookLoginButton.permissions = ["public_profile", "email"]
        
        // Observe access token changes
        // This will trigger after successfully login / logout
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: OperationQueue.main) { (notification) in
            
            // Print out access token
            print("------------ FACEBOOK TOKEN CHANGED ------------")
            print("Token : \(String(describing: AccessToken.current?.tokenString))")
            print("------------------------------------------------")
            
            self.loginWithFacebook()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        googleLoginButton.frame = CGRect(x: 0, y: 0, width: googleLoginProviderStackView.frame.width, height: googleLoginProviderStackView.frame.height)
        facebookLoginButton.frame = CGRect(x: 2.5, y: 4, width: facebookLoginProviderStackView.frame.width - 5, height: facebookLoginProviderStackView.frame.height - 10)
        appleLoginButton.frame = CGRect(x: 2.5, y: 4, width: appleLoginProviderStackView.frame.width - 5, height: appleLoginProviderStackView.frame.height - 10)
        twitterLoginButton.frame = CGRect(x: 2.5, y: 4, width: twitterLoginProviderStackView.frame.width - 5 , height: twitterLoginProviderStackView.frame.height - 10)
        
        
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
    
    func loginWithFacebook() {
        print("fb")
        _ = NSData()
        
        GraphRequest(graphPath: "me", parameters: ["fields": "first_name,last_name,  picture.width(480).height(480),email, id"]).start { [self] (connection, result, error) in
            
            if (error != nil){
                debugPrint(error!)
            }
            
            if let fields = result as? [String:Any],
               let lastname = fields["last_name"] as? String,
               let firstName = fields["first_name"] as? String,
               let email = fields["email"] as? String,
               let id = fields["id"] as? String {
                
                if let profilePictureObj = fields["picture"] as? NSDictionary{
                    
                    let data = profilePictureObj["data"] as! NSDictionary
                    let pictureUrlString  = data["url"] as! String
                    let pictureUrl = NSURL(string: pictureUrlString)
                    
                    let imageData = NSData(contentsOf: pictureUrl! as URL)
                    _ = UIImage(data: imageData! as Data)
                    
                }
                
                print("--- Facebook login infos ---")
                print(id)
                print(firstName)
                print(lastname)
                print(email)
                
                print("Logging in with facebook..")
                loginWithSocialMedia(email: email, name:  firstName + " " + lastname, socialMediaName: "Facebook")
                
                
                print("--- End Facebook login infos ---")
            }
        }
    }
    
    @objc func googleSignIn() {
        GIDSignIn.sharedInstance.signIn(with: googleSignInConfig, presenting: self) { [self] user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            
            let email = user.profile?.email
            let name = (user.profile?.givenName)! + " " + (user.profile?.familyName)!
            
            loginWithSocialMedia(email: email, name: name, socialMediaName: "Google")
            
            stopSpinner()
        }
    }
    
    @objc func facebookSignIn(_ loginButton: FBLoginButton, didCompleteWith result:
                              LoginManagerLoginResult?, error: Error?) {
       
    }
    
    @objc func appleSignIn() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    @objc func twitterSignIn() {
        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                
                let client = TWTRAPIClient.withCurrentUser()
                
                client.requestEmail { email, error in
                    if (email != nil) {
                        print("signed in as \(session!.userName)");
                        self.loginWithSocialMedia(email: email, name: session?.userName, socialMediaName: "Twitter")
                    } else {
                        print("error: \(error!.localizedDescription)");
                    }
                }
                
                print("signed in as \(session!.userName)");
            } else {
                print("error: \(error!.localizedDescription)");
            }
            self.stopSpinner()
        })
    }

    func loginWithSocialMedia(email: String?, name: String?, socialMediaName: String) {
        
        var role = ""
        //switch between roles before sign in
        
        if roleSwitch.isOn{
            role = "Instructor"
        }else{
            role = "Student"
        }
        
        
        UserViewModel().loginWithSocialApp(email: email!, name: name!, role: role, completed: { success, user in
            if success {
                self.proceedToLogin(user: user!)
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not login with " + socialMediaName), animated: true)
            }
            
            self.stopSpinner()
        })
    }
    
    func resendConfirmationEmail(email: String?) {
        UserViewModel().resendConfirmation(email: email!, completed: { (success) in
            if success {
                self.present(Alert.makeAlert(titre: "Success", message: "Confirmation email has been sent to " + email!), animated: true)
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not send verification email"), animated: true)
            }
        })
    }
    
    func proceedToLogin(user: User) {
        if (user.role == "Instructor") {
            self.performSegue(withIdentifier: "instructorLoginSegue", sender: nil)
        } else if (user.role == "Student"){
            self.performSegue(withIdentifier: "studentLoginSegue", sender: nil)
        } else {
            self.present(Alert.makeAlert(titre: "Error", message: "Invalid account"), animated: true)
        }
    }
    
    // actions
    @IBAction func login(_ sender: Any) {
        
        if(emailTF.text!.isEmpty || passwordTF.text!.isEmpty){
            self.present(Alert.makeAlert(titre: "Warning", message: "You must type your credentials"), animated: true)
            return
        }
        
        startSpinner()
        
        let email = emailTF.text!
        let password = passwordTF.text!
        
        UserViewModel().login(email: email, password: password, completed: { (success, response) in
            self.stopSpinner()
            if success {
                let user = response as! User
                
                if (user.isVerified!) {
                    self.proceedToLogin(user: user)
                } else {
                    let action = UIAlertAction(title: "Resend", style: .default) { UIAlertAction in
                        self.resendConfirmationEmail(email: email)
                    }
                    self.present(Alert.makeActionAlert(titre: "Notice", message: "The email linked to this account is not confirmed, would you like to resend the confirmation email ?", action: action), animated: true)
                }
            } else {
                self.present(Alert.makeAlert(titre: "Warning", message: "Email or password incorrect"),animated: true)
            }
        })
    }
}

extension SignInView: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("failed!")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            let firstName = credentials.fullName?.givenName
            let lastName = credentials.fullName?.familyName
            let email = credentials.email
            
            print("--- Apple login infos ---")
            print(firstName!)
            print(lastName!)
            print(email!)
            print("--- End Apple login infos ---")
            loginWithSocialMedia(email: email, name: firstName, socialMediaName: "Apple")
            break
            
        default:
            break
        }
    }
}

extension SignInView: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
