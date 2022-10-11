//
//  CoachViewController.swift
//  Luvo
//
//  Created by BEASiMAC on 04/07/22.
//

import UIKit

class CoachViewController: UIViewController,UITextFieldDelegate, SideMenuDelegate {
    func didSelectViewProfile() {
        
    }
    
    func didSelectSideMenu(selectedIndex: Int, name: String) {
        
    }
    

    //Custom Navbar
    @IBOutlet var viewCustomNavBar: UIView!
    @IBOutlet var viewNotificationCount: UIView_Designable!
    @IBOutlet var lblNotificationLabel: UILabel!
    
    
    //Button
    @IBOutlet var btnSearch: UIBUtton_Designable!
    
    //View
    @IBOutlet var viewTopBanner: UIView!
    @IBOutlet var txtSearch: UITextField!
    
    //Label
    @IBOutlet var lblQuotes: UILabel!
    @IBOutlet var lblQuoteAuthor: UILabel!
    
    
    private var sideMenu:CoachSideViewController!
    private var drawerTransition:DrawerTransition!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setupCustomNavBar()
        setupSideMenu()
    }
    
    @IBAction func btnSideMenu(_ sender: Any) {
        drawerTransition.presentDrawerViewController(animated: true)
    }
    
    @IBAction func btnNotification(_ sender: Any) {
        let notifyVC = ConstantStoryboard.notificationStoryboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        navigationController?.pushViewController(notifyVC, animated: true)
    }

    @IBAction func btnSearch(_ sender: Any) {
//        let searchVC = ConstantStoryboard.searchStoryboard.instantiateViewController(withIdentifier: "SearchMeditationViewController") as! SearchMeditationViewController
//        searchVC.messageQuetes = lblQuotes.text!
//        searchVC.authorName = lblQuoteAuthor.text!
//        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    //MARK: - Setup Custom Navbar
    func setupCustomNavBar() {
        //Hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: true)
        viewCustomNavBar.roundCornersBottomLeftRight(radius: 15)
    }
    
    func setupSideMenu() {
        sideMenu = ConstantStoryboard.CoachSideMenu.instantiateViewController(withIdentifier: "CoachSideViewController") as? CoachSideViewController
        sideMenu.delegate = self
        drawerTransition = DrawerTransition(target: self, drawer: sideMenu)
    }
}
