//
//  WelcomeViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 03/09/21.
//

import UIKit

class WelcomeViewController: UIViewController, JukeboxDelegate {
    
    @IBOutlet var btnNext: UIBUtton_Designable!
    
    let jukebox = Jukebox()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNavBar()
//        setupNextButton()
        playBackgroundMusic()

        jukebox.jukeboxDelegate = self        
    }
    
    //MARK: - Hide navigation bar
    func hideNavBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        //Show navigation bar
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    
//    //MARK: - Setup Next Button
//    func setupNextButton() {
//        self.btnNext.backgroundColor = .lightGray
//        self.btnNext.isUserInteractionEnabled = false
//    }
    
    //MARK: - Background Music
    func playBackgroundMusic() {
        jukebox.playBackgroundMusic()
    }

    //MARK: - Button Func
    @IBAction func btnNext(_ sender: Any) {
        jukebox.stopBackgroundMusic()
        
        let viewCon = ConstantStoryboard.mainStoryboard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        navigationController?.pushViewController(viewCon, animated: true)
    }
    
    //MARK: - Delegate
    func jukeboxDidFinishPlaying() {
        self.btnNext.backgroundColor = UIColor.customOrangeColor()
        self.btnNext.isUserInteractionEnabled = true
    }
    
}
