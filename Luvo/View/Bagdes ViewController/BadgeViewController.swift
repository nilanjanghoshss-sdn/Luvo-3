//
//  BadgeViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 28/12/21.
//

import UIKit

class BadgeViewController: UIViewController {
    
    @IBOutlet var tblMain: UITableView!
    @IBOutlet var btnClose: UIBUtton_Designable!
    @IBOutlet var btnQuestionMark: UIButton!
    
    var arrBadgeData: [BadgeModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("BADGES ARR----->\(arrBadgeData)")
        setupGUI()
        setupTableView()
    }
    
    func setupGUI() {
        btnClose.backgroundColor = UIColor.colorSetup()
        
        btnQuestionMark.layer.cornerRadius = btnQuestionMark.frame.size.width/2
        btnQuestionMark.layer.borderWidth = 1.5
        btnQuestionMark.layer.borderColor = UIColor.colorSetup().cgColor
        btnQuestionMark.tintColor = UIColor.colorSetup()
    }
    
    fileprivate func setupTableView() {
        tblMain.delegate = self
        tblMain.dataSource = self
        
        tblMain.separatorStyle = .none
//        tblMain.register(BadgeTableViewCell.self, forCellReuseIdentifier: "BadgeTableViewCell")
        tblMain.register(UINib.init(nibName: "BadgeTableViewCell", bundle: nil), forCellReuseIdentifier: "BadgeTableViewCell")
    }
    
    //MARK: Button Func-----------------
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func btnQuestionMark(_ sender: Any) {
        let howToEarnVC = ConstantStoryboard.badgesStoryboard.instantiateViewController(withIdentifier: "HowToEarnPointsViewController") as! HowToEarnPointsViewController
        howToEarnVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        present(howToEarnVC, animated: true)
    }
}

extension BadgeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arrData = arrBadgeData else { return 0 }
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
        guard let arrData = arrBadgeData else { return 0 }
        
        if let wins = arrData[indexPath.row].wins {
            if wins > 0 {
                return UITableView.automaticDimension
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BadgeTableViewCell", for: indexPath) as! BadgeTableViewCell
        
        guard let arrData = arrBadgeData else { return cell }
        
        if let wins = arrData[indexPath.row].wins {
            if wins > 0 {
                cell.updateBadgeTableData(cellData: arrData[indexPath.row])
            } else {
                cell.isHidden = true
            }
        }
        
        return cell
    }
}
