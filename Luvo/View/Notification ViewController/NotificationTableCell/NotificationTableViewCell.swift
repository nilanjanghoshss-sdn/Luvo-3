//
//  NotificationTableViewCell.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 2022-01-25.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet var viewBackground: UIView_Designable!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewBackground.borderColor = UIColor.colorSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateNotificationCellData(response: NotificationDetails) {
        if let title = response.title {
            lblTitle.text = title
        }
        if let message = response.message {
            lblDesc.text = message
        }
        if let date = response.add_date {
            let addDate = Date().UTCFormatter(date: date)
            lblDate.text = dataFormatter(date: addDate)
        }
    }
    
    fileprivate func dataFormatter(date: Date) -> String {
        let df = DateFormatter()
        df.timeZone = TimeZone.current
        df.dateFormat = "MMM dd, yyyy"
        
        return df.string(from: date)
    }
}
