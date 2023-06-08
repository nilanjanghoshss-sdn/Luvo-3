//
//  OTPViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 03/09/21.
//

import UIKit

class OTPViewController: UIViewController {

    @IBOutlet var txtOtp1: UITextField!
    @IBOutlet var txtOtp2: UITextField!
    @IBOutlet var txtOtp3: UITextField!
    @IBOutlet var txtOtp4: UITextField!
    @IBOutlet var lblTimer: UILabel!
    @IBOutlet var btnResendOTP: UIButton!
    
    var tempOTP: String?
    
    var fromVC: String?
    private var otpTimer: Timer?
    private let secondsRemaining = 180
    private var second: Int = 0
    private var otpViewModel = OtpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        otpViewModel.delegate = self
                
        hideResendButton()
        setupTextField()
        startTimer()
        checkVC()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        otpTimer?.invalidate()
    }
    
    private func checkVC() {
        if let vc = fromVC {
            if (vc == "loginVC") {
                resendOtpAPI()
            }
        } else {
            self.showAlert(title: "OTP", message: tempOTP ?? "😎")  //temporary show alert, OTP will come in SMS
        }
    }
    
    //MARK: - Hide Resend Button
    func hideResendButton() {
        btnResendOTP.isHidden = true
        btnResendOTP.isUserInteractionEnabled = false
    }
    
    //MARK: - Setup Textfield
    func setupTextField() {
        txtOtp1.delegate = self
        txtOtp2.delegate = self
        txtOtp3.delegate = self
        txtOtp4.delegate = self
        
        
        txtOtp1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOtp2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOtp3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOtp4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    }
    
    //MARK: - Timer
    func startTimer() {
        second = secondsRemaining
        otpTimer?.invalidate() //cancels it if already running
        otpTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        print(second)
        self.lblTimer.text = self.timeFormatted(second) // will show timer
        if second != 0 {
            second -= 1  // decrease counter timer
        } else {
            if let timer = self.otpTimer {
                timer.invalidate()
                self.otpTimer = nil
                
                btnResendOTP.isHidden = false
                btnResendOTP.isUserInteractionEnabled = true
            }
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    //MARK: - Resend API Call
    func resendOtpAPI() {
        let connectionStatus = ConnectionManager.shared.hasConnectivity()
        if (connectionStatus == false) {
            DispatchQueue.main.async {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
                return
            }
        } else {
            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                self.view.stopActivityIndicator()
                return
            }
            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
            otpViewModel.resendOtp(token: token)
        }
    }

    //MARK: - Button Func
    @IBAction func btnResendOTP(_ sender: Any) {
        resendOtpAPI()
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        let connectionStatus = ConnectionManager.shared.hasConnectivity()
        if (connectionStatus == false) {
            DispatchQueue.main.async {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
                return
            }
        } else {
            let otpValidation = OTPValidation().Validate(otp1: txtOtp1.text, otp2: txtOtp2.text, otp3: txtOtp3.text, otp4: txtOtp4.text)
            if (otpValidation.success) {
                let concatOtp = "\(txtOtp1.text!)\(txtOtp2.text!)\(txtOtp3.text!)\(txtOtp4.text!)"
                
                self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
                
                guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                    self.view.stopActivityIndicator()
                    return
                }
                
                let request = ValidateOtpRequest(otp: concatOtp)
                otpViewModel.validateOtp(validateOtpRequest: request, token: token)
                
            } else {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: otpValidation.error ?? ConstantAlertTitle.ErrorAlertTitle)
            }
        }
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        //See navigation extension file
        self.navigationController?.popToCustomViewController(viewController: LoginViewController.self)
    }
}

extension OTPViewController: UITextFieldDelegate {
    //MARK: - UITextfield Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        if (range.location == 0 && string == " ") {
            return false;
        } else if (newString.count > 1) {
            return false;
        }else {
            guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
                return false
            }
        }
        return true
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case txtOtp1:
                txtOtp2.becomeFirstResponder()
            case txtOtp2:
                txtOtp3.becomeFirstResponder()
            case txtOtp3:
                txtOtp4.becomeFirstResponder()
            case txtOtp4:
                txtOtp4.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case txtOtp1:
                txtOtp1.becomeFirstResponder()
            case txtOtp2:
                txtOtp1.becomeFirstResponder()
            case txtOtp3:
                txtOtp2.becomeFirstResponder()
            case txtOtp4:
                txtOtp3.becomeFirstResponder()
            default:
                break
            }
        }
    }
}

extension OTPViewController: OtpViewModelDelegate {
    //MARK: - Delegate
    func didReceiveValidateOtpResponse(validateOtpResponse: ValidateOtpResponse?) {
        self.view.stopActivityIndicator()
        
        if(validateOtpResponse?.status != nil && validateOtpResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(validateOtpResponse)
            self.openAlertWithButtonFunc(title: ConstantAlertTitle.LuvoAlertTitle,
                                         message: validateOtpResponse?.message ?? "Validated",
                                         alertStyle: .alert,
                                         actionTitles: [ConstantAlertTitle.OkAlertTitle],
                                         actionStyles: [.default], actions: [
                                            {_ in
                                                let questionVC = ConstantStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "Welcome2ViewController") as! Welcome2ViewController
                                                self.navigationController?.pushViewController(questionVC, animated: true)
                                            }
                                         ])
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: validateOtpResponse?.message ?? ConstantAlertMessage.TryAgainLater)
        }
    }
    
    func didReceiveValidateOtpError(statusCode: String?) {
        self.view.stopActivityIndicator()
        
        showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
    
       
    func didReceiveOtpResendResponse(otpResendResponse: OtpResendResponse?) {
        self.view.stopActivityIndicator()
        
        if(otpResendResponse?.status != nil && otpResendResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(otpResendResponse)
//            self.showAlert(title: "OTP", message: otpResendResponse?.otp ?? "😎")  //temporary show alert, OTP will come in SMS
            hideResendButton()
            startTimer()
            
        } else if (otpResendResponse?.status == nil) {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: otpResendResponse?.message ?? ConstantAlertMessage.TryAgainLater)
        }
    }
    
    func didReceiveOtpResendError(statusCode: String?) {
        self.view.stopActivityIndicator()
        
        showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}
