//
//  WelcomeMythFactViewController.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 08/09/21.
//

import UIKit

class WelcomeMythFactViewController: UIViewController {
    
    let arrImageSet = [UIImage.init(named: "pager1"),
                       UIImage.init(named: "pager2")]
    
    @IBOutlet var colViewSlider: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    var timer = Timer()
    var counter = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()

        pageControl.numberOfPages = arrImageSet.count
        pageControl.currentPage = 0
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 6.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer.invalidate()
    }
    
    @IBAction func btnNext(_ sender: Any) {
        let introVC = ConstantStoryboard.mainStoryboard.instantiateViewController(identifier: "IntroViewController") as! IntroViewController
        self.navigationController?.pushViewController(introVC, animated: true)
    }
}
