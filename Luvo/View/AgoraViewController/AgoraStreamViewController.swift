//
//  AgoraStreamViewController.swift
//  Luvo
//
//  Created by BEASiMAC on 10/12/22.
//
import StripePaymentSheet
import UIKit
import AVFoundation
import AgoraRtcKit
import Firebase
import FirebaseDatabase

class AgoraStreamViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
   // @IBOutlet weak var imgProfileView: UICollectionView!
    var  sessionId: String = ""
    var agoraUserProfileModel = AgoraUserProfileModel()
    private var liveJoinViewModel = LiveJoinViewModel()
    var UserData: AgoraUserProfileImageResponse?
    var paymentData: PaymentResponse?
    private var countdownTimer: Timer?
    @IBOutlet weak var btnDisconnect: UIButton!
    @IBOutlet weak var remoteView: UIView!
    @IBOutlet weak var VwDisconnet: UIView!

//===========================================================================================

    @IBOutlet weak var imgVwDonate: UIImageView!
    @IBOutlet weak var vwDonate: UIView!
    @IBOutlet weak var localView: UIView!
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var btnshare: UIButton!
    @IBOutlet weak var chatView: UITableView!
    @IBOutlet weak var imgvb: UIImageView!
    @IBOutlet weak var collectionViewImage: UICollectionView!
    @IBOutlet weak var viewCall: UIView!
    @IBOutlet weak var userDetail: UIView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var imgVwMute: UIImageView!
    @IBOutlet weak var imgVwCamera: UIImageView!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var btnDisconnectCall: UIImageView!
    @IBOutlet weak var lblLive: UILabel!
    @IBOutlet weak var txtfeildChat: UITextField!
    @IBOutlet weak var lblSessionName: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var ChatImageView: UIImageView!
    @IBOutlet weak var ChatArrowIcon: UIImageView!
    @IBOutlet weak var ChatOnOffImageView: UIImageView!
    
    @IBOutlet weak var PaymentView: UIView!
    var UserDataChat: AllUserChatResponse?
    var array = [String]()

    var arrText = [String]()
    var ReveredarrText = [String]()

    var arrName = [String]()
    var ReveresdarrName = [String]()

    var arrTime = [String]()
    var ReversedarrTime = [String]()

    var arrUserImage = [String]()
    var ReversedarrUserImage = [String]()

    var agoraEngine: AgoraRtcEngineKit!
    // By default, set the current user role to broadcaster to both send and receive streams. .audience .broadcaster
    var userRole: AgoraClientRole = .audience
    var UserchatData = AllUserChatModel()
 
    var chatViewModel = UserchatWithCoachModel()
    var UserDetailsForCall = UserDetailsForCallModel()

    var AgoraAppId: String = ""
    var Agoaratoken: String = ""
    var channelName: String = ""
    var coachImage: String = ""
    var sessionName: String = ""

        var joinButton: UIButton!
        var isMute: Bool = false
        var isChatOn: Bool = true
        var joined: Bool = false
        var ref: DatabaseReference!
    
    var isgoingtocall: Bool = false
    var isPaymentViewOpen: Bool = false
    
   // let refreshAlert : UIAlertController!
    
    var paymentSheet: PaymentSheet?
    var stripePayment = StripePaymentModel()
    var paymentDataModel = PaymentDataModel()
    var UserPaymentdetails: Striperesponse?
  //  var amount : String = ""
    var customerEphemeralKeySecretApple : String = ""
    var publishableKeyApple : String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      

    }


    override func viewWillAppear(_ animated: Bool) {
        
        PaymentView.isHidden = true
        
        UIApplication.shared.isIdleTimerDisabled = true
        ref = Database.database().reference()
        
        
       // remoteView.addSubview(VwDisconnet)
        self.agoraUserProfileModel.AgoraUserdelegate = self
        self.UserDetailsForCall.UserDetailsForCallModeldelegate = self
        self.paymentDataModel.paymentDelegate = self
        debugPrint(sessionId)
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
           // self.view.stopActivityIndicator()
            return
        }
        debugPrint("token--->",token)
        debugPrint(AgoraAppId)
        debugPrint(Agoaratoken)
        debugPrint(channelName)
        debugPrint(sessionId)
        debugPrint(sessionName)
        startTimer()
        getImageDetails()
        childObserver()


       //     agoraUserProfileModel.getAgoraliveUerDetails(token: token, SesionId: sessionId)

        // Do any additional setup after loading the view.
        
       // initViews()
        initializeAgoraEngine()
        DispatchQueue.main.async {
          // your code here
           
            self.joinChannel()
            self.agoraEngine.muteLocalAudioStream(true)
           // self.view.addSubview(remoteView)
           // remoteView.addSubview(btnDisconnect)

            self.donation()
        }


        lblUser.text = "0" + " User Here"
              //  lblSessionName.text = SessionName
                lblSessionName.text = sessionName

                NotificationCenter.default.addObserver(self, selector: #selector(CoachViewAgoraVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

                  // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
                NotificationCenter.default.addObserver(self, selector: #selector(CoachViewAgoraVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)



                array.append(" I have a design that implements a dark blue UITextField, as the placeholder text is by default")
                array.append(" design that implements a ")
                array.append("  a design ")
                array.append(" I ")
                array.append(" I have a design that implements a dark blue UITextField, as the placeholder text is by default")
                array.append(" design that implements a ")
                array.append("  a design ")
                array.append(" I ")

                chatView.reloadData()

        

        self.chatView.rowHeight  = UITableView.automaticDimension
        self.chatView.estimatedRowHeight = 156

        self.UserchatData.AllUserChatdelegate = self
        self.chatViewModel.Chatdelegate = self
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
       // self.view.stopActivityIndicator()
        return
        }
        self.UserchatData.getChatDetails(token: token, SessionID: self.sessionId)
      //  DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) {
           // self.UserDetailsForCall.getUserDetailsForCallDetails(token: token, SesionId: self.sessionId)
      //  }

    }


    func donation()
    {
        let status2 = UserDefaults.standard.bool(forKey: "IsfromSession")
                                print(status2)

        if status2==true
        {
            let userName = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udUserName) as! String
            print(userName)

            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
               // self.view.stopActivityIndicator()
                return
            }
            self.view.endEditing(true)

            let request = UserChatRequest(text: userName + " Has Donated" + " \u{1F496}", sessionId: sessionId)
            chatViewModel.postChatJoinData(Chat: request, token: token)

          //  var str : String? = sessionId

            debugPrint(sessionId)
            let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
            print(time + ", Type :UserJoin")
            self.ref.child(sessionId).setValue(["value": time + ", Type :Chat"])
            txtfeildChat.text = ""
            //1672236276, Type :SessionEnd
            UserDefaults.standard.set(false, forKey: "IsfromHome")
            UserDefaults.standard.set(false, forKey: "IsfromRecord")
            UserDefaults.standard.set(false, forKey: "IsfromSession")

        }
        else
        {

        }


    }
    
    private func childObserver()
    {
        ref.child(sessionId).observe(.childChanged) { (snapshot) in
            
            if let value = snapshot.value as? String
            {
                debugPrint(value)
                let string = value
                if string.contains("UserJoin") {
                    print("exists")
                    self.getImageDetails()
                }
                
                else if string.contains("SessionEndCallStart")
                {
                    print("get Lost")

                 //   let refreshAlert = UIAlertController(title: "Luvo", message: "Coach has ended the session", preferredStyle: UIAlertController.Style.alert)
                    
                    let refreshAlert = UIAlertController(title: "Luvo", message: "Coach has started a conference call. Do you want to join?", preferredStyle: UIAlertController.Style.alert)

                    refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                          print("Handle Ok logic here")


                       // if string.contains("CallStart"){
                           if string == "CallStart"{ //StartCall
                            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                           // self.view.stopActivityIndicator()
                            return
                            }
                            self.UserDetailsForCall.getUserDetailsForCallDetails(token: token, SesionId: self.sessionId)
                            self.isgoingtocall = true
                            self.btnEndCall(true)
                        }

                        else
                        {
                            self.showalertNew(Value: true)
                        }

                       
                    }))

                    refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                          print("Handle Cancel Logic here")
                        self.isgoingtocall = false
                        self.btnEndCall(true)
                    }))

                    self.present(refreshAlert, animated: true, completion: nil)
                }
                
                else if string.contains("CallStart")
                {
                    
                    debugPrint("?L")
                    
                    guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                    
                    return
                    }
                   // self.showalertNew(Value: false)
                   // self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.UserDetailsForCall.getUserDetailsForCallDetails(token: token, SesionId: self.sessionId)
                    }
                    self.isgoingtocall = true
                   
                    self.btnEndCall(true)
                  
                    
                }
                
                else if string.contains("SessionEnd")
                {
                    
                    let refreshAlert = UIAlertController(title: "Luvo", message: "Coach has ended the session", preferredStyle: UIAlertController.Style.alert)

                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                          print("Handle Ok logic here")
                        self.isgoingtocall = false
                        self.btnEndCall(true)
                        
                    }))

                    self.present(refreshAlert, animated: true, completion: nil)
                    
                }

                if string.contains("Chat") {
                    print("chat")
                   // self.getImageDetails()
                    guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
                    //self.view.stopActivityIndicator()
                    return
                }
                    self.UserchatData.getChatDetails(token: token, SessionID: self.sessionId)
                }
                

            }
        }
        
    }
    
    func showalertNew(Value : Bool)
    {
        
      
        self.viewDidDisappear(false)
        isPaymentViewOpen = false
        let refreshAlert = UIAlertController(title: "Luvo", message: "Please wait to start the call", preferredStyle: UIAlertController.Style.alert)

//                            refreshAlert.addAction(UIAlertAction(title: "", style: .default, handler: { (action: UIAlertAction!) in
//                                  print("Handle Ok logic here")
//                            }))

            self.present(refreshAlert, animated: true, completion: nil)
        
        if Value == false
        {
           // refreshAlert.dismiss(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
        
    }


    @objc func keyboardWillShow(notification: NSNotification) {

            guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
               // if keyboard size is not available for some reason, dont do anything
               return
            }

          // move the root view up by the distance of keyboard height
          self.MainView.frame.origin.y = 0 - keyboardSize.height
        }

        @objc func keyboardWillHide(notification: NSNotification) {
          // move back the root view origin to zero
          self.MainView.frame.origin.y = 0
        }

        // UITextField Delegates
            func textFieldDidBeginEditing(_ textField: UITextField) {
                print("TextField did begin editing method called")

            }
            func textFieldDidEndEditing(_ textField: UITextField) {
                print("TextField did end editing method called\(textField.text!)")
            }
            func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
                print("TextField should begin editing method called")

                chatView.isHidden = false
                ChatOnOffImageView.image = UIImage(named: "chat1")
                isChatOn = true

                return true;
            }
            func textFieldShouldClear(_ textField: UITextField) -> Bool {
                print("TextField should clear method called")
                return true;
            }
            func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
                print("TextField should end editing method called")
                return true;
            }
            func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                print("While entering the characters this method gets called")


                return true;
            }
            func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                print("TextField should return method called")



                textField.resignFirstResponder();
                return true;
            }

        @IBAction func btnMute(_ sender: Any) {

            if isMute == false
            {
            let image = UIImage(named: "mute-microphone")  //mute-microphone microphone
                imgVwMute.image = image
                isMute = true
                agoraEngine.muteLocalAudioStream(true)

               // agoraEngine.switchCamera();
            }
            else if isMute == true
            {
                let image = UIImage(named: "microphone")
                imgVwMute.image = image
                    isMute = false
                agoraEngine.muteLocalAudioStream(false)

            }
        }

    @IBAction func btnDonate(_ sender: Any) {
        
        if isPaymentViewOpen == false
        {
        PaymentView.isHidden = false
        UserDefaults.standard.set(false, forKey: "IsfromHome")
        UserDefaults.standard.set(false, forKey: "IsfromRecord")
        UserDefaults.standard.set(false, forKey: "IsfromSession")
            
            isPaymentViewOpen = true
        }
        
        
//        let callVC = ConstantStoryboard.Payment.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
//        self.navigationController?.pushViewController(callVC, animated: false)
    }
    
    @IBAction func paymentViewCloseButton(_ sender: Any) {
        
        PaymentView.isHidden = true
        isPaymentViewOpen = false
    }
    
        @IBAction func ChatToggle(_ sender: Any) {

            if isChatOn == true
            {
                chatView.isHidden = true
                ChatOnOffImageView.image = UIImage(named: "chat2")
                isChatOn = false
            }

            else if isChatOn == false
            {
                chatView.isHidden = false
                ChatOnOffImageView.image = UIImage(named: "chat1")
                isChatOn = true
            }


        }
    
    func startTimer() {
        let time = String(UInt64(Date().timeIntervalSince1970 * 1000))

        print(time + ", Type :UserJoin")

        self.ref.child(sessionId).setValue(["value": time + ", Type :UserJoin"])
        
        countdownTimer?.invalidate() //cancels it if already running
        countdownTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(getImageDetails), userInfo: nil, repeats: true) //1hr call
    }
    
    @objc func getImageDetails()
    {
//        let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
//
//        print(time + ", Type :UserJoin")
//
//        self.ref.child(sessionId).setValue(["value": time + ", Type :UserJoin"])

        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
           // self.view.stopActivityIndicator()
            return
        }
        debugPrint("token--->",sessionId)
        agoraUserProfileModel.getAgoraliveUerDetails(token: token, SesionId: sessionId)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
        
        if isPaymentViewOpen == false
        {
            leaveChannel()
            DispatchQueue.global(qos: .userInitiated).async {AgoraRtcEngineKit.destroy()}
        }
        else{
            
        }
        
        }

    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
//            localView.bringSubviewToFront(collectionViewImage)
//            localView.bringSubviewToFront(viewCall)
//            localView.bringSubviewToFront(chatView)
//            localView.bringSubviewToFront(imgVwMute)
//            localView.bringSubviewToFront(lblLive)
//            localView.bringSubviewToFront(MainView)
//            localView.bringSubviewToFront(lblSessionName)
//            localView.bringSubviewToFront(btnDisconnectCall)
//            localView.bringSubviewToFront(userDetail)
//            localView.bringSubviewToFront(commentView)


        remoteView.bringSubviewToFront(collectionViewImage)
        remoteView.bringSubviewToFront(viewCall)
        remoteView.bringSubviewToFront(chatView)
        remoteView.bringSubviewToFront(vwDonate)
        remoteView.bringSubviewToFront(lblLive)
        remoteView.bringSubviewToFront(MainView)
        remoteView.bringSubviewToFront(lblSessionName)
        remoteView.bringSubviewToFront(btnDisconnectCall)
        remoteView.bringSubviewToFront(userDetail)
        remoteView.bringSubviewToFront(commentView)








           // chatView.estimatedRowHeight = 100.0
           // chatView.rowHeight = UITableView.automaticDimension
            chatView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi));


           // imgVwMute?.layer.cornerRadius = (imgVwMute?.frame.size.width ?? 0.0) / 2
          //  imgVwDisconnect?.layer.cornerRadius = (imgVwDisconnect?.frame.size.width ?? 0.0) / 2
         //   imgVwCamera?.layer.cornerRadius = (imgVwCamera?.frame.size.width ?? 0.0) / 2

            btnDisconnectCall?.layer.cornerRadius = (btnDisconnectCall?.frame.size.width ?? 0.0) / 2
            btnDisconnectCall?.layer.masksToBounds =  true
            print(coachImage)
            UserDefaults.standard.set(coachImage, forKey: "CoachImage") //setObject
            imgVwUser.sd_setImage(with: URL(string: coachImage), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
            imgVwUser?.layer.cornerRadius = (imgVwUser?.frame.size.width ?? 0.0) / 2
            imgVwUser?.layer.masksToBounds = true
            imgVwUser?.layer.borderColor = #colorLiteral(red: 0.7058823529, green: 0.02352941176, blue: 0.05098039216, alpha: 1)
            imgVwUser?.layer.borderWidth = 3.0

            lblLive.layer.cornerRadius = 8
            lblLive.layer.masksToBounds = true

            ChatImageView.layer.masksToBounds = true
            ChatImageView.layer.borderColor = UIColor.white.cgColor
            ChatImageView.layer.borderWidth = 2.0
            ChatImageView.layer.cornerRadius = 15
        
        imgVwDonate.layer.masksToBounds = true
        imgVwDonate.layer.borderColor = UIColor.white.cgColor
        imgVwDonate.layer.borderWidth = 2.0
        imgVwDonate.layer.cornerRadius = 15
        
        





        }

    
//    func initViews() {
//            // Initializes the remote video view. This view displays video when a remote host joins the channel.
//           // remoteView = UIView()
//           // self.view.addSubview(remoteView)
//            // Initializes the local video window. This view displays video when the local user is a host.
//          //  localView = UIView()
//          //  self.view.addSubview(localView)
//            //  Button to join or leave a channel
//
//
//            joinButton = UIButton(type: .system)
//            joinButton.frame = CGRect(x: 169, y: 453, width: 77, height: 62)
//            joinButton.setTitle("Join", for: .normal)
//
//            joinButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
//            self.view.addSubview(joinButton)
//        }

    @objc func buttonAction(sender: UIButton!) {
            if !joined {
                joinChannel()
                // Check if successfully joined the channel and set button title accordingly
                if joined { joinButton.setTitle("Leave", for: .normal)
                    joinButton.setImage(UIImage(named: "call_disconnect.png"), for: .normal)
                }
            } else {
                leaveChannel()
                // Check if successfully left the channel and set button title accordingly
                if !joined { joinButton.setTitle("Join", for: .normal) }
            }
        }
    
    
    @IBAction func btnShare(_ sender: Any) {


        print("Share is working------>")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            let text = "Luvo© - Your personal health & fitness app"
            let image = UIImage(named: "Splash")
            let myWebsite = NSURL(string:"https://apps.apple.com/in/app/luvo-zest2live/id1617104475")
            let shareAll: [Any] = [text, image!, myWebsite!]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
//            activityViewController.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypePostToWeibo, UIActivityTypeCopyToPasteboard, UIActivityTypeAddToReadingList, UIActivityTypePostToVimeo]    //Include the app to exclude from sharing
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)


        }
        
//        leaveChannel()
//
//        let chatVC = ConstantStoryboard.chatUser.instantiateViewController(withIdentifier: "ChatWithCoachVC") as! ChatWithCoachVC
//        chatVC.sessionId = sessionId
//        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    @IBAction func Leave(_ sender: Any) {
        
        leaveChannel()
        
    }
//    func checkForPermissions() -> Bool {
//        var hasPermissions = false
//
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//            case .authorized: hasPermissions = true
//            default: hasPermissions = requestCameraAccess()
//        }
//        // Break out, because camera permissions have been denied or restricted.
//        if !hasPermissions { return false }
//        switch AVCaptureDevice.authorizationStatus(for: .audio) {
//            case .authorized: hasPermissions = true
//            default: hasPermissions = requestAudioAccess()
//        }
//        return hasPermissions
//    }
//
//    func requestCameraAccess() -> Bool {
//        var hasCameraPermission = false
//        let semaphore = DispatchSemaphore(value: 0)
//        AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
//            hasCameraPermission = granted
//            semaphore.signal()
//        })
//        semaphore.wait()
//        return hasCameraPermission
//    }
//
//    func requestAudioAccess() -> Bool {
//        var hasAudioPermission = false
//        let semaphore = DispatchSemaphore(value: 0)
//        AVCaptureDevice.requestAccess(for: .audio, completionHandler: { granted in
//            hasAudioPermission = granted
//            semaphore.signal()
//        })
//        semaphore.wait()
//        return hasAudioPermission
//    }
//
//    func showMessage(title: String, text: String, delay: Int = 2) -> Void {
//        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
//        self.present(alert, animated: true)
//        let deadlineTime = DispatchTime.now() + .seconds(delay)
//        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
//            alert.dismiss(animated: true, completion: nil)
//        })
//    }
    
    func initializeAgoraEngine() {
        let config = AgoraRtcEngineConfig()
        // Pass in your App ID here.
        config.appId = AgoraAppId
        // Use AgoraRtcEngineDelegate for the following delegate parameter.
        agoraEngine = AgoraRtcEngineKit.sharedEngine(with: config, delegate: self)
    }

    func setupLocalVideo() {
        // Enable the video module
        agoraEngine?.enableVideo()
        // Start the local video preview
        //agoraEngine?.startPreview()
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView
        // Set the local video view
        agoraEngine?.setupLocalVideo(videoCanvas)
    }
    
    func         joinChannel() {
//        if !self.checkForPermissions() {
//            showMessage(title: "Error", text: "Permissions were not granted")
//            return
//        }

        let option = AgoraRtcChannelMediaOptions()

//        // Set the client role option as broadcaster or audience.
//        if self.userRole == .broadcaster {
//
//            let boolCoachVC = UserDefaults.standard.bool(forKey: ConstantUserDefaultTag.udFromCoachVC)
//            if boolCoachVC == true
//            {
//            option.clientRoleType = .broadcaster
//            }
//            else{
//            option.clientRoleType = .audience
//            }
//            setupLocalVideo()
//        } else {
//            option.clientRoleType = .audience
//        }
        
        // Set the client role option as broadcaster or audience.
        if self.userRole == .broadcaster {
            option.clientRoleType = .audience
            setupLocalVideo()
        } else {
            option.clientRoleType = .audience
            setupLocalVideo()
        }

        // For a video call scenario, set the channel profile as communication.
        option.channelProfile = .communication

        // Join the channel with a temp token. Pass in your token and channel name here
        let result = agoraEngine?.joinChannel(
            byToken: Agoaratoken, channelId: channelName, uid: 0, mediaOptions: option,
            joinSuccess: { (channel, uid, elapsed) in
                
                print("uid....\(uid)")
            }
        )
            // Check if joining the channel was successful and set joined Bool accordingly
        if (result == 0) {
            joined = true
            //showMessage(title: "Success", text: "Successfully joined the channel as \(self.userRole)")
        }
    }

    func leaveChannel() {
       // agoraEngine?.stopPreview()
        let result = agoraEngine?.leaveChannel(nil)
        // Check if leaving the channel was successful and set joined Bool accordingly
        if (result == 0) { joined = false }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        lblUser.text = String(UserData?.userdetails?.count ?? 0) + " User Here"
        return UserData?.userdetails?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCellUser", for: indexPath) as! AgoraCoachImageView
        
//        debugPrint(UserData?.userdetails?[indexPath.row].location as Any)
//        if let imgBreath = (UserData?.userdetails?[indexPath.row].location as Any) {
//            cell.imgView.sd_setImage(with: URL(string: imgBreath as! String), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//
//        }
        
        if let imgBreath = UserData?.userdetails?[indexPath.row].location {
            cell.imgView.sd_setImage(with: URL(string: imgBreath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//
           // cell.lblUserName.text = UserData?.userdetails?[indexPath.row].userName
//
        }

        
      //  convertedLocalStartTime = utcToLocal(dateStr: UserData?.results?[indexPath.row].sessionStarttime as Any as! String) ?? "text"
        
//        var imageString : String? = ""
//        imageString = (UserData?.userdetails?[indexPath.row].location as Any as? String)
//
////        if let imgBreath = UserData?.userdetails?[indexPath.row].location as Any as? String ?? "text"{
//        cell.imgView.sd_setImage(with: URL(string: imageString!), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
////
////            cell.lblSessionname.text = LiveData?.sessionList?[indexPath.row].sessionName
////            cell.LblCoachName.text = LiveData?.sessionList?[indexPath.row].coachname
////            cell.lblsessionDate.text = LiveData?.sessionList?[indexPath.row].sessionStarttime
     //   }
        

        
        // cell.imgView.image = UIImage(named:"orange_gratitude.png")
      //  let date = totalSquares[indexPath.item]
      //  cell.dayOfMonth.text = String(CalendarHelper().dayOfMonth(date: date))
      //  cell.dayOfweek.text = String(day[indexPath.item])
     //   cell.dayOfweek.text = String(days[indexPath.row].prefix(3))
     //   cell.dayOfMonth.text = String(totalSquares[indexPath.row])



        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {

    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {


    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let LiveArray = UserDataChat?.results else {return 0}
//
        return LiveArray.count // Here also

      // return 8

    }



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatView.dequeueReusableCell(withIdentifier: "ChatViewCell", for: indexPath) as! ChatViewCell
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
       // cell.backgroundColor = .clear
       // cell.vard.backgroundColor = .red "https://lh3.googleusercontent.com/a-/AOh14GjTRfUXjqE2M_NCVNiUQ8Mvf8W64-xo10U-sP7Emw=s96-c"

//        if let imgBreath = UserDataChat?.results?[indexPath.row].location {
//            cell.userImage.sd_setImage(with: URL(string: imgBreath), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
////
//            cell.userImage.layer.cornerRadius = cell.userImage.bounds.width / 2
//            cell.userImage.clipsToBounds = true
//        }
//
//        cell.UserName.text = UserDataChat?.results?[indexPath.row].userName
//        cell.UserTxt.text = UserDataChat?.results?[indexPath.row].text
//
//        cell.userTime.text = utcToLocal(dateStr: UserDataChat?.results?[indexPath.row].chatOn as Any as! String) ?? "text"

        cell.userImage.sd_setImage(with: URL(string: ReversedarrUserImage[indexPath.row]), placeholderImage: UIImage(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//
        cell.userImage.layer.cornerRadius = cell.userImage.bounds.width / 2
        cell.userImage.clipsToBounds = true
//       }

    cell.UserName.text = ReveresdarrName[indexPath.row]
   // cell.UserName.text = UserDataChat?.results?[indexPath.row].userName
   // cell.UserTxt.text = UserDataChat?.results?[indexPath.row].text ReveredarrText
    cell.UserTxt.text = ReveredarrText[indexPath.row]
    cell.userTime.text = utcToLocal(dateStr: ReversedarrTime[indexPath.row] as Any as! String) ?? "text"

        //debugPrint(UserDataChat?.results?[indexPath.row].chatOn ?? "test")

        return cell
    }





//func utcToLocal(dateStr: String) -> String? {
//    let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//
//        if let date = dateFormatter.date(from: dateStr) {
//            dateFormatter.timeZone = TimeZone.current
//            dateFormatter.dateFormat = "HH:mm"
//           // dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//
//            return dateFormatter.string(from: date)
//        }
//        return nil
//}

    @IBAction func btnSendAction(_ sender: Any) {
        let connectionStatus = ConnectionManager.shared.hasConnectivity()
        if (connectionStatus == false) {
            DispatchQueue.main.async {
                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
                return
            }
        } else {
            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
               // self.view.stopActivityIndicator()
                return
            }
            self.view.endEditing(true)


            
            //self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)

            let request = UserChatRequest(text: txtfeildChat.text, sessionId: sessionId)
            chatViewModel.postChatJoinData(Chat: request, token: token)
            
          //  var str : String? = sessionId
            
            debugPrint(sessionId)
            let time = String(UInt64(Date().timeIntervalSince1970 * 1000))
            print(time + ", Type :UserJoin")
            self.ref.child(sessionId).setValue(["value": time + ", Type :Chat"])
            txtfeildChat.text = ""
            //1672236276, Type :SessionEnd

            
        }
    }
    
    
    @IBAction func btnEndCall(_ sender: Any) {
        
        if isPaymentViewOpen == true
        {
        
        }
        else
        {
        guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
           // self.view.stopActivityIndicator()
            return
        }
        debugPrint("token--->",token)
        
//            let request = SignupResquest(name: txtUsername.text, userEmail: txtEmail.text, mobileNo: txtPhoneNo.text, password: txtPassword.text, dateOfBirth: "", FCMToken: FCMToken)
//            signupViewModel.signupUser(signupRequest: request)
        
        
        let time = String(UInt64(Date().timeIntervalSince1970 * 1000))

        print(time + ", Type :UserJoin")
        
        self.ref.child(sessionId).setValue(["value": time + ", Type :UserJoin"])
        let request = LiveJoinRequest(sessionId: sessionId, action: "Exiting")
        liveJoinViewModel.postLiveJoinData(date: request, token: token)
        countdownTimer?.invalidate()
        if isgoingtocall == true
        {
        
        }
        if isgoingtocall == false
        {
        self.navigationController?.popViewController(animated: true)
        }
        
        }
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {

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
            //      configuration.allowsDelayedPaymentMethods = false
        //    configuration.allowsDelayedPaymentMethods = false
     // configuration.applePay = .init(
       // merchantId: "merchant.com.BCS.Luvo",
       // merchantCountryCode: "US"
     // )

            self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret as! String, configuration: configuration)




            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {

                self.paymentSheet?.present(from: self) { paymentResult in
                  // MARK: Handle the payment result
                  switch paymentResult {
                  case .completed:
                    print("Your order is confirmed")
                      UserDefaults.standard.set(true, forKey: "IsfromSession")
                      self.isPaymentViewOpen = false
                      //DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        //  self.navigationController?.popViewController(animated: true)
                     // }
                  case .canceled:
                     // UserDefaults.standard.set(true, forKey: "IsfromSession")
                    print("Canceled!")
                      self.isPaymentViewOpen = false
                  case .failed(let error):
                    //  UserDefaults.standard.set(true, forKey: "IsfromSession")
                    print("Payment failed: \(error)")
                      self.isPaymentViewOpen = false
                  }
                }

            }

                //task.resume()




    }
    }
    
    @IBAction func btnPaymentOne(_ sender: Any) {

       self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
        self.payment(amount: "299")
    }
    
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
    }
    
}



extension AgoraStreamViewController: AgoraUserProfileModelDelegate
{
    func didReceiveAgoraUserProfileModelResponse(AgoraResponse: AgoraUserProfileImageResponse?) {
        
     //   self.view.stopActivityIndicator()
        
        if(AgoraResponse?.status != nil && AgoraResponse?.status?.lowercased() == ConstantStatusAPI.success) {
           
            debugPrint(AgoraResponse?.userdetails?.count as Any)
            UserData = AgoraResponse
            collectionViewImage.reloadData()
            
//            let LiveVC = ConstantStoryboard.LiveSessionList.instantiateViewController(withIdentifier: "AgoraStreamViewController") as! AgoraStreamViewController
//            LiveVC.sessionId = (liveResponse?.joinedsessionsdetails?.sessionId as Any) as! String
//            navigationController?.pushViewController(LiveVC, animated: true)
           
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
        
    }
    
    func didReceiveAgoraUserProfileModelError(statusCode: String?) {
        
    }
    
    
    
    
}
extension AgoraStreamViewController: AgoraRtcEngineDelegate {
    // Callback called when a new host joins the channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView
        agoraEngine?.setupRemoteVideo(videoCanvas)
    }
}
extension AgoraStreamViewController: LiveJoinViewModelDelegate
{
    func didReceiveLiveJoinResponse(liveResponse: LiveJoinResponse?) {
        
     //   self.view.stopActivityIndicator()
        
        if(liveResponse?.status != nil && liveResponse?.status?.lowercased() == ConstantStatusAPI.success) {
           
            debugPrint(liveResponse?.joinedsessionsdetails?.sessionId as Any)
            
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
        
    }
    
    func didReceiveLiveJoinError(statusCode: String?) {
        
        
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}
extension AgoraStreamViewController: AllUserChatModelDelegate
{
    func didReceiveAllUserChatResponse(ChatAllResponse: AllUserChatResponse?) {

        debugPrint(ChatAllResponse)

      //  self.view.stopActivityIndicator()

        if(ChatAllResponse?.status != nil && ChatAllResponse?.status?.lowercased() == ConstantStatusAPI.success) {



                debugPrint(ChatAllResponse?.results as Any)
               UserDataChat  = ChatAllResponse

            arrName.removeAll()
            arrText.removeAll()
            arrTime.removeAll()
            arrUserImage.removeAll()
            ReveredarrText.removeAll()
            ReveresdarrName.removeAll()
            ReversedarrTime.removeAll()
            ReversedarrUserImage.removeAll()
            for index in 0..<(UserDataChat?.results!.count ?? 0) {

               // debugPrint(UserDataChat?.results?.count as Any)
                arrName.append(UserDataChat?.results![index].userName! ?? "Tst")
                arrText.append(UserDataChat?.results![index].text! ?? "Tst")
                arrTime.append(UserDataChat?.results![index].chatOn! ?? "Tst")
                arrUserImage.append(UserDataChat?.results![index].location! ?? "Tst")

            }
            ReveredarrText = Array(arrText.reversed())
            ReveresdarrName =  Array(arrName.reversed())
            ReversedarrTime = Array(arrTime.reversed())
            ReversedarrUserImage = Array(arrUserImage.reversed())

            debugPrint(arrText)
            debugPrint(ReveredarrText)


            chatView .reloadData()

        }

    }

    func didReceiveAllUserChatModelError(statusCode: String?) {

    }


}

extension AgoraStreamViewController: UserchatWithCoachModelDelegate {
    func didReceiveUserchatWithCoachResponse(ChatResponse: UserchatWithCoachResponse?) {
     //   self.view.stopActivityIndicator()
    if(ChatResponse?.status != nil && ChatResponse?.status?.lowercased() == ConstantStatusAPI.success)
    {
    guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
   // self.view.stopActivityIndicator()
    return
  }
    
    debugPrint(ChatResponse?.results?.sessionId ?? "test")
        UserchatData.getChatDetails(token: token, SessionID: ChatResponse?.results?.sessionId ?? "test")
    
    
}
        
    }
    
    func didReceiveUserchatWithCoachError(statusCode: String?) {
        
        
    }
    
    
}

extension AgoraStreamViewController : UserDetailsForCallModelDelegate
{
    func didReceiveUserDetailsForCallModelResponse(UserDetailsForCall: UserDetailsForCallResponse?) {
        
       // DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
        self.showalertNew(Value: false)
        self.view.stopActivityIndicator()
        debugPrint(UserDetailsForCall?.details?.channelName ?? "")
        
        let callVC = ConstantStoryboard.Call.instantiateViewController(withIdentifier: "UserCallAgoraVC") as! UserCallAgoraVC
        callVC.AgoraAppId = UserDetailsForCall?.details?.agoraAppId ?? "test"
        callVC.Agoaratoken = UserDetailsForCall?.details?.agoraAccessToken ?? "test"
        callVC.channelName = UserDetailsForCall?.details?.channelName ?? "test"
        callVC.sessionId = UserDetailsForCall?.details?._id ?? "test"
        callVC.AgoraUId = UserDetailsForCall?.details?.agoraUId ?? "test"
        callVC.CallId = UserDetailsForCall?.details?.callId ?? "test"

        self.navigationController?.pushViewController(callVC, animated: false)

  
    }
    func didReceiveUserDetailsForCallModelError(statusCode: String?) {
        
    }
    
    
}
extension AgoraStreamViewController : StripePaymentDelegate
{
    func didReceiveStripeResponse(StripeResponse: Striperesponse?) {
        
        UserPaymentdetails = StripeResponse
        print(UserPaymentdetails ?? "Test")
    }
    
    func didReceiveStripeError(statusCode: String?) {
        
    }
    
    
}
extension AgoraStreamViewController : PaymentDataModelDelegate
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
