//
//  NotificationViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-25.
//

import UIKit

class NotificationViewController: UIViewController {
    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!

    @IBOutlet var tblMain: UITableView!
    
    var notificationViewModel = NotificationViewModel()
    var arrNotificationData: [NotificationDetails]?
    
    var boolUpdate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup navbar
        setupCustomNavBar()
        
        notificationViewModel.delegate = self
        
        setupTableView()
        
        boolUpdate = true
        getNotificationData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(ConstantLocalNotification.updateNotificationList), object: nil)
    }
    
    //MARK: Setup Custom Navbar--------------
    func setupCustomNavBar() {
        //Hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: true)
        viewCustomNavBar.roundCornersBottomLeftRight(radius: 15)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(NotificationViewController.updateNotification),
                                               name: NSNotification.Name(ConstantLocalNotification.updateNotificationList),
                                               object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewCustomNavBar.shadowLayerView()
    }
    
    //MARK: - Nav Button Func
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    //-----------------------------
    
    //MARK: ----Setup TableView
    fileprivate func setupTableView() {
        tblMain.delegate = self
        tblMain.dataSource = self
        
        tblMain.register(UINib.init(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
    }
    
    //MARK: ----Get Notification Data
    fileprivate func getNotificationData() {
        //api call here
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
            notificationViewModel.getNotificationList(token: token)
        }
    }
    
    //MARK: -----Notification Setup
    @objc func updateNotification() {
        getNotificationData()
    }
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arrData = arrNotificationData else { return 0 }
        return arrData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        
        guard let arrData = arrNotificationData else { return cell }
        
        cell.updateNotificationCellData(response: arrData[indexPath.row])
        
        return cell
    }
}

extension NotificationViewController: NotificationDelegate {
    func didReceiveNotificationGetDataResponse(notificationGetDataResponse: NotificationResponse?) {
        self.view.stopActivityIndicator()

        if(notificationGetDataResponse?.status != nil && notificationGetDataResponse?.status?.lowercased() == ConstantStatusAPI.success) {
//            dump(notificationGetDataResponse)

            if let arrData = notificationGetDataResponse?.notification {
                arrNotificationData = [NotificationDetails]()
                arrNotificationData = arrData

                tblMain.reloadData()
            }
            
            if boolUpdate {
                boolUpdate = false
                
                //Reset the badge count over the app icon on device.
                UIApplication.shared.applicationIconBadgeNumber = 0
                
                //Reset notification badge count
                UserDefaults.standard.set(0, forKey: ConstantUserDefaultTag.udNotificationBadge)
                NotificationCenter.default.post(name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge), object: nil)
            }
            
        } else {
            showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantStatusAPI.failed)
        }
    }
    
    func didReceiveNotificationDataError(statusCode: String?) {
        self.view.stopActivityIndicator()
        self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: statusCode ?? ConstantAlertTitle.ErrorAlertTitle)
    }
}
