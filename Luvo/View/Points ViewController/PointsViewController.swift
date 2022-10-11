//
//  PointsViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 05/01/22.
//

import UIKit

fileprivate struct ConstantPointsEarnedLabel {
    static let today    = "Today's Points Earned"
    static let weekly   = "Weekly Points Earned"
    static let monthly  = "Monthly Points Earned"
    static let yearly   = "Yearly Points Earned"
}

struct TempPointsDataModel {
    let imgLogo: String?
    let date: String?
    let taskMsg: String?
    let pointsMsg: String?
}

fileprivate let BadgeCellHeight = 110

class PointsViewController: UIViewController {

    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    @IBOutlet var imgRippleBackground: UIImageView!
    @IBOutlet var imgRipple: UIImageView!
    @IBOutlet var lblTotalPointsEarned: UILabel!
    @IBOutlet var lblTotalPoints: UILabel!
    @IBOutlet var btnToday: UIBUtton_Designable!
    @IBOutlet var btnWeekly: UIBUtton_Designable!
    @IBOutlet var btnMonthly: UIBUtton_Designable!
    @IBOutlet var btnYearly: UIBUtton_Designable!
    @IBOutlet var lblPointsEarned: UILabel!
    @IBOutlet var tblMain: UITableView!
    
    //---Float for storing height constant
    var constantViewMainScrollStoreConstant: CGFloat?
    var constantTblHeightStoreConstant: CGFloat?
    
    var startDate = ""
    var endDate = ""
    
    @IBOutlet var constantTblHeight: NSLayoutConstraint!
    @IBOutlet var constantViewMainScroll: NSLayoutConstraint!
    
    
    fileprivate var arrPointData: [TempPointsDataModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup navbar
        setupCustomNavBar()

        setupGUI()
        setupTableView()
        StoreConstant()
        getInitialData()
        
        //Temp data creation----
        createTempData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(FAQViewController.setupNotificationBadge),
                                               name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge),
                                               object: nil)
        
        setupNotificationBadge()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        ///Dynamically adjust tableView height according to the data
//        ///If local data then do it in viewDidAppeaar()
//        self.view.layoutIfNeeded()
//        self.constantTblHeight.constant = self.tblMain.contentSize.height
//        constantViewMainScroll.constant = constantViewMainScroll.constant + tblMain.contentSize.height + 20
//        self.view.layoutIfNeeded()
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(ConstantLocalNotification.updateNotificationBadge), object: nil)
    }
    
    //MARK: Setup Custom Navbar------------
    func setupCustomNavBar() {
        //Hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: true)
        viewCustomNavBar.roundCornersBottomLeftRight(radius: 15)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewCustomNavBar.shadowLayerView()
    }
    
    //MARK: Nav Button Func-------------
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNotification(_ sender: Any) {
        let notifyVC = ConstantStoryboard.notificationStoryboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        navigationController?.pushViewController(notifyVC, animated: true)
    }
    //-----------------------------
    
    //temporary-----
    func createTempData() {
        arrPointData = [TempPointsDataModel]()
        arrPointData?.append(TempPointsDataModel(imgLogo: "Group 5991", date: "25/08/2021", taskMsg: "Completed 25,000 Steps This Week.", pointsMsg: "You Earn 1 Point."))
        arrPointData?.append(TempPointsDataModel(imgLogo: "Group 9047", date: "25/08/2021", taskMsg: "Drank 7 Litters Water This Week.", pointsMsg: "You Earn 1 Point."))
        arrPointData?.append(TempPointsDataModel(imgLogo: "Group 9141", date: "24/08/2021", taskMsg: "You Wisely Used 3 Hours This Week.", pointsMsg: "You Earn 1 Point."))
        
        arrPointData?.append(TempPointsDataModel(imgLogo: "Group 5991", date: "25/08/2021", taskMsg: "Completed 25,000 Steps This Week.", pointsMsg: "You Earn 1 Point."))
        arrPointData?.append(TempPointsDataModel(imgLogo: "Group 9047", date: "25/08/2021", taskMsg: "Drank 7 Litters Water This Week.", pointsMsg: "You Earn 1 Point."))
        arrPointData?.append(TempPointsDataModel(imgLogo: "Group 9141", date: "24/08/2021", taskMsg: "You Wisely Used 3 Hours This Week.", pointsMsg: "You Earn 1 Point."))
        
        arrPointData?.append(TempPointsDataModel(imgLogo: "Group 5991", date: "25/08/2021", taskMsg: "Completed 25,000 Steps This Week.", pointsMsg: "You Earn 1 Point."))
        arrPointData?.append(TempPointsDataModel(imgLogo: "Group 9047", date: "25/08/2021", taskMsg: "Drank 7 Litters Water This Week.", pointsMsg: "You Earn 1 Point."))
        arrPointData?.append(TempPointsDataModel(imgLogo: "Group 9141", date: "24/08/2021", taskMsg: "You Wisely Used 3 Hours This Week.", pointsMsg: "You Earn 1 Point."))
        
        arrPointData?.append(TempPointsDataModel(imgLogo: "Group 5991", date: "25/08/2021", taskMsg: "Completed 25,000 Steps This Week.", pointsMsg: "You Earn 1 Point."))
        arrPointData?.append(TempPointsDataModel(imgLogo: "Group 9047", date: "25/08/2021", taskMsg: "Drank 7 Litters Water This Week.", pointsMsg: "You Earn 1 Point."))
        arrPointData?.append(TempPointsDataModel(imgLogo: "Group 9141", date: "24/08/2021", taskMsg: "You Wisely Used 3 Hours This Week.", pointsMsg: "You Earn 1 Point."))
        
        tblMain.reloadData()
        AdjustTableViewHeight(arrayCount: arrPointData?.count ?? 0)
    }
    
    //MARK: Setup GUI-------------------
    fileprivate func setupGUI() {
        imgRippleBackground.tintColor = UIColor.colorSetup()
        lblTotalPointsEarned.textColor = UIColor.white
        
        //Initial button setup
        btnToday.backgroundColor = UIColor.clear
        btnToday.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnWeekly.backgroundColor = UIColor.clear
        btnWeekly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnMonthly.backgroundColor = UIColor.clear
        btnMonthly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnYearly.backgroundColor = UIColor.clear
        btnYearly.setTitleColor(UIColor.colorSetup(), for: .normal)
    }
    
    fileprivate func setupTableView() {
        tblMain.delegate = self
        tblMain.dataSource = self
        
        tblMain.separatorStyle = .none
//        tblMain.register(BadgeTableViewCell.self, forCellReuseIdentifier: "BadgeTableViewCell")
        tblMain.register(UINib.init(nibName: "BadgeTableViewCell", bundle: nil), forCellReuseIdentifier: "BadgeTableViewCell")
    }
    
    //MARK: Store Constraint----------
    func StoreConstant() {
        constantViewMainScrollStoreConstant = self.constantViewMainScroll.constant;
        constantTblHeightStoreConstant = self.constantTblHeight.constant;
    }
    
    //MARK: Get Initial Data-----------
    fileprivate func getInitialData() {
        lblPointsEarned.text = ConstantPointsEarnedLabel.today
        getStatData(startDate: Date().formatDate(date: Date()), endDate: Date().formatDate(date: Date()))
    }

    //MARK: Button Func-----------------
    @IBAction func btnToday(_ sender: Any) {
        btnToday.backgroundColor = UIColor.colorSetup()
        btnToday.setTitleColor(.white, for: .normal)
        
        btnWeekly.backgroundColor = UIColor.clear
        btnWeekly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnMonthly.backgroundColor = UIColor.clear
        btnMonthly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnYearly.backgroundColor = UIColor.clear
        btnYearly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        startDate = Date().formatDate(date: Date())
        endDate = Date().formatDate(date: Date())
        
        lblPointsEarned.text = ConstantPointsEarnedLabel.today
        getStatData(startDate: startDate, endDate: endDate)
    }
    
    @IBAction func btnWeekly(_ sender: Any) {
        btnToday.backgroundColor = UIColor.clear
        btnToday.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnWeekly.backgroundColor = UIColor.colorSetup()
        btnWeekly.setTitleColor(.white, for: .normal)
        
        btnMonthly.backgroundColor = UIColor.clear
        btnMonthly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnYearly.backgroundColor = UIColor.clear
        btnYearly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        startDate = Date().formatDate(date: Date.sevenDayPrevious)
        endDate = Date().formatDate(date: Date())
        
        lblPointsEarned.text = ConstantPointsEarnedLabel.weekly
        getStatData(startDate: startDate, endDate: endDate)
    }
    
    @IBAction func btnMonthly(_ sender: Any) {
        btnToday.backgroundColor = UIColor.clear
        btnToday.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnWeekly.backgroundColor = UIColor.clear
        btnWeekly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnMonthly.backgroundColor = UIColor.colorSetup()
        btnMonthly.setTitleColor(.white, for: .normal)
        
        btnYearly.backgroundColor = UIColor.clear
        btnYearly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        startDate = Date().formatDate(date: Date.oneMonthPrevious)
        endDate = Date().formatDate(date: Date())
        
        lblPointsEarned.text = ConstantPointsEarnedLabel.monthly
        getStatData(startDate: startDate, endDate: endDate)
    }
    
    @IBAction func btnYearly(_ sender: Any) {
        btnToday.backgroundColor = UIColor.clear
        btnToday.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnWeekly.backgroundColor = UIColor.clear
        btnWeekly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnMonthly.backgroundColor = UIColor.clear
        btnMonthly.setTitleColor(UIColor.colorSetup(), for: .normal)
        
        btnYearly.backgroundColor = UIColor.colorSetup()
        btnYearly.setTitleColor(.white, for: .normal)
        
        startDate = Date().formatDate(date: Date.oneYearPrevious)
        endDate = Date().formatDate(date: Date())
        
        lblPointsEarned.text = ConstantPointsEarnedLabel.yearly
        getStatData(startDate: startDate, endDate: endDate)
    }
    
    //MARK: - API Call
    func getStatData(startDate: String, endDate: String) {
//        print("Start date--->\(startDate) End date--->\(endDate)")
//        //api call here
//        let connectionStatus = ConnectionManager.shared.hasConnectivity()
//        if (connectionStatus == false) {
//            DispatchQueue.main.async {
//                self.showAlert(title: ConstantAlertTitle.LuvoAlertTitle, message: ConstantInternetConnectionStatus.InternetOffline)
//                return
//            }
//        } else {
//            guard let token = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udToken) as? String else {
//                self.view.stopActivityIndicator()
//                return
//            }
//            let request = ExerciseStatRequest(startDate: startDate, endDate: endDate)
//            self.view.startActivityIndicator(title: ConstantActivityIndicatorMessage.pkLoading, color: .white)
////            exerciseStatViewModel.postGetExerciseStat(exerciseStatRequest: request, token: token)
        ///Dynamically adjust tableView height according to the data
        ///If API data then do it after getting JSON response
        //DispatchQueue.main.async {
        //        self.tableView.reloadData()
        //        self.view.layoutIfNeeded()
        //        self.heightConstraint.constant = self.tableView.contentSize.height
        //        self.view.layoutIfNeeded()
        // }
//        }
    }
    
    //MARK: -----Notification Setup
    @objc func setupNotificationBadge() {
        guard let badgeCount = UserDefaults.standard.value(forKey: ConstantUserDefaultTag.udNotificationBadge) as? Int else { return }
        
        if badgeCount != 0 {
            viewNotificationCount.isHidden = false
            lblNotificationLabel.text = "\(badgeCount)"
        } else {
            viewNotificationCount.isHidden = true
            lblNotificationLabel.text = "0"
        }
        print("BADGE COUNT-----\(badgeCount)")
    }
}

extension PointsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arrData = arrPointData else { return 0 }
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PointsTableViewCell", for: indexPath) as! PointsTableViewCell
        
        guard let arrData = arrPointData else { return cell }
        cell.updatePointsTableData(cellData: arrData[indexPath.row])
        
        return cell
    }
    
    //MARK: Adjust TableView Height
    func AdjustTableViewHeight(arrayCount: Int) {
        let height: CGFloat = CGFloat(BadgeCellHeight * arrayCount)
        
        self.constantTblHeight.constant = height
        
        if let heightConstant = constantTblHeightStoreConstant {
            self.constantViewMainScroll.constant = (self.constantViewMainScroll.constant + height) - heightConstant
        }
    }
}
