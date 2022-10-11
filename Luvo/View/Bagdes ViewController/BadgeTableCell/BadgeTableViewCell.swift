//
//  BadgeTableViewCell.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 28/12/21.
//

import UIKit

class BadgeTableViewCell: UITableViewCell {

    @IBOutlet var imgLogo: UIImageView!
    @IBOutlet var lblMsg: UILabel!
    @IBOutlet var lblBadgePoint: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgLogo.layer.cornerRadius = 5.0
        imgLogo.backgroundColor = UIColor.colorSetup()
        lblBadgePoint.layer.cornerRadius = 5.0
        lblBadgePoint.clipsToBounds = true
        lblBadgePoint.backgroundColor = UIColor.colorSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func updateBadgeTableData(cellData: BadgeModel) {
//        if let img = cellData.iconImg {
//            let imagePath = Common.WebserviceAPI.baseURL + img
//            imgLogo.sd_setImage(with: URL(string: imagePath), placeholderImage: UIImage.init(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
//        }
        if let img = cellData.location {
            imgLogo.sd_setImage(with: URL(string: img), placeholderImage: UIImage.init(named: ConstantImageSet.placeholder), options: .refreshCached, context: nil)
        }
        if let msg = cellData.title {
            lblMsg.text = msg
        }
        if let point = cellData.wins {
            lblBadgePoint.text = "\(point)"
        }
    }
    
}
