//
//  PaymentView.swift
//  iProceed
//
//  Created by Mac-Mini_2021 on 25/11/2021.
//

import UIKit
import Braintree

class PaymentView: UIViewController {
    
    
    // Seller paypal sandbox account
    // Email ID:
    // sb-mkjmc8962389@business.example.com
    // System Generated Password:
    // N!)=Fo0y
    
    // Buyer paypal sandbox account
    // Email ID:
    // sb-nd543j8980353@personal.example.com
    // System Generated Password:
    // ATPK&bX2
    
    
    // Client ID
    // AbI0i6bDsTDEkvFvM4ehGv4Jr8JRGSNyjPn2vbeLcHwArrBzOgdv7DCMI8wy0Qdwk3Yg-Mu9DIH0YNm8
    // Secret
    // EF0rMMzmsEc6YwVnDzY4oHBbSK_QEc-Wdh-UQorQ2LtzlNCXlWvzxxcsiSuDnhKH-t1HBEEX3gBzKL3v
    
    // tokenation key
    // sandbox_pg55d7z8_vyn2xk6665bkpb5f
    
    // variables
    var user: User?
    var braintreeClient: BTAPIClient!
    var amount = "10"
    
    // iboutlets
    @IBOutlet weak var instructorName: UILabel!
    
    
    // protocols
    
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        braintreeClient = BTAPIClient(authorization: "sandbox_pg55d7z8_vyn2xk6665bkpb5f")
        instructorName.text = user?.name
    }
    
    // methods
    
    // actions
    @IBAction func pay(_ sender: Any) {
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient)
        payPalDriver.viewControllerPresentingDelegate = self
        payPalDriver.appSwitchDelegate = self // Optional
        
        // Specify the transaction amount here. "2.32" is used in this example.
        let request = BTPayPalRequest(amount: amount)
        request.currencyCode = "USD" // Optional; see BTPayPalRequest.h for more options
        
        payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                
                // Access additional information
                
                let email = tokenizedPayPalAccount.email
                
                /*let firstName = tokenizedPayPalAccount.firstName
                 let lastName = tokenizedPayPalAccount.lastName
                 let phone = tokenizedPayPalAccount.phone
                 See BTPostalAddress.h for details
                 let billingAddress = tokenizedPayPalAccount.billingAddress
                 let shippingAddress = tokenizedPayPalAccount.shippingAddress*/
                
                
                let message =
                "You have successfuly paid "
                + self.amount
                + " USD using the paypal account : "
                + email!
                
                self.present(Alert.makeActionAlert(titre: "Success", message:  message, action: UIAlertAction(title: "Proceed", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                })),animated: true)
            } else if let error = error {
                print(error)
            } else {
                // Buyer canceled payment approval
            }
        }
        
    }
    
}

extension PaymentView : BTViewControllerPresentingDelegate{
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        
    }
    
    
}

extension PaymentView : BTAppSwitchDelegate{
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
        
    }
    
    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
        
    }
    
    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
        
    }
    
    
}
