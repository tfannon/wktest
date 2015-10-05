//
//  NotificationHeaderCell.swift
//  ParsePush
//
//  Created by Tommy Fannon on 10/5/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import UIKit

class NotificationHeaderCell: UITableViewCell {

    @IBOutlet weak var imageNotificationType: UIImageView!
    @IBOutlet weak var labelNotificationType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
