//
//  StripeVC.swift
//  Luvo
//
//  Created by Nilanjan Ghosh on 28/03/23.
//

import UIKit
import StripePaymentSheet
class StripeVC: UIViewController {
    var paymentSheet: PaymentSheet?
    var stripePayment = StripePaymentModel()
    var UserPaymentdetails: Striperesponse?
    @IBOutlet weak var checkoutButton: UIButton!
//    lazy var cardTextField: STPPaymentCardTextField = {
//            let cardTextField = STPPaymentCardTextField()
//            return cardTextField
//        }()
//        lazy var payButton: UIButton = {
//            let button = UIButton(type: .custom)
//            button.layer.cornerRadius = 5
//            button.backgroundColor = .systemBlue
//            button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
//            button.setTitle("Pay", for: .normal)
//            button.addTarget(self, action: #selector(pay), for: .touchUpInside)
//            return button
//        }()


    override func viewDidLoad() {
        super.viewDidLoad()
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
        self.view.stopActivityIndicator()
        return
        }
        
        checkoutButton.addTarget(self, action: #selector(didTapCheckoutButton), for: .touchUpInside)
            checkoutButton.isEnabled = false

        
       // UserDefaults.standard.set(loginResponse?.userDetail?.userName, forKey: ConstantUserDefaultTag.udUserName)
        
        let userName = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserName) as! String
        print(userName)
        let userEmail = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserEmail) as! String
        print(userEmail)
        stripePayment.StripeDelegate = self
        let request = StripePaymentRequest(amount: "299", currency: "usd", customerName: userName, customerEmail: userEmail)
        stripePayment.postStripeData(Request: request, token: token)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            print(self.UserPaymentdetails?.paymentDetails?.customerEmail as Any)
            print(self.UserPaymentdetails?.paymentDetails?.customerId as Any)
            print(self.UserPaymentdetails?.paymentDetails?.customerName as Any)
            print(self.UserPaymentdetails?.paymentDetails?.publishableKey as Any)
            print(self.UserPaymentdetails?.paymentDetails?.ephemeralKey as Any)
            print(self.UserPaymentdetails?.paymentDetails?.paymentIntent as Any)
            
            var publishableKey = (self.UserPaymentdetails?.paymentDetails?.publishableKey as Any)
            var customerId = (self.UserPaymentdetails?.paymentDetails?.customerId as Any)
            var customerEphemeralKeySecret = (self.UserPaymentdetails?.paymentDetails?.ephemeralKey as Any)
            var paymentIntentClientSecret = (self.UserPaymentdetails?.paymentDetails?.paymentIntent as Any)
            
            STPAPIClient.shared.publishableKey = publishableKey as? String
                  // MARK: Create a PaymentSheet instance
                  var configuration = PaymentSheet.Configuration()
                  configuration.merchantDisplayName = "Zest2Live"
            configuration.customer = .init(id: customerId as! String, ephemeralKeySecret: customerEphemeralKeySecret as! String)
                  // Set `allowsDelayedPaymentMethods` to true if your business can handle payment
                  // methods that complete payment after a delay, like SEPA Debit and Sofort.
                  configuration.allowsDelayedPaymentMethods = true
            self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret as! String, configuration: configuration)

                  DispatchQueue.main.async {
                    self.checkoutButton.isEnabled = true
                  }
                
                //task.resume()
              }
        }
    
    @objc
    func didTapCheckoutButton() {
      // MARK: Start the checkout process
      paymentSheet?.present(from: self) { paymentResult in
        // MARK: Handle the payment result
        switch paymentResult {
        case .completed:
          print("Your order is confirmed")
        case .canceled:
          print("Canceled!")
        case .failed(let error):
          print("Payment failed: \(error)")
        }
      }
    }

//        super.viewDidLoad()
//                view.backgroundColor = .white
//                let stackView = UIStackView(arrangedSubviews: [cardTextField, payButton])
//                stackView.axis = .vertical
//                stackView.spacing = 20
//                stackView.translatesAutoresizingMaskIntoConstraints = false
//                view.addSubview(stackView)
//                NSLayoutConstraint.activate([
//                    stackView.leftAnchor.constraint(equalToSystemSpacingAfter: view.leftAnchor, multiplier: 2),
//                    view.rightAnchor.constraint(equalToSystemSpacingAfter: stackView.rightAnchor, multiplier: 2),
//                    stackView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 20),
//                ])

    }


    

//    @objc
//        func pay() {
////            guard let paymentIntentClientSecret = paymentIntentClientSecret else {
////                return
////            }
//            // Collect card details
//            let paymentIntentClientSecret = "pi_3MqGJ7LN2CBttmwh0PL8mTXp_secret_3ZF1kv6EtdAKDtAyQC8TDGXpD"
//            let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
//            paymentIntentParams.paymentMethodParams = cardTextField.paymentMethodParams
//
//            // Submit the payment
//            let paymentHandler = STPPaymentHandler.shared()
//            paymentHandler.confirmPayment(paymentIntentParams, with: self) { (status, paymentIntent, error) in
//                switch (status) {
//                case .failed:
//
//                    print(status)
////                    self.displayAlert(title: "Payment failed", message: error?.localizedDescription ?? "")
//
//                    let refreshAlert = UIAlertController(title: "Luvo", message: "Payment Received", preferredStyle: UIAlertController.Style.alert)
//
//                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//                          print("Handle Ok logic here")
//
//                        let status = UserDefaults.standard.bool(forKey: "IsfromHome")
//                                                print(status)
//
//                        if status==true
//                        {
//
//
//                        for controller in self.navigationController!.viewControllers as Array {
//                            if controller.isKind(of: HomeViewController.self) {
//                                self.navigationController!.popToViewController(controller, animated: true)
//                                break
//                            }
//                        }
//                        }
//
//                        let status1 = UserDefaults.standard.bool(forKey: "IsfromRecord")
//                                                print(status)
//
//                        if status1==true
//                        {
//
//
//                        for controller in self.navigationController!.viewControllers as Array {
//                            if controller.isKind(of: VideoPlay.self) {
//                                self.navigationController!.popToViewController(controller, animated: true)
//                                break
//                            }
//                        }
//                        }
//                        let status2 = UserDefaults.standard.bool(forKey: "IsfromSession")
//                                                print(status2)
//
//                        if status2==true
//                        {
//
//
//                        for controller in self.navigationController!.viewControllers as Array {
//                            if controller.isKind(of: AgoraStreamViewController.self) {
//                                self.navigationController!.popToViewController(controller, animated: true)
//                                break
//                            }
//                        }
//                        }
//
//
//
//
//                    }))
//
//                    self.present(refreshAlert, animated: true, completion: nil)
//
//                    break
//                case .canceled:
//
//                    let refreshAlert = UIAlertController(title: "Luvo", message: "Payment Received", preferredStyle: UIAlertController.Style.alert)
//
//                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//                          print("Handle Ok logic here")
//
//
//
//                    }))
//
//                    self.present(refreshAlert, animated: true, completion: nil)
//
////                    self.displayAlert(title: "Payment canceled", message: error?.localizedDescription ?? "")
//                    break
//                case .succeeded:
//
//                    let refreshAlert = UIAlertController(title: "Luvo", message: "Payment Received", preferredStyle: UIAlertController.Style.alert)
//
//                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//                          print("Handle Ok logic here")
//
//                    }))
//
//                    self.present(refreshAlert, animated: true, completion: nil)
//
////                    self.displayAlert(title: "Payment succeeded", message: paymentIntent?.description ?? "", restartDemo: true)
//                    break
//                @unknown default:
//                    fatalError()
//                    break
//                }
//            }
//        }

//}


extension StripeVC : StripePaymentDelegate
{
    func didReceiveStripeResponse(StripeResponse: Striperesponse?) {
        
        UserPaymentdetails = StripeResponse
        print(UserPaymentdetails ?? "Test")
    }
    
    func didReceiveStripeError(statusCode: String?) {
        
    }
    
    
}

