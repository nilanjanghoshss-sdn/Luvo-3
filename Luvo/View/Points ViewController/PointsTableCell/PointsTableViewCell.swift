//
//  PointsTableViewCell.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 05/01/22.
//

import UIKit

class PointsTableViewCell: UITableViewCell {

    @IBOutlet var imgLogo: UIImageView!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblMsg: UILabel!
    @IBOutlet var lblPoint: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgLogo.layer.cornerRadius = imgLogo.frame.size.width/2
        imgLogo.backgroundColor = UIColor.colorSetup()
        lblPoint.textColor = UIColor.colorSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func updatePointsTableData(cellData: TempPointsDataModel) {
        if let date = cellData.date {
            lblDate.text = date
        }
        if let img = cellData.imgLogo {
            imgLogo.image = UIImage(named: img)
        }
        if let taskMsg = cellData.taskMsg {
            lblMsg.text = taskMsg
        }
        if let pointMsg = cellData.pointsMsg {
            lblPoint.text = pointMsg
        }
    }
    
}
