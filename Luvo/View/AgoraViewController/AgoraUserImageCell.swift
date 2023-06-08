//
//  AgoraUserImageCell.swift
//  Luvo
//
//  Created by Nilanjan Ghosh on 11/12/22.
//

import UIKit

class AgoraUserImageCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews()
    {
        super.layoutSubviews()

       // self.imgView.layoutIfNeeded()       // add this
        self.imgView.layer.cornerRadius = frame.size.width/10
        self.imgView.layer.borderWidth = 3
        self.imgView.layer.borderColor = UIColor.black.cgColor
       // self.imgView.clipsToBounds = true
        
//        imgVProfile.layer.cornerRadius = imgVProfile.frame.size.width / 2
//        imgVProfile.layer.borderWidth = 3
//        imgVProfile.layer.borderColor = UIColor.white.cgColor

    }
   
}
