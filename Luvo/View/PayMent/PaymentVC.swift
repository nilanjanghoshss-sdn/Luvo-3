//
//  PaymentVC.swift
//  Luvo
//
//  Created by BEASiMAC on 08/02/23.
//

import UIKit
import StripePaymentSheet
import StripeApplePay
import PassKit
class PaymentVC: UIViewController, ApplePayContextDelegate {
    
    var paymentSheet: PaymentSheet?
    var stripePayment = StripePaymentModel()
    var UserPaymentdetails: Striperesponse?
  //  var amount : String = ""
    var customerEphemeralKeySecretApple : String = ""
    var publishableKeyApple : String = ""

    @IBOutlet var ImgLuvo: UIImageView!
    @IBOutlet var ImgLuvoBack: UIImageView!
    @IBOutlet var ImgFamily: UIImageView!
    
    
    @IBOutlet weak var btnOne: UIButton!
    @IBOutlet weak var btnTwo: UIButton!
    @IBOutlet weak var btnThree: UIButton!
    @IBOutlet weak var btnFour: UIButton!
    
    @IBOutlet weak var ViewPayment: UIView!
    var paymentDataModel = PaymentDataModel()
    var paymentData: PaymentResponse?
    let applePayButton: PKPaymentButton = PKPaymentButton(paymentButtonType: .plain, paymentButtonStyle: .black)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applePayButton.isHidden = !StripeAPI.deviceSupportsApplePay()
        applePayButton.addTarget(self, action: #selector(handleApplePayButtonTapped), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UserDefaults.standard.set(true, forKey: "IsfromDonation")
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
       // self.view.stopActivityIndicator()
        return
        }
        paymentDataModel.paymentDelegate = self
       // self.payment(amount: "1999")
       // paymentDataModel.getpaymentData(token: token)
        
       

        ViewPayment.isHidden=true
//        ImgLuvo.layer.borderWidth=1.0
//        ImgLuvo.layer.masksToBounds = false
//        ImgLuvo.layer.borderColor = UIColor.white.cgColor
//        ImgLuvo.layer.cornerRadius = ImgLuvo.frame.height / 2
//        ImgLuvo.clipsToBounds = true

//        ImgLuvoBack.layer.borderWidth=1.0
//        ImgLuvoBack.layer.masksToBounds = false
//        ImgLuvoBack.layer.borderColor = UIColor.white.cgColor
 ////       ImgLuvoBack.layer.cornerRadius = ImgLuvoBack.frame.height / 2
 ///       ImgLuvoBack.clipsToBounds = true

 ////       ImgFamily.tintColor = UIColor.red
    }

    @objc func handleApplePayButtonTapped() {

        publishableKeyApple = (self.UserPaymentdetails?.paymentDetails?.publishableKey ?? "1234")
        customerEphemeralKeySecretApple = (self.UserPaymentdetails?.paymentDetails?.ephemeralKey ?? "1234")
        print(publishableKeyApple)
        print(customerEphemeralKeySecretApple)
        let merchantIdentifier = "merchant.com.BCS.Luvo"
        let paymentRequest = StripeAPI.paymentRequest(withMerchantIdentifier: merchantIdentifier, country: "US", currency: "USD")

        // Configure the line items on the payment request
        paymentRequest.paymentSummaryItems = [
            // The final line should represent your company;
            // it'll be prepended with the word "Pay" (that is, "Pay iHats, Inc $50")
            PKPaymentSummaryItem(label: "iHats, Inc", amount: 50.00),
        ]
        // ...continued in next step

        if let applePayContext = STPApplePayContext(paymentRequest: paymentRequest, delegate: self) {
                // Present Apple Pay payment sheet
                applePayContext.presentApplePay(on: self)
            } else {
                // There is a problem with your Apple Pay configuration
            }
    }


    
    
    @IBAction func btncloseBack(_ sender: Any) {

        navigationController?.popViewController(animated: false)
    }


    @IBAction func btnPayment(_ sender: Any) {

       self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
        self.payment(amount: "299")

//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//        self.handleApplePayButtonTapped()
//
//        }
//
//        let request = PKPaymentRequest()
//                request.merchantIdentifier = "merchant.com.BCS.Luvo"
//                request.supportedNetworks = [.quicPay, .masterCard, .visa]
//                request.supportedCountries = ["IN", "US"]
//                request.merchantCapabilities = .capability3DS
//                request.countryCode = "IN"
//                request.currencyCode = "INR"
//                request.paymentSummaryItems = [PKPaymentSummaryItem(label: "iPhone XR 128 GB", amount: 123000)]
//
//        let controller = PKPaymentAuthorizationViewController(paymentRequest: request)
//                if controller != nil {
//                    controller!.delegate = self
//                    present(controller!, animated: true, completion: nil)
              //  }
    }
//
    @IBAction func btnPaymentTwo(_ sender: Any) {
        
        self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
    self.payment(amount: "599")


    }
    @IBAction func btnPaymentThree(_ sender: Any) {

        self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
        self.payment(amount: "999")
    }
    @IBAction func btnPaymentFour(_ sender: Any) {
        
        self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
       self.payment(amount: "1999")

//        let callVC = ConstantStoryboard.Payment.instantiateViewController(withIdentifier: "StripeVC") as! StripeVC
//        self.navigationController?.pushViewController(callVC, animated: false)
//
//
////        UIView.transition(with: ViewPayment,
////                                 duration: 0.5,
////                                 options: [.transitionFlipFromRight],
////                                 animations: {
////
////                                   self.ViewPayment.isHidden = false
////               },
////                                 completion: nil)
    }

    @IBAction func btnClose(_ sender: Any) {

        let callVC = ConstantStoryboard.Payment.instantiateViewController(withIdentifier: "StripeVC") as! StripeVC
        self.navigationController?.pushViewController(callVC, animated: false)


//        UIView.transition(with: ViewPayment,
//                                 duration: 0.5,
//                                 options: [.transitionFlipFromRight],
//                                 animations: {
//
//                                   self.ViewPayment.isHidden = true
//               },
//                                 completion: nil)
    }
    
    func payment(amount:String)
    {

        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
     //   self.view.stopActivityIndicator()
        return
        }
//
//
        let userName = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserName) as! String
       print(userName)
        let userEmail = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserEmail) as! String
        print(userEmail)
        stripePayment.StripeDelegate = self
        let request = StripePaymentRequest(amount: amount, currency: "usd", customerName: userName, customerEmail: userEmail)
        stripePayment.postStripeData(Request: request, token: token)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {

            self.view.stopActivityIndicator()
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
            configuration.allowsDelayedPaymentMethods = true
      configuration.applePay = .init(
        merchantId: "merchant.com.BCS.Luvo",
        merchantCountryCode: "US"
      )

            self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret as! String, configuration: configuration)




            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {

                self.paymentSheet?.present(from: self) { paymentResult in
                  // MARK: Handle the payment result
                  switch paymentResult {
                  case .completed:
                    print("Your order is confirmed")
                      UserDefaults.standard.set(true, forKey: "IsfromSession")
                      //DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                          self.navigationController?.popViewController(animated: true)
                     // }
                  case .canceled:
                     // UserDefaults.standard.set(true, forKey: "IsfromSession")
                    print("Canceled!")
                  case .failed(let error):
                    //  UserDefaults.standard.set(true, forKey: "IsfromSession")
                    print("Payment failed: \(error)")
                  }
                }

            }

                //task.resume()




    }
    }

}





extension PaymentVC : PaymentDataModelDelegate
{
    func didReceivePaymentDataModelDelegateResponse(PaymentDataModelresponse: PaymentResponse?) {


        //btnOne.titleLabel?.text = String(PaymentDataModelresponse?.data![0] ?? 0)
       // var str:str = PaymentDataModelresponse?.data![2]
        //btnOne.setTitle(str, for: .normal)
       paymentData = PaymentDataModelresponse
        debugPrint(paymentData)
    }

    func didReceivePaymentDataModelDelegateError(statusCode: String?) {

    }
    
    
}
    
extension PaymentVC : StripePaymentDelegate
{
    func didReceiveStripeResponse(StripeResponse: Striperesponse?) {
        
        UserPaymentdetails = StripeResponse
        print(UserPaymentdetails ?? "Test")
    }
    
    func didReceiveStripeError(statusCode: String?) {
        
    }
    
    
}


extension PaymentVC {
    func applePayContext(_ context: STPApplePayContext, didCreatePaymentMethod paymentMethod: StripeAPI.PaymentMethod, paymentInformation: PKPayment, completion: @escaping STPIntentClientSecretCompletionBlock) {
        let clientSecret = customerEphemeralKeySecretApple
        // Call the completion block with the client secret or an error
        let error : String = ""
        completion(clientSecret, error as? Error)
    }

    func applePayContext(_ context: STPApplePayContext, didCompleteWith status: STPApplePayContext.PaymentStatus, error: Error?) {
          switch status {
        case .success:
            // Payment succeeded, show a receipt view
            break
        case .error:
            // Payment failed, show the error
            break
        case .userCancellation:
            // User canceled the payment
            break
        @unknown default:
            fatalError()
        }
    }
}


extension PaymentVC : PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
}

