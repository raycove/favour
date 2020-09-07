//
//  MessagesTableViewCell.swift
//  favour
//
//  Created by Ray Cove on 01/10/2017.
//  Copyright © 2017 Ray Cove. All rights reserved.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {

    @IBOutlet weak var messagesimage: UIImageView!
    @IBOutlet weak var messageslabel: UILabel!
    @IBOutlet weak var messagesseen: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
